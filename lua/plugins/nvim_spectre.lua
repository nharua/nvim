return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	},
	config = function()
		require("spectre").setup({
			result_padding = "",
			default = {
				replace = {
					cmd = "sed",
				},
			},
		})
	end,
}
