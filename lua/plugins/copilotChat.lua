return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = function()
			local hostname = vim.fn.system("hostname"):gsub("%s+", "")
			local user = hostname or vim.env.USER or "User"
			-- Define custom prompts here (merged in opts below)
			local copilot_prompts = {
				Explain = "Please explain how the following code works.",
				Review = "Please review the following code and provide suggestions for improvement.",
				FixCode = "Please fix the following code to make it work as intended.",
				FixError = "Please explain the error in the following text and provide a solution.",
				BetterNamings = "Please provide better names for the following variables and functions.",
				Documentation = "Please provide documentation for the following code.",
				GenerateReadme = [[
					Generate a clean, professional, and concise README.md for this project. 
					Only include the following sections, in this order:

						1. Project Title and Short Description
						2. Features
						3. Prerequisites
						4. Installation
						5. Usage
						6. Contributing
						7. License

					Do **not** include any of the following sections:
					- Code Overview
					- Error Handling
					- Example Output
					- Boilerplate intros or outros like “Here is a basic README…” or “Let me know if…”

					Format using proper GitHub Markdown. Do not wrap the content in code blocks.
					]],
			}

			return {
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				error_header = "## Error ",
				prompts = copilot_prompts,
				model = "gpt-4.1",
				mappings = {
					complete = { detail = "Use @<Tab> or /<Tab> for options.", insert = "<Tab>" },
					close = { normal = "q", insert = "<C-c>" },
					reset = { normal = "<C-x>", insert = "<C-x>" },
					submit_prompt = { normal = "<CR>", insert = "<C-CR>" },
					accept_diff = { normal = "<C-y>", insert = "<C-y>" },
					show_help = { normal = "g?" },
				},
			}
		end,
		config = function(_, opts)
			require("CopilotChat").setup(opts)
		end,
		keys = function()
			local select = require("CopilotChat.select")
			local chat = require("CopilotChat")

			return {
				-- Visual mode actions
				{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = "x", desc = "Explain selection" },
				{ "<leader>ar", "<cmd>CopilotChatReview<cr>", mode = "x", desc = "Review selection" },
				{ "<leader>af", "<cmd>CopilotChatFixCode<cr>", mode = "x", desc = "Fix selection" },
				{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", mode = "x", desc = "Rename selection" },
				{ "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = "x", desc = "Document selection" },

				-- Current line actions
				{
					"<leader>lf",
					function()
						chat.ask("FixCode", { selection = select.line })
					end,
					desc = "Fix current line",
				},
				{
					"<leader>ln",
					function()
						chat.ask("BetterNamings", { selection = select.line })
					end,
					desc = "Rename in current line",
				},
				{
					"<leader>ld",
					function()
						chat.ask("Documentation", { selection = select.line })
					end,
					desc = "Document current line",
				},
				{
					"<leader>lx",
					function()
						chat.ask("FixError", { selection = select.line })
					end,
					desc = "Fix error in current line",
				},

				-- Current buffer actions
				{
					"<leader>be",
					function()
						chat.ask("Explain", { selection = select.buffer })
					end,
					desc = "Explain buffer",
				},
				{
					"<leader>br",
					function()
						chat.ask("Review", { selection = select.buffer })
					end,
					desc = "Review buffer",
				},
				{
					"<leader>bf",
					function()
						chat.ask("FixCode", { selection = select.buffer })
					end,
					desc = "Fix code in buffer",
				},
				{
					"<leader>bn",
					function()
						chat.ask("BetterNamings", { selection = select.buffer })
					end,
					desc = "Rename in buffer",
				},
				{
					"<leader>bd",
					function()
						chat.ask("Documentation", { selection = select.buffer })
					end,
					desc = "Document buffer",
				},
				{
					"<leader>bx",
					function()
						chat.ask("FixError", { selection = select.buffer })
					end,
					desc = "Fix error in buffer",
				},

				-- Manual input
				{
					"<leader>ai",
					function()
						local input = vim.fn.input("Ask Copilot: ")
						if input and input:match("%S") then
							vim.cmd("CopilotChat " .. input)
						end
					end,
					desc = "Ask Copilot with input",
				},
				{
					"<leader>aq",
					function()
						local input = vim.fn.input("Quick Chat: ")
						if input and input:match("%S") then
							chat.ask(input, { selection = select.buffer })
						end
					end,
					desc = "Quick chat (buffer)",
				},

				-- README generations
				{
					"<leader>bR",
					function()
						chat.ask("GenerateReadme", {
							selection = require("CopilotChat.select").buffer,
							callback = function(response)
								-- 🧹 Clean up common boilerplate Copilot text
								local cleaned = response
									:gsub("(?i)^Here is a basic README.-\n+", "") -- Remove intro
									:gsub("(?i)\n*Let me know if you'd like to customize this further!%s*", "") -- Remove outro
									:gsub("```markdown", "") -- If Copilot wraps it in code block
									:gsub("```", "") -- Remove ending code block
								-- Write response to README.md
								local path = vim.fn.getcwd() .. "/README.md"
								local file = io.open(path, "w")
								if file then
									file:write(cleaned)
									file:close()
									vim.notify("README.md generated at " .. path, vim.log.levels.INFO)
								else
									vim.notify("Failed to write README.md", vim.log.levels.ERROR)
								end
							end,
						})
					end,
					desc = "CopilotChat - Generate README.md and write to file",
				},

				-- Utilities
				{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
				{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select model" },
				{ "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "Select agent" },
				{
					"<leader>ap",
					function()
						chat.select_prompt({ context = { "buffers" } })
					end,
					desc = "Prompt list",
				},
				{ "<leader>ac", "<cmd>CopilotChat<cr>", desc = "Toggle Copilot Chat" },
			}
		end,
	},

	-- Optional: Treesitter support
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "diff", "markdown" },
		},
	},

	-- Optional: Render Markdown in chat buffers
	{
		"MeanderingProgrammer/render-markdown.nvim",
		optional = true,
		ft = { "markdown", "copilot-chat" },
		opts = {
			file_types = { "markdown", "copilot-chat" },
		},
	},
}
