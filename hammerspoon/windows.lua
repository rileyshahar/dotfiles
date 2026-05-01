require("hs.window")

-- config
hs.window.animationDuration = 0

local function focusNextVisibleWindow()
	local current = hs.window.focusedWindow()

	local wins = hs.window.orderedWindows()

	if #wins == 0 then
		return
	end

	for i, win in ipairs(wins) do
		if current and win:id() == current:id() then
			local nextIndex = i + 1

			if nextIndex > #wins then
				nextIndex = 1
			end

			wins[nextIndex]:focus()

			return
		end
	end

	wins[1]:focus()
end

hs.hotkey.bind("alt", "l", focusNextVisibleWindow)
hs.hotkey.bind("alt", "h", focusNextVisibleWindow)

-- config
local function frontmostWindow()
	return hs.window.frontmostWindow() or hs.window.focusedWindow()
end

function fullscreenFrontmost()
	local w = frontmostWindow()
	if w then
		w:setFullScreen(true)
	end
end

function sendToBack()
	local w = frontmostWindow()
	if not w then
		return
	end
	w:sendToBack()
end

hs.hotkey.bind({ "alt", "ctrl" }, "j", function()
	sendToBack()
end)

hs.hotkey.bind({ "alt", "ctrl" }, "h", function()
	local win = frontmostWindow()

	if win then
		win:moveToUnit({ x = 0, y = 0, w = 0.5, h = 1 }, 0)
	end
end)

hs.hotkey.bind({ "alt", "ctrl" }, "l", function()
	local win = frontmostWindow()

	if win then
		win:moveToUnit({ x = 0.5, y = 0, w = 0.5, h = 1 }, 0)
	end
end)

hs.hotkey.bind({ "alt", "ctrl" }, "k", function()
	local win = frontmostWindow()

	if win then
		win:moveToUnit({ x = 0, y = 0, w = 1, h = 1 }, 0)
	end
end)

return {
	fullscreenFrontmost = fullscreenFrontmost,
	sendToBack = sendToBack,
}
