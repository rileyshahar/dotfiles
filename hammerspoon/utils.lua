function ToggleDarkMode()
	hs.osascript.applescript([[
    tell application "System Events"
      tell appearance preferences
        set dark mode to not dark mode
      end tell
    end tell
  ]])
end

function ToggleMuted()
	hs.eventtap.event.newSystemKeyEvent("MUTE", true):post()
	hs.eventtap.event.newSystemKeyEvent("MUTE", false):post()
end

return {
	ToggleDarkMode = ToggleDarkMode,
	ToggleMuted = ToggleMuted,
}
