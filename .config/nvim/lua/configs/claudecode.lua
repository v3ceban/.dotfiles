local M = {}

M.opts = {
  terminal = {
    provider = "snacks", -- "auto", "snacks", "native", "external", "none"
    split_width_percentage = 0.35,
    snacks_win_opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/win.md
      position = "right",
      height = 0.35,
      width = 0.35,
      wo = { winbar = "" },
      bo = { filetype = "claude_code" },
    },
  },
  diff_opts = {
    open_in_new_tab = true,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = "close_window",
  },
}

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI toggle claude terminal" },
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
  { "<C-h>", "<cmd>wincmd h<cr>", mode = "t", ft = "claude_code" },
  {
    "<C-n>",
    function()
      vim.cmd "ClaudeCode"
      vim.cmd "NvimTreeToggle"
      vim.cmd "ClaudeCode"
    end,
    mode = "t",
    ft = "claude_code",
  },
}

return M
