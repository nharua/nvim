-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Move line up/down
vim.keymap.set("n", "<S-Up>", ":m-2<CR>", { desc = "Move line up one row in normal mode" })
vim.keymap.set("n", "<S-Down>", ":m+<CR>", { desc = "Move line down one row in normal mode" })
vim.keymap.set("i", "<S-Up>", "<Esc>:m-2<CR>", { desc = "Move line up one row in insert mode" })
vim.keymap.set("i", "<S-Down>", "<Esc>:m+<CR>", { desc = "Move line down one row in insert mode" })

-- Neotree
vim.keymap.set("n", "<leader>o", ":Neotree toggle<CR>", { desc = "Open files" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", function()
	local current_value = vim.diagnostic.config().virtual_text
	if current_value then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({ virtual_text = true })
	end
end, {})

-- Command to toggle diagnostics
-- vim.api.nvim_create_user_command("DiagnosticsToggle", function()
-- 	local current_value = vim.diagnostic.is_disabled()
-- 	if current_value then
-- 		vim.diagnostic.enable()
-- 	else
-- 		vim.diagnostic.disable()
-- 	end
-- end, {})
local diagnostics_enabled = true

vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	diagnostics_enabled = not diagnostics_enabled
	if diagnostics_enabled then
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	else
		vim.diagnostic.enable(false)
		print("Diagnostics disabled")
	end
end, {})

-- search TODO:
vim.keymap.set("n", "<leader>t", ":TodoTelescope<cr>")

-- Tab and Shift Tab a block
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", ">>", opts)
vim.keymap.set("n", "<S-Tab>", "<<", opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)

-- Spectre
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set(
	"n",
	"<leader>sW",
	'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
	{ desc = "[S]earch/[R]eplace current word" }
)
vim.keymap.set(
	"v",
	"<leader>sW",
	'<esc><cmd>lua require("spectre").open_visual()<CR>',
	{ desc = "[S]earch/[R]eplace current word" }
)
vim.keymap.set(
	"n",
	"<leader>sF",
	'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
	{ desc = "[S]earch/[R]eplace on current file" }
)
