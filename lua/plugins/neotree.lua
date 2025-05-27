-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				hijack_netrw_behavior = "open_current",
				filtered_items = {
					visible = true, -- This shows hidden files
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				-- Ensure the keymapping for toggling hidden files
				window = {
					mappings = {
						["H"] = "toggle_hidden",
					},
				},
			},
		})
	end,
}
