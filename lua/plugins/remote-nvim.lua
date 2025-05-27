return {
	"amitds1997/remote-nvim.nvim",
	version = "v0.3.11",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- Enable debug logging
		vim.g.remote_nvim_debug = true

		require("remote-nvim").setup({
			-- Your existing configuration
			log_level = "debug", -- Add logging
		})

		-- Add error handling
		local status, err = pcall(function()
			require("telescope").load_extension("remote-nvim")
		end)

		if not status then
			print("Error loading remote-nvim Telescope extension: " .. err)
		end
	end,
}
