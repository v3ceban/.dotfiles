local M = {}

M.opts = {
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
}

local api = require "nvim-tree.api"
local remove_file = require "nvim-tree.actions.fs.remove-file"

local function for_each_visual_node(fn)
  local view = require "nvim-tree.view"
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "v", false)

  local winid = view.get_winnr()
  local bufnr = vim.api.nvim_win_get_buf(winid)

  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  local last_line = vim.api.nvim_buf_line_count(bufnr)
  start_line = math.max(1, math.min(start_line, last_line))
  end_line = math.max(1, math.min(end_line, last_line))

  for i = start_line, end_line do
    vim.api.nvim_win_set_cursor(winid, { i, 0 })
    local node = api.tree.get_node_under_cursor()
    if node and node.absolute_path then
      fn(node)
    end
  end

  vim.api.nvim_win_set_cursor(winid, cursor_pos)
end

M.keys = {
  {
    "m",
    function()
      for_each_visual_node(function(node)
        api.marks.toggle(node)
      end)
    end,
    mode = "v",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "d",
    function()
      local nodes = {}
      for_each_visual_node(function(node)
        table.insert(nodes, node)
      end)

      if #nodes == 0 then
        return
      end

      vim.ui.input({ prompt = "Delete " .. #nodes .. " file(s)? (y/N): " }, function(input)
        if input and input:lower() == "y" then
          for i = #nodes, 1, -1 do
            remove_file.remove(nodes[i])
          end
          api.tree.reload()
        end
      end)
    end,
    mode = "v",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "c",
    function()
      for_each_visual_node(function()
        api.fs.copy.node()
      end)
    end,
    mode = "v",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "x",
    function()
      for_each_visual_node(function()
        api.fs.cut()
      end)
    end,
    mode = "v",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "bc",
    function()
      api.marks.clear()
    end,
    mode = { "n", "v" },
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
}

return M
