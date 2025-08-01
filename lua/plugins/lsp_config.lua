return {
	-- Plugin: Mason for managing LSP/DAP/Formatters
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded", -- Sử dụng border tròn
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	-- Plugin: Bridge mason with lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"verible",
					"clangd",
				},
				-- Tự động cài đặt LSP servers khi cần
				automatic_installation = true,
			})
		end,
	},
	-- Plugin: Install formatters/linters via Mason
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"isort",
					"black",
					"verible",
					"clang-format",
					"cpplint",
				},
				-- Tự động cài đặt tools
				auto_update = false,
				run_on_start = true,
			})
		end,
	},
	-- Plugin: LSP status UI
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
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
				-- Thêm progress reporting
				opts.handlers = opts.handlers or {}
				opts.handlers["$/progress"] = vim.lsp.handlers["$/progress"]
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
						-- Tối ưu performance
						telemetry = { enable = false },
						hint = {
							enable = true,
							arrayIndex = "Disable",
							await = true,
							paramName = "Disable",
							paramType = true,
							semicolon = "Disable",
							setType = false,
						},
					},
				},
			})

			-- Pyright cho Python
			setup_server("pyright", {
				root_dir = root_pattern(
					".git",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyproject.toml"
				),
				settings = {
					python = {
						analysis = {
							-- Tăng tốc độ analysis
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic", -- có thể đổi thành "strict" nếu cần
						},
					},
				},
				-- Đảm bảo progress được report
				on_attach = function(client, bufnr)
					-- Enable progress reporting
					client.server_capabilities.workspaceSymbolProvider = true
				end,
			})

			-- Verible (SystemVerilog/Verilog)
			setup_server("verible", {
				cmd = {
					"verible-verilog-ls",
					"--rules_config",
					vim.fn.expand("~/.config/nvim/.rules.verible_lint"),
				},
				root_dir = root_pattern(".git", "*.sv", "*.v"),
			})

			-- Clangd for C/C++
			setup_server("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
					"--all-scopes-completion",
					"--cross-file-rename",
					"--log=verbose",
				},
				root_dir = root_pattern(
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac",
					"CMakeLists.txt",
					"Makefile",
					".git"
				),
				init_options = {
					usePlaceholders = true,
					completeUnimported = true,
					clangdFileStatus = true,
				},
				capabilities = vim.tbl_extend("keep", capabilities, {
					offsetEncoding = { "utf-16" },
				}),
				settings = {
					clangd = {
						InlayHints = {
							Designators = true,
							Enabled = true,
							ParameterNames = true,
							DeducedTypes = true,
						},
						fallbackFlags = { "-std=c17" },
					},
				},
				-- Đảm bảo progress được report
				on_attach = function(client, bufnr)
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			-- Global LSP settings
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})

			-- Diagnostics configuration
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
				float = {
					source = true,
					border = "rounded",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Keymaps (on_attach style)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end

					-- Navigation
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Documentation
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

					-- Code actions
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Diagnostics
					map("<leader>e", vim.diagnostic.open_float, "Open floating diagnostic message")
					map("<leader>q", vim.diagnostic.setloclist, "Open diagnostics list")

					-- Workspace management
					map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
					map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
					map("<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, "[W]orkspace [L]ist Folders")

					-- Language-specific keymaps
					local filetype = vim.bo[ev.buf].filetype

					-- C/C++ specific
					if filetype == "c" or filetype == "cpp" then
						map("<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", "[C]lang Switch [H]eader")
						map("<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", "[C]lang [T]ype Hierarchy")
						map("<leader>cs", "<cmd>ClangdSymbolInfo<cr>", "[C]lang [S]ymbol Info")
					end

					-- Python specific
					if filetype == "python" then
						map("<leader>po", "<cmd>PyrightOrganizeImports<cr>", "[P]ython [O]rganize Imports")
					end

					-- Print attachment confirmation
					print(
						string.format(
							"LSP attached: %s (%s)",
							vim.lsp.get_active_clients({ bufnr = ev.buf })[1].name,
							filetype
						)
					)
				end,
			})

			-- Auto-format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("AutoFormat", { clear = true }),
				pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.py", "*.lua" },
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})

			-- Progress reporting debug (tạm thời để debug)
			vim.api.nvim_create_autocmd("LspProgress", {
				callback = function(args)
					if args.data and args.data.result then
						print("LSP Progress:", vim.inspect(args.data.result))
					end
				end,
			})
		end,
	},
}
