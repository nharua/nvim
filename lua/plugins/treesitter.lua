return {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			-- ensure_installed = { "maintained"},  --Using this option when you have internet access
			ensure_installed = { "bash", "dockerfile", "html", "css", "lua", "python", "verilog", "json", "vim", "yaml"},
			-- auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
