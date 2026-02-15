local opts = {
  bigfile = {
    enabled = true,
    notify = false,
  },
  input = {
    enabled = false,
    -- saving the opts if ever want to enable it back
    prompt_pos = "left",
    icon_pos = "left",
    expand = false,
    win = {
      keys = {
        ["<C-h>"] = { "close", mode = { "i", "n" } },
        ["<C-j>"] = { "close", mode = { "i", "n" } },
        ["<C-k>"] = { "close", mode = { "i", "n" } },
        ["<C-l>"] = { "close", mode = { "i", "n" } },
      },
    },
  },
  styles = {
    input = {
      border = "none",
      row = -1,
      width = 0,
      wo = {
        winhighlight = "NormalFloat:StatusLine",
      },
      keys = {
        i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
        n_esc = { "<esc>", { "close" }, mode = "n", expr = true },
      },
    },
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
