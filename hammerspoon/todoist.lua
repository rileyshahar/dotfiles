local cfg = {
	token = "PASTE_YOUR_TODOIST_API_TOKEN_HERE",
	filterQuery = "today & !subtask", -- <-- use the filter query you want
	hotkeyMods = { "ctrl", "alt", "cmd" },
	hotkeyKey = "T",
	refreshSec = 60,
}

local panel = nil
local refresher = nil

local function desiredFrame()
	local f = hs.screen.mainScreen():frame()
	local w, h = 460, 700
	return hs.geometry.rect(f.x + f.w - w - 16, f.y + 60, w, h)
end

local function htmlEscape(s)
	s = s or ""
	return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function render(tasks)
	local rows = {}
	for _, t in ipairs(tasks or {}) do
		local due = ""
		if t.due then
			due = t.due.date or t.due.datetime or ""
		end

		-- Click opens the task in Todoist app via URL scheme
		table.insert(
			rows,
			string.format(
				[[
      <a class="task" href="todoist://task?id=%s">
        <div class="content">%s</div>
        <div class="meta">%s</div>
      </a>
    ]],
				htmlEscape(t.id),
				htmlEscape(t.content),
				htmlEscape(due)
			)
		)
	end

	return string.format(
		[[
<!doctype html>
<html>
<head>
<meta charset="utf-8" />
<style>
  body { margin:0; font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial;
         background: rgba(18,18,22,0.55); color: #fff; }
  .wrap { padding: 14px; }
  .header { display:flex; justify-content:space-between; align-items:baseline; margin-bottom: 10px; }
  .title { font-size: 13px; font-weight: 700; letter-spacing: 0.2px; opacity: 0.95; }
  .count { font-size: 11px; opacity: 0.7; }
  .task { display:block; text-decoration:none; color:inherit;
          padding: 10px 10px; margin: 8px 0; border-radius: 14px;
          background: rgba(255,255,255,0.10); border: 1px solid rgba(255,255,255,0.12); }
  .task:hover { background: rgba(255,255,255,0.14); }
  .content { font-size: 13px; font-weight: 600; margin-bottom: 6px; }
  .meta { font-size: 11px; opacity: 0.75; }
</style>
</head>
<body>
  <div class="wrap">
    <div class="header">
      <div class="title">Todoist • Filter Panel</div>
      <div class="count">%d</div>
    </div>
    %s
  </div>
</body>
</html>
  ]],
		#tasks,
		table.concat(rows, "\n")
	)
end

local function fetchAndRender()
	if not panel then
		return
	end

	local q = hs.http.encodeForQuery(cfg.filterQuery) -- :contentReference[oaicite:8]{index=8}
	local url = "https://api.todoist.com/api/v1/tasks/filter?query=" .. q -- :contentReference[oaicite:9]{index=9}
	local headers = { ["Authorization"] = "Bearer " .. cfg.token }

	hs.http.doAsyncRequest(url, "GET", nil, headers, function(code, body, _)
		if code ~= 200 then
			panel:html(
				render({ { id = "", content = "Error fetching tasks (" .. tostring(code) .. ")", due = { date = "" } } })
			)
			return
		end
		local decoded = hs.json.decode(body)
		local tasks = (decoded and decoded.results) or {}
		panel:html(render(tasks))
	end)
end

local function ensurePanel()
	if panel then
		return
	end

	panel = hs
		.webview
		.new(desiredFrame())
		:windowStyle({ "titled", "closable", "utility" }) -- :contentReference[oaicite:10]{index=10}
		:transparent(true) -- :contentReference[oaicite:11]{index=11}
		:allowTextEntry(false) -- :contentReference[oaicite:12]{index=12}
		:allowGestures(false) -- :contentReference[oaicite:13]{index=13}
		:level(hs.drawing.windowLevels.floating) -- :contentReference[oaicite:14]{index=14}
		:behaviorAsLabels({ "canJoinAllSpaces", "fullScreenAuxiliary" }) -- :contentReference[oaicite:15]{index=15}
		:windowTitle("Todoist Filter Panel")

	fetchAndRender()

	refresher = hs.timer.doEvery(cfg.refreshSec, function()
		if panel and panel:isVisible() then
			fetchAndRender()
		end
	end)
end

hs.hotkey.bind(cfg.hotkeyMods, cfg.hotkeyKey, function()
	ensurePanel()
	if panel:isVisible() then
		panel:hide(0.10) -- :contentReference[oaicite:16]{index=16}
	else
		panel:frame(desiredFrame())
		panel:show(0.08)
		fetchAndRender()
	end
end)
