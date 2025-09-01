local config = {
  default_mappings = {
    ours = "<leader>co",
    theirs = "<leader>ct",
    none = "<leader>cn",
    both = "<leader>cb",
    next = "]c",
    prev = "[c",
  },
  default_commands = true,
  disable_diagnostics = true,
  list_opener = "copen",
  highlights = {
    incoming = "DiffAddGroup",
    current = "DiffTextGroup",
  },
}

return config
