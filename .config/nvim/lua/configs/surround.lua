local M = {}

M.init = function()
  vim.g.nvim_surround_no_visual_mappings = true
end

M.setup = function()
  require("nvim-surround").setup {
    aliases = {
      ["b"] = { "}", "]", ")" }, -- brackets
      ["B"] = { "}", "]", ")", ">" }, -- all brackets
      ["q"] = { '"', "'", "`" }, -- quotes
      ["s"] = { "}", "]", ")", ">", '"', "'", "`" }, -- surroundings
      ["r"] = {}, -- disabled default keymap
      ["a"] = {}, -- disabled default keymap
    },
  }

  vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", {
    desc = "Add a surrounding pair around a visual selection",
  })
  vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual-line)", {
    desc = "Add a surrounding pair around a visual selection, on new lines",
  })
end

M.keys = {
  { "cs", mode = { "n" } },
  { "ds", mode = { "n" } },
  { "ys", mode = { "n" } },
  { "s", mode = { "v", "x" } },
  { "S", mode = { "v", "x" } },
}

return M
