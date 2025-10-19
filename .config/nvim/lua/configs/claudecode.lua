local M = {}

M.opts = {
  terminal = {
    provider = "none",
  },
  diff_opts = {
    open_in_current_tab = false,
    hide_terminal_in_new_tab = true,
  },
}

M.keys = {
  { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "AI send file to claude" },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI send selection to claude" },
  {
    "<leader>aa",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    mode = "n",
    desc = "AI send file to claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  },
  { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", mode = "n", desc = "AI accept claude change" },
  { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", mode = "n", desc = "AI deny claude change" },
}

return M
