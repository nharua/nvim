return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = { theme = "gruvbox" },
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: just the filename, 1: relative path, 2: absolute path
						symbols = {
							modified = " [+]",
							readonly = " [-]",
							unnamed = "[No Name]",
						},
					},
				},
			},
			inactive_sections = {
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: just the filename, 1: relative path, 2: absolute path
						symbols = {
							modified = " [+]",
							readonly = " [-]",
							unnamed = "[No Name]",
						},
					},
				},
			},
		})
	end,
}
