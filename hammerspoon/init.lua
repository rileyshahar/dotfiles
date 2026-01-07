require("hs.ipc")
require("hs.window")
require("detect_input")
require("widget")

-- apple script
hs.allowAppleScript(true)

-- hammerflow
hs.loadSpoon("Hammerflow")
spoon.Hammerflow.loadFirstValidTomlFile({
	"hammerflow.toml",
})
-- optionally respect auto_reload setting in the toml config.
if spoon.Hammerflow.auto_reload then
	hs.loadSpoon("ReloadConfiguration")
	-- set any paths for auto reload
	-- spoon.ReloadConfiguration.watch_paths = {hs.configDir, "~/path/to/my/configs/"}
	spoon.ReloadConfiguration:start()
end

-- window management
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

hs.hotkey.bind({ "cmd", "alt" }, "B", function()
	sendToBack()
end)

_G.exports = {
	setWidgetAndShow = setWidgetAndShow,
	showWidget = showWidget,
	hideWidget = hideWidget,
	fullscreenFrontmost = fullscreenFrontmost,
	sendToBack = sendToBack,
	setMode = setMode,
}
