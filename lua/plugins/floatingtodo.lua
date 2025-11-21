-- A  Simple floating todo for neovim
return {
	"nharua/floatingtodo.nvim",
	config = function()
		require("floatingtodo").setup({
			target_file = "~/myWork/!myWork/Obsidian/Vincent_Obsidian/!Notes/todo.md", -- Path to the todo file
			border = "single", -- single, rounded, etc.
			width = 0.8, -- width of window in % of screen size
			height = 0.8, -- height of window in % of screen size
			position = "center", -- topleft, topright, bottomleft, bottomright
		})
	end,
}
