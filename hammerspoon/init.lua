require("hs.ipc")
require("hs.window")
require("utils")
require("detect_input")
require("widget")
require("todoist")
require("windows")

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

_G.exports = {
	setWidgetAndShow = setWidgetAndShow,
	showWidget = showWidget,
	hideWidget = hideWidget,
	fullscreenFrontmost = fullscreenFrontmost,
	sendToBack = sendToBack,
	setMode = setMode,
}
