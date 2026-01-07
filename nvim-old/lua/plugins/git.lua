return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = require("gitsigns")

			local function gmap(lhs, rhs, desc, mode)
				map(lhs, rhs, desc, mode, { buffer = buffer })
			end

			-- Navigation
			gmap("]g", gs.next_hunk, "hunk")
			gmap("[g", gs.prev_hunk, "hunk")

			-- Actions
			gmap(leaders.git .. "s", gs.stage_hunk, "stage hunk")
			gmap(leaders.git .. "r", gs.reset_hunk, "resert hunk")
			gmap(leaders.git .. "S", gs.stage_buffer, "stage buffer")
			gmap(leaders.git .. "R", gs.reset_buffer, "reset buffer")
			gmap(leaders.git .. "u", gs.undo_stage_hunk, "unstage hunk")
			gmap(leaders.git .. "p", gs.preview_hunk, "preview hunk")
			gmap(leaders.git .. "b", function()
				gs.blame_line({ full = true })
			end, "view blame")
			gmap(leaders.git .. "d", gs.diffthis, "view diff")
			gmap(leaders.git .. "C", require("telescope.builtin").git_commits, "pick repo commits")
			gmap(leaders.git .. "c", require("telescope.builtin").git_bcommits, "pick buffer commits")
		end,
	},
}
