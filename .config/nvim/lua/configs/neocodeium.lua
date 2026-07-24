local opts = {
  show_label = false,
  silent = true,
  filter = function(bufnr)
    return not vim.api.nvim_buf_get_name(bufnr):find(".env", 1, true)
  end,
}

return opts
