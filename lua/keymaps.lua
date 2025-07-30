-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Move to window above" })
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Move to window below" })
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Move to window left" })
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Move to window right" })

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
local function toggle_virtual_text()
	local current_value = vim.diagnostic.config().virtual_text
	if current_value then
		vim.diagnostic.config({ virtual_text = false })
		print("Virtual text diagnostics disabled")
	else
		vim.diagnostic.config({ virtual_text = true })
		print("Virtual text diagnostics enabled")
	end
end

vim.api.nvim_create_user_command(
	"DiagnosticsToggleVirtualText",
	toggle_virtual_text,
	{ desc = "Toggle inline (virtual text) diagnostics" }
)

-- Command to toggle diagnostics
local diagnostics_enabled = true

local function toggle_diagnostics()
	diagnostics_enabled = not diagnostics_enabled
	if diagnostics_enabled then
		vim.diagnostic.enable()
		print("Diagnostics enabled")
	else
		vim.diagnostic.enable(false)
		print("Diagnostics disabled")
	end
end

vim.api.nvim_create_user_command("DiagnosticsToggle", toggle_diagnostics, { desc = "Toggle all diagnostics globally" })

-- search TODO:
vim.keymap.set("n", "<leader>tt", ":TodoTelescope<cr>", { desc = "Search for TODOs" })
-- :TODO: My Todo list
vim.keymap.set("n", "<leader>td", ":Td<cr>", { desc = "Open Todo list" })

-- Tab and Shift Tab a block
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", ">>", opts)
vim.keymap.set("n", "<S-Tab>", "<<", opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)

-- Spectre - Search and Replace
vim.keymap.set("n", "<leader>Ss", function()
	require("spectre").toggle()
end, { desc = "Toggle Spectre panel" })

vim.keymap.set("n", "<leader>Sf", function()
	require("spectre").open_file_search({ select_word = true })
end, { desc = "Search/replace in current file" })

-- LazyGit
vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
