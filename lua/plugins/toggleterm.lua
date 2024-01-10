return {  
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = { 
    open_mapping = [[<C-\>]], 
    direction = "float",
    size = 20,
    shade_filetypes = {}, 
    hide_numbers = true, 
    insert_mappings = true, 
    terminal_mappings = true, 
    start_in_insert = true, 
    close_on_exit = true,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
}
