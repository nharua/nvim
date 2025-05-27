return {
	"SirVer/ultisnips",
	config = function()
		-- Enable UltiSnips
		vim.g.UltiSnipsExpandTrigger = "<c-j>"
		vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
		vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
		vim.g.UltiSnipsEditSplit = "vertical"

		-- Set the snippets directory
		vim.g.UltiSnipsSnippetsDir = "/home/$USER/.config/nvim/UltiSnips"
	end,
}
