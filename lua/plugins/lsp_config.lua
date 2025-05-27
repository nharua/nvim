return {
	-- Plugin: Mason for managing LSP/DAP/Formatters
	{
		"williamboman/mason.nvim",
		config = true,
	},

	-- Plugin: Bridge mason with lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "verible" },
			})
		end,
	},

	-- Plugin: Install formatters/linters via Mason
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = { "stylua", "isort", "black", "verible" },
			})
		end,
	},

	-- Plugin: LSP status UI
	{
		"j-hui/fidget.nvim",
		opts = {},
	},

	-- Plugin: Main LSP config
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local root_pattern = lspconfig.util.root_pattern

			-- Helper function to setup LSP servers
			local function setup_server(name, opts)
				opts = opts or {}
				opts.capabilities = capabilities
				lspconfig[name].setup(opts)
			end

			-- Lua LS
			setup_server("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})

			-- Pyright
			setup_server("pyright", {
				root_dir = root_pattern(".git", "setup.py", "setup.cfg", "requirements.txt", "Pipfile"),
			})

			-- Verible
			setup_server("verible", {
				cmd = {
					"verible-verilog-ls",
					"--rules_config",
					vim.fn.expand("/home/$USER/.config/nvim/.rules.verible_lint"),
				},
				root_dir = vim.loop.cwd,
			})

			-- Keymaps (on_attach style)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				end,
			})
		end,
	},
}
