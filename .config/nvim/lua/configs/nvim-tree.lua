local M = {}

M.opts = {
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
}

local api = require "nvim-tree.api"

M.functions = {
  mark = function()
    local view = require "nvim-tree.view"
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

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
        api.marks.toggle(node)
      end
    end

    vim.api.nvim_win_set_cursor(winid, cursor_pos)
  end,

  clear_marks = function()
    api.marks.clear()
  end,

  get_marked = function()
    local marked = {}
    for _, node in ipairs(api.marks.list()) do
      table.insert(marked, node)
    end
    return marked
  end,

  restore_marks = function(nodes)
    for _, node in ipairs(nodes) do
      api.marks.toggle(node)
    end
  end,

  delete_marks = function()
    api.marks.bulk.delete()
  end,
}

M.keys = {
  {
    "m",
    function()
      M.functions.mark()
    end,
    mode = "x",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "d",
    function()
      local prev_marks = M.functions.get_marked()
      M.functions.clear_marks()
      M.functions.mark()
      M.functions.delete_marks()
      M.functions.clear_marks()
      M.functions.restore_marks(prev_marks)
    end,
    mode = "x",
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
  {
    "bc",
    function()
      M.functions.clear_marks()
    end,
    mode = { "n", "x" },
    ft = "NvimTree",
    noremap = true,
    nowait = true,
  },
}

return M
