local wk = require "which-key"
wk.add {
  {
    mode = { "n", "v", "o" },
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
}

local opts = {
  icons = {
    mappings = false,
  },
}

return opts
