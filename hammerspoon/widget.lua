-- vim mode widget

local widget = {}

-- Appearance / sizing knobs
widget.text = ""
widget.font = nil
widget.textSize = 16
widget.paddingX = 14
widget.paddingY = 10
widget.margin = 12
widget.extraW = 6 -- small buffer (measurement can be a few pts off)
widget.extraH = 2

-- Safety limits (so a huge string doesn't run off-screen)
widget.minW = 0
widget.maxWFrac = 0.60 -- at most 60% of the usable screen width

-- Pinning behavior
widget.screenMode = "main" -- "mouse" or "main"

local function targetScreen()
	return hs.screen.mainScreen()
end

local function usableFrame()
	return targetScreen():frame() -- excludes menu bar + dock
end

local function clamp(n, lo, hi)
	if n < lo then
		return lo
	end
	if n > hi then
		return hi
	end
	return n
end

local function computeBottomRightFrame(w, h)
	local sf = usableFrame()
	local x = sf.x + sf.w - w - widget.margin
	local y = sf.y + sf.h - h - widget.margin
	return { x = x, y = y, w = w, h = h }
end

-- Create canvas (temporary size; we'll immediately auto-fit)
widget.canvas = hs.canvas.new(computeBottomRightFrame(200, 44))
widget.canvas:level(hs.canvas.windowLevels.status)

widget.canvas:behavior({
	hs.canvas.windowBehaviors.canJoinAllSpaces,
	hs.canvas.windowBehaviors.stationary,
	hs.canvas.windowBehaviors.ignoresCycle,
	hs.canvas.windowBehaviors.fullScreenAuxiliary,
})

widget.canvas[1] = {
	id = "bg",
	type = "rectangle",
	action = "fill",
	fillColor = { white = 0, alpha = 0.80 },
	strokeColor = { white = 1, alpha = 0.12 },
	strokeWidth = 1,
	roundedRectRadii = { xRadius = 10, yRadius = 10 },
	frame = { x = 0, y = 0, w = 200, h = 44 },
}

widget.canvas[2] = {
	id = "label",
	type = "text",
	text = widget.text,
	textFont = widget.font,
	textSize = widget.textSize,
	textColor = { white = 1, alpha = 0.92 },
	textAlignment = "center",
	textLineBreak = "truncateTail",
	frame = { x = widget.paddingX, y = widget.paddingY, w = 200 - 2 * widget.paddingX, h = 44 - 2 * widget.paddingY },
}

local function fitToText()
	local sf = usableFrame()
	local maxW = math.floor(sf.w * widget.maxWFrac)

	-- Measure the raw text (single-line unless you include '\n')
	local style = {
		font = widget.font,
		size = widget.textSize,
		alignment = "center",
		lineBreak = "clip",
	}
	local sz = hs.drawing.getTextDrawingSize(widget.text, style)
	local textW = (sz and sz.w) or 80
	local textH = (sz and sz.h) or (widget.textSize + 4)

	local desiredW = math.ceil(textW + widget.extraW + 2 * widget.paddingX)
	local desiredH = math.ceil(textH + widget.extraH + 2 * widget.paddingY)

	local w = clamp(desiredW, widget.minW, maxW)
	local h = desiredH

	-- If we had to clamp width, truncate rather than wrap
	widget.canvas["label"].textLineBreak = (desiredW > maxW) and "truncateTail" or "clip"

	-- Resize elements
	widget.canvas["bg"].frame = { x = 0, y = 0, w = w, h = h }
	widget.canvas["label"].frame = {
		x = widget.paddingX,
		y = widget.paddingY,
		w = w - 2 * widget.paddingX,
		h = h - 2 * widget.paddingY,
	}

	-- Resize + re-pin bottom-right
	widget.canvas:frame(computeBottomRightFrame(w, h))
end

-- Reposition/resize on layout changes
widget.screenWatcher = hs.screen.watcher.new(fitToText):start()
widget.spaceTimer = hs.timer.doEvery(2, fitToText) -- optional polling; remove if you dislike it

-- IPC-callable API
function setWidgetText(s)
	widget.text = tostring(s or "")
	widget.canvas["label"].text = widget.text
	fitToText()
end

-- Optional: quick hide/show from IPC too
function showWidget()
	widget.canvas:show()
end
function hideWidget()
	widget.canvas:hide()
end
local function toggleWidget()
	if widget.canvas:isShowing() then
		hideWidget()
	else
		showWidget()
	end
end

function setWidgetAndShow(s)
	showWidget()
	setWidgetText(s)
end

hs.hotkey.bind({ "cmd", "alt" }, "W", function()
	toggleWidget()
end)

return {
	setWidgetText = setWidgetText,
	setWidgetAndShow = setWidgetAndShow,
	showWidget = showWidget,
	hideWidget = hideWidget,
}
