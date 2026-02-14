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
  { "<leader>agc", "<cmd>ClaudeCode /commit<cr>", mode = "n", desc = "AI generate commit message" },
  {
    "<leader>agd",
    function()
      if vim.bo.filetype ~= "claude_code" then
        vim.cmd "ClaudeCodeFocus"
      else
        vim.cmd "startinsert"
      end
      local timer = vim.uv.new_timer()
      if timer then
        timer:start(
          50,
          50,
          vim.schedule_wrap(function()
            if require("claudecode").is_claude_connected() then
              timer:stop()
              timer:close()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/document ", true, false, true), "n", true)
              vim.cmd "ClaudeCode"
              vim.cmd "ClaudeCodeAdd %"
            end
          end)
        )
      end
    end,
    mode = "n",
    desc = "AI generate documentation for file",
  },
  {
    "<leader>agd",
    function()
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
      if vim.bo.filetype ~= "claude_code" then
        vim.cmd "ClaudeCodeFocus"
      else
        vim.cmd "startinsert"
      end
      local timer = vim.uv.new_timer()
      if timer then
        timer:start(
          50,
          50,
          vim.schedule_wrap(function()
            if require("claudecode").is_claude_connected() then
              timer:stop()
              timer:close()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("/document ", true, false, true), "n", true)
              vim.cmd "ClaudeCode"
              vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
              vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
              vim.cmd "normal! gv"
              vim.cmd "ClaudeCodeSend"
            end
          end)
        )
      end
    end,
    mode = "v",
    desc = "AI generate documentation for selection",
  },
  {
    "<leader>agr",
    function()
      local pr_number = vim.fn.system "gh pr view --json number --jq .number 2>/dev/null"
      if pr_number ~= "" then
        pr_number = pr_number:gsub("%s+", "")
        vim.cmd('ClaudeCode "/review #"' .. pr_number)
      end
    end,
    mode = "n",
    desc = "AI generate PR review",
  },
}

return M
