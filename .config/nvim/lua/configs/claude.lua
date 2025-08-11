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
  {
    "<leader>agc",
    function()
      vim.cmd "!git add ."
      local handle = io.popen "claude-code -p --allowedTools 'Bash,Read' /commit-message"
      if handle then
        local commit_message = handle:read "*a"
        handle:close()
        if commit_message then
          local commit_choice = vim.fn.confirm("Create a commit with this message?\n" .. commit_message, "&Yes\n&No", 2)
          if commit_choice == 1 then
            vim.fn.system { "git", "commit", "-m", commit_message }
            local push_choice = vim.fn.confirm("Push this commit to remote?", "&Yes\n&No", 2)
            if push_choice == 1 then
              vim.fn.system { "git", "push" }
            end
            vim.defer_fn(function()
              vim.cmd "close"
            end, 20)
          end
        end
      else
        print "Failed to generate commit message"
      end
    end,
    desc = "Generate commit message",
    mode = "n",
  },
}

return M
