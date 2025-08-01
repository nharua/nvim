-- keymaps.lua
-- This file contains all the keymaps for Neovim.
-- [[ Basic Keymaps ]]
-- See `:help map()`

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==== Basic Operations ====
map({ "n", "v" }, "<leader>W", "<cmd>w<CR>", { desc = "Write file" })
map({ "n", "v" }, "<leader>x", "<cmd>q<CR>", { desc = "Quit window" })

-- ==== Home/End line ====
-- Normal mode
vim.keymap.set("n", "<M-l>", "$", opts) -- Move to end of line
vim.keymap.set("n", "<M-h>", "^", opts) -- Move to start of line
-- Visual mode
vim.keymap.set("v", "<M-l>", "$", opts) -- Select to end of line
vim.keymap.set("v", "<M-h>", "^", opts) -- Select to start of line
-- Insert mode
vim.keymap.set("i", "<M-l>", "<C-o>$", opts) -- Move to end of line
vim.keymap.set("i", "<M-h>", "<C-o>^", opts) -- Move to start of line

-- ==== Window Navigation ====
map("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move to window ↑" })
map("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move to window ↓" })
map("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move to window ←" })
map("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move to window →" })

-- ==== Move Lines ====
map("n", "<S-Up>", ":m-2<CR>", { desc = "Move line ↑ (normal)" })
map("n", "<S-Down>", ":m+<CR>", { desc = "Move line ↓ (normal)" })
map("i", "<S-Up>", "<Esc>:m-2<CR>", { desc = "Move line ↑ (insert)" })
map("i", "<S-Down>", "<Esc>:m+<CR>", { desc = "Move line ↓ (insert)" })

-- ==== Indent (Tab / Shift-Tab) ====
map("n", "<Tab>", ">>", opts)
map("n", "<S-Tab>", "<<", opts)
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("i", "<Tab>", "<C-t>", opts)
map("i", "<S-Tab>", "<C-d>", opts)

-- ==== Files / Tree ====
map("n", "<leader>o", "<cmd>Neotree toggle<CR>", { desc = "📁 Toggle file explorer" })

-- ==== Diagnostics ====
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "🔍 Show diagnostic float" })
map("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "📋 Diagnostic to LocList" })

-- Toggle virtual text
local function toggle_virtual_text()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	print("Virtual text diagnostics " .. (current and "disabled" or "enabled"))
end

vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", toggle_virtual_text, {
	desc = "Toggle inline (virtual text) diagnostics",
})

-- Toggle diagnostics globally
local diagnostics_enabled = true
local function toggle_diagnostics()
	diagnostics_enabled = not diagnostics_enabled
	vim.diagnostic.enable(diagnostics_enabled)
	print("Diagnostics " .. (diagnostics_enabled and "enabled" or "disabled"))
end

vim.api.nvim_create_user_command("DiagnosticsToggle", toggle_diagnostics, {
	desc = "Toggle all diagnostics globally",
})

-- ==== TODO ====
map("n", "<leader>tt", "<cmd>TodoTelescope<CR>", { desc = "📝 Search for TODOs" })
map("n", "<leader>td", "<cmd>Td<CR>", { desc = "📋 Open personal Todo list" })

-- ==== Spectre (Search & Replace) ====
map("n", "<leader>Ss", function()
	require("spectre").toggle()
end, { desc = "🔍 Toggle Spectre panel" })

map("n", "<leader>Sf", function()
	require("spectre").open_file_search({ select_word = true })
end, { desc = "📄 Spectre search in file" })

-- ==== Git ====
map("n", "<leader>g", "<cmd>LazyGit<CR>", { desc = "🌱 Open LazyGit" })

-- ==== Search Highlight ====
vim.opt.hlsearch = true
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "🔍 Clear search highlight" })

-- ==== Telescope ====
local builtin = require("telescope.builtin")
map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
-- Slightly advanced example of overriding default behavior and theme
map("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })
-- Also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
map("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })
-- Shortcut for searching your neovim configuration files
map("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- ==== Copilot ====
-- map("n", "<leader>ac", "<cmd>CopilotChat<CR>", { desc = "Toggle Copilot Chat" })

-- ==== WhichKey ====
-- Register the keymaps with WhichKey
local wk = require("which-key")
wk.add({
	{
		"<leader>s",
		group = "Telescope Search",
	}, -- group
	{
		"<leader>S",
		group = "Spectre Search",
	}, -- group
	{
		"<leader>a",
		group = "  Copilot ",
	}, -- group
	{
		"<leader>t",
		group = "  TODO",
	},
	{
		"<leader>w",
		group = "Workspace Management",
	}, -- group
	{
		"<leader>b",
		group = "buffers",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	-- {
	-- 	-- Nested mappings are allowed and can be added in any order
	-- 	-- Most attributes can be inherited or overridden on any level
	-- 	-- There's no limit to the depth of nesting
	-- 	mode = { "n", "v" }, -- NORMAL and VISUAL mode
	-- 	{ "<leader>x", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
	-- 	{ "<leader>w", "<cmd>w<cr>", desc = "Write" },
	-- },
})
