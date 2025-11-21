-- TODO: The very first thing you should do is to run the command `:checkhealth` in Neovim.
--
--     If you don't know what this means, type the following:
--       - <escape key>
--       - :
--       - checkhealth
--       - <enter key>
--
--     Read neovim guileline, run the command `:Tudor
--
--     MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
--       which is very useful when you're not sure exactly what you're looking for.

-- Load options file
require("options")
-- Load plugin manager "lazy"
require("lazy_manager")
-- Load keymap
require("keymaps")
-- Load lsp
require("lsp")
