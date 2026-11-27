local opts = {
  icons = {
    mappings = false,
  },
  spec = {
    {
      mode = { "n", "x", "o" },
      {
        "gs",
        desc = "Sort",
      },
      {
        "<leader>D",
        desc = "which_key_ignore",
      },
      {
        "gO",
        desc = "which_key_ignore",
      },
    },
  },
}

return opts
