local opts = {
  render_modes = { "n", "v", "V", "i", "c" },
  heading = {
    position = "inline",
    backgrounds = { "RenderMarkdownHeader" },
    foregrounds = { "RenderMarkdownHeader" },
  },
  code = {
    left_pad = 1,
    right_pad = 1,
  },
  bullet = {
    icons = { "●", "○", "●", "○" },
  },
  checkbox = {
    unchecked = { highlight = "RenderMarkdownTodo" },
    checked = { highlight = "RenderMarkdownTodo" },
  },
}

return opts
