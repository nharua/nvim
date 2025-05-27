-- NOTE: This plugin is not used in the current configuration.
-- Added DEBUG: keyword to highlight debug print statements.
-- Highlight todo, notes, etc in comments
return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		signs = false,
		keywords = {
			FIX = { icon = " ", color = "error" },
			TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			PERF = { icon = " ", color = "hint" },
			NOTE = { icon = " ", color = "hint" },
			TEST = { icon = " ", color = "test" },
			DEBUG = { icon = " ", color = "warning", alt = { "DEBUG", "PRINT" } },
		},
	},
}
