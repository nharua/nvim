return {
	"folke/which-key.nvim",
	event = "VeryLazy",

	-- Plugin setup configuration
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},

	-- Code that runs after plugin is loaded
	config = function()
		local wk = require("which-key")
		wk.add({
			{
				-- Nested mappings are allowed and can be added in any order
				-- Most attributes can be inherited or overridden on any level
				-- There's no limit to the depth of nesting
				mode = { "n", "v" }, -- NORMAL and VISUAL mode
				{ "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
				{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
				{ "<leader>a", group = "Copilot Chat", mode = { "n", "v" } }, -- Group for Copilot Chat
				{ "<leader>l", group = "Copilot - Line" }, -- Group for Copilot Line
				{ "<leader>b", group = "Copilot - Buffer" }, -- Group for Copilot Buffer
				{ "<leader>s", group = "Telescope Search" }, -- Group for Telescope Search
				{ "<leader>g", group = "Git" }, -- Group for Git commands
				{ "<leader>c", group = "Code Actions" }, -- Group for Code Actions
			},
		})
	end,
}
