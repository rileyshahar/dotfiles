local ax = hs.axuielement
local system = ax.systemWideElement()
local karabiner_cli = "/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"

currentMode = 0
lastInput = nil

local modes = {
	app = 0,
	ins = 1,
	nrm = 2,
	vis = 3,
	ign = 4,
}
local modeLabels = {
	app = "APP",
	ins = "INS",
	nrm = "NRM",
	vis = "VIS",
	ign = "IGN",
}
local function updateWidget(mode)
	if mode == "ign" then
		hideWidget()
	end
	setWidgetAndShow(modeLabels[mode])
end

local function _setMode(mode)
	currentMode = mode

	hs.task
		.new(karabiner_cli, nil, {
			"--set-variables",
			string.format('{"mode":%d}', modes[mode]),
		})
		:start()

	updateWidget(mode)
end

function setMode(mode)
	if mode == lastMode then
		return
	end
	if modes[mode] == nil then
		hs.alert("error: invalid mode ")
		hs.alert(mode)
		return
	end
	_setMode(mode)
end

local function focusedElement()
	return system:attributeValue("AXFocusedUIElement")
end

-- Try to get the window for an element:
-- 1) AXWindow attribute
-- 2) climb parents and look for AXWindow
-- 3) fall back to hs.window.focusedWindow()
local function windowForElement(el)
	if not el then
		return nil
	end

	local win = el:attributeValue("AXWindow")
	if win then
		return win
	end

	local cur = el
	for _ = 1, 30 do
		cur = cur:attributeValue("AXParent")
		if not cur then
			break
		end
		win = cur:attributeValue("AXWindow")
		if win then
			return win
		end
	end

	local hswin = hs.window.focusedWindow()
	if hswin then
		return ax.windowElement(hswin)
	end

	return nil
end

-- Depth-limited tree walk
local function walk(el, depth, fn)
	if not el or depth <= 0 then
		return false
	end
	if fn(el) then
		return true
	end

	local kids = el:attributeValue("AXChildren")
	if type(kids) == "table" then
		for _, c in ipairs(kids) do
			if walk(c, depth - 1, fn) then
				return true
			end
		end
	end

	return false
end

local function isMailComposeWindow(winEl)
	local app = hs.application.frontmostApplication()
	if not app or app:bundleID() ~= "com.apple.mail" then
		return false
	end
	if not winEl then
		return false
	end

	local hasSend = false
	local hasComposeFields = false

	walk(winEl, 12, function(node)
		local role = node:attributeValue("AXRole") or ""

		-- 1) Find a Send-ish control
		if role == "AXButton" or role == "AXToolbarButton" then
			local title = (node:attributeValue("AXTitle") or "")
			local ident = (node:attributeValue("AXIdentifier") or "")
			local help = (node:attributeValue("AXHelp") or "")
			local hay = (title .. " " .. ident .. " " .. help):lower()
			if hay:find("send", 1, true) then
				hasSend = true
			end
		end

		-- 2) Find editable compose header fields (To/Cc/Bcc/Subject)
		if role == "AXTextField" or role == "AXComboBox" then
			local editable = node:attributeValue("AXEditable")
			-- some elements don't expose AXEditable; treat nil as "unknown" not true
			if editable == true then
				local desc = (node:attributeValue("AXDescription") or "")
				local title = (node:attributeValue("AXTitle") or "")
				local ident = (node:attributeValue("AXIdentifier") or "")
				local help = (node:attributeValue("AXHelp") or "")
				local hay = (desc .. " " .. title .. " " .. ident .. " " .. help):lower()

				if
					hay:find("to", 1, true)
					or hay:find("cc", 1, true)
					or hay:find("bcc", 1, true)
					or hay:find("subject", 1, true)
				then
					hasComposeFields = true
				end
			end
		end

		-- keep walking; we decide after traversal
		return false
	end)

	return hasSend and hasComposeFields
end

local textRoles = {
	AXTextField = true,
	AXTextArea = true,
	AXSearchField = true,
	AXComboBox = true,
}

-- extra checks to see if we're in an input field
local override_inputs = {
	-- Apple Mail compose body
	function(app, _, el, role)
		if role == "AXWebArea" then
			if app and app:bundleID() == "com.apple.mail" then
				local desc = el:attributeValue("AXDescription")
				if desc == "message body" then
					return true
				end
			end
		end
		return false
	end,
}

local function inTextInput(el)
	if not el then
		return false
	end

	local role = el:attributeValue("AXRole")

	-- Normal text fields
	if role and textRoles[role] then
		return true
	end

	local app = hs.application.frontmostApplication()
	local win = hs.window.frontmostWindow()

	-- ignores
	for _, check in ipairs(override_inputs) do
		if type(check) == "string" then
			if app and app:bundleID() == check then
				return true
			end
		else
			if check(app, win, el, role) then
				return true
			end
		end
	end

	return false
end

kbTimer = hs.timer.doEvery(0.2, function()
	local ok, err = pcall(function()
		local el = focusedElement()
		if inTextInput(el) and lastInput ~= true then
			setMode("ins")
			lastInput = true
		elseif not inTextInput(el) and lastInput ~= false then
			setMode("app")
			lastInput = false
		end
	end)
	if not ok then
		print("timer error:", err)
	end
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "I", function()
	local app = hs.application.frontmostApplication()
	local el = focusedElement()
	local win = windowForElement(el)

	print("Frontmost:", app and app:bundleID())
	print("Focused AXTitle:", el and el:attributeValue("AXTitle"))
	print("Focused AXRole:", el and el:attributeValue("AXRole"))
	print("Focused AXSubrole:", el and el:attributeValue("AXSubrole"))
	print("Focused AXDescription:", el and el:attributeValue("AXDescription"))
	print("Focused AXRoleDescription:", el and el:attributeValue("AXRoleDescription"))
	print("Focused AXIdentifier:", el and el:attributeValue("AXIdentifier"))
	print("Focused AXHelp:", el and el:attributeValue("AXHelp"))
	print("Focused AXEditable:", el and el:attributeValue("AXEditable"))

	if not win then
		print("Derived window: nil")
		return
	end

	print("Derived window title:", win:attributeValue("AXTitle"))
	print("Looks like compose?:", isMailComposeWindow(win))
end)

return {
	setMode = setMode,
}
