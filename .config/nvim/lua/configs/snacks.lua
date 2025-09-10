local opts = {
  bigfile = {
    enabled = true,
    notify = true,
  },
  input = {
    enabled = false,
    expand = false,
  },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<Tab>"] = { { "list_down" }, mode = { "n", "i" } },
          ["<S-Tab>"] = { { "list_up" }, mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["<Tab>"] = { { "list_down" }, mode = { "n", "x" } },
          ["<S-Tab>"] = { { "list_up" }, mode = { "n", "x" } },
        },
      },
    },
  },
  quickfile = {
    enabled = true,
  },
}

return opts
