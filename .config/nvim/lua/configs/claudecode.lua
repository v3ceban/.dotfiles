local M = {}

M.opts = {
  log_level = "error",
  terminal = {
    split_side = "right",
    split_width_percentage = 0.39,
    snacks_win_opts = {
      bo = {
        filetype = "claudecode_terminal",
      },
      wo = {
        winbar = "",
      },
    },
  },
  diff_opts = {
    open_in_current_tab = false,
    hide_terminal_in_new_tab = true,
  },
}

M.keys = {
  -- General
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI toggle claude" },
  { "<leader>ac", "<cmd>ClaudeCodeOpen<cr>", mode = { "n", "t" }, desc = "AI open claude" },
  { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", mode = "n", desc = "AI select claude model" },
  { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "AI add file to claude" },
  { "<M-f>", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "AI add file to claude" },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI add selection to claude" },
  { "<M-f>", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI add selection to claude" },
  {
    "<leader>aa",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    mode = "n",
    desc = "AI add file to claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  },
  {
    "<M-f>",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    mode = "n",
    desc = "AI add file to claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  },
  -- Diff management
  { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", mode = "n", desc = "AI accept claude change" },
  { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", mode = "n", desc = "AI deny claude change" },
  -- Window management
  {
    "<C-h>",
    function()
      vim.cmd "wincmd h"
    end,
    mode = { "n", "t" },
    ft = { "claudecode_terminal" },
  },
  {
    "<C-l>",
    function()
      vim.cmd "wincmd l"
    end,
    mode = { "n", "t" },
    ft = { "claudecode_terminal" },
  },
  {
    "<C-n>",
    -- Toggles Claude Code terminal and NvimTree file explorer.
    -- This provides quick access to the file explorer while keeping the
    -- terminal accessible and avoiding layout issues.
    function()
      vim.cmd "ClaudeCode"
      vim.cmd "NvimTreeToggle"
      vim.cmd "ClaudeCode"
    end,
    mode = { "n", "t" },
    ft = { "claudecode_terminal" },
  },
}

return M
