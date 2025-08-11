local M = {}

M.opts = {
  -- Terminal Configuration
  terminal = {
    split_side = "right", -- "left" or "right"
    split_width_percentage = 0.35,
    provider = "snacks", -- "auto", "snacks", "native", "external", or custom provider table
    auto_close = true,
    show_native_term_exit_tip = false,
    snacks_win_opts = {
      -- position = "float",
      -- width = 0.8,
      -- height = 0.8,
      -- border = "rounded",
    },
  },
}

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Claude Toggle sidebar" },
  {
    "<leader>agc",
    function()
      vim.fn.system "git add ."
      vim.cmd "ClaudeCode -p --allowedTools 'Bash,Read' '/commit-message'"
    end,
    mode = "n",
    desc = "Claude Generate commit message",
  },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Add current selection" },
  {
    "<leader>aa",
    function()
      local ft = vim.bo.filetype
      if ft == "NvimTree" or ft == "neo-tree" or ft == "oil" or ft == "minifiles" then
        vim.cmd "ClaudeCodeTreeAdd"
      else
        vim.cmd "ClaudeCodeAdd %"
      end
    end,
    desc = "Claude Add file",
    mode = "n",
  },
  { "<leader>ac", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude Confirm edit" },
  { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude Deny edit" },
}

return M
