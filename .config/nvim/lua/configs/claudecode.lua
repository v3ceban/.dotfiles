local M = {}

--- Terminal window position for Claude Code interface
--- Can technically be top and left as well, but those are ugly
--- @type "float" | "right" | "bottom"
local position = "right"

M.opts = {
  terminal = {
    provider = "snacks", -- "auto", "snacks", "native", "external", "none"
    split_width_percentage = 0.375,
    snacks_win_opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/win.md
      position = position,
      height = position == "float" and 0.8 or 0.45,
      width = position == "float" and 0.85 or 0.375,
      border = "rounded",
      backdrop = false,
      wo = { winbar = "" },
      bo = { filetype = "claude_code" },
    },
  },
  diff_opts = {
    open_in_new_tab = true,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = "close_window",
  },
  models = {
    { name = "Claude Opus", value = "opus" },
    { name = "Claude Sonnet", value = "sonnet" },
    { name = "Opusplan: Claude Opus + Sonnet", value = "opusplan" },
    { name = "Claude Haiku", value = "haiku" },
  },
}

--- Focus the Claude terminal and send a slash command once connected.
--- @param text string The text to feed (e.g. "/commit ")
--- @param callback? function Optional callback to run callback feeding text
local function focus_and_send(text, callback)
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
        if not require("claudecode").is_claude_connected() then
          return
        end
        timer:stop()
        timer:close()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
        vim.defer_fn(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(text .. " ", true, false, true), "n", true)
          if callback then
            callback()
          end
        end, 100)
      end)
    )
  end
end

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
  { "<M-k>", "<C-\\><C-n><C-b>", mode = { "n", "t" }, ft = "claude_code" },
  { "<M-j>", "<C-\\><C-n><C-f>", mode = { "n", "t" }, ft = "claude_code" },
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
  {
    "<leader>agc",
    function()
      focus_and_send "/commit"
    end,
    mode = "n",
    desc = "AI generate commit message",
  },
  {
    "<leader>agd",
    function()
      focus_and_send("/document ", function()
        vim.cmd "ClaudeCode"
        vim.cmd "ClaudeCodeAdd %"
      end)
    end,
    mode = "n",
    desc = "AI generate documentation for file",
  },
  {
    "<leader>agd",
    function()
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "v", true)
      focus_and_send("/document ", function()
        vim.cmd "ClaudeCode"
        vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
        vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
        vim.cmd "normal! gv"
        vim.cmd "ClaudeCodeSend"
      end)
    end,
    mode = "v",
    desc = "AI generate documentation for selection",
  },
  {
    "<leader>agr",
    function()
      focus_and_send "/review"
    end,
    mode = "n",
    desc = "AI generate PR review",
  },
}

if position == "right" then
  table.insert(M.keys, { "<C-h>", "<cmd>wincmd h<cr>", mode = "t", ft = "claude_code" })
elseif position == "bottom" then
  table.insert(M.keys, { "<C-k>", "<cmd>wincmd k<cr>", mode = "t", ft = "claude_code" })
end

return M
