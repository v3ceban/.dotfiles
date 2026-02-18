local M = {}

--- @type table | nil
local native = nil

local function get_native()
  if not native then
    native = require "claudecode.terminal.native"
  end
  return native
end

local function apply_buf_opts()
  local bufnr = get_native().get_active_bufnr()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    vim.bo[bufnr].filetype = "claude_code"
    vim.bo[bufnr].buflisted = false
    for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
      vim.wo[win].winfixwidth = true
    end
  end
end

local custom_provider = setmetatable({}, {
  __index = function(_, key)
    local fn = get_native()[key]
    if fn then
      return fn
    end
  end,
})

for _, method in ipairs { "open", "simple_toggle", "focus_toggle" } do
  custom_provider[method] = function(...)
    get_native()[method](...)
    apply_buf_opts()
  end
end

M.opts = {
  terminal = {
    provider = custom_provider,
    split_width_percentage = 0.40,
    show_native_term_exit_tip = false,
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
local function send_slash_command(text, callback)
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
        local bufnr = get_native().get_active_bufnr()
        if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
          local chan = vim.b[bufnr].terminal_job_id
          if chan then
            vim.fn.chansend(chan, "\x03")
            vim.defer_fn(function()
              vim.fn.chansend(chan, text)
              vim.defer_fn(function()
                vim.fn.chansend(chan, "\r")
                if callback then
                  callback()
                end
              end, 100)
            end, 100)
          end
        end
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
  { "<M-k>", "<C-\\><C-n><C-u>", mode = { "n", "t" }, ft = "claude_code" },
  { "<M-j>", "<C-\\><C-n><C-d>", mode = { "n", "t" }, ft = "claude_code" },
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
    "<leader>ac",
    function()
      send_slash_command "/clear"
    end,
    mode = "n",
    desc = "AI clear claude session",
  },
  {
    "<leader>ar",
    function()
      send_slash_command "/resume"
    end,
    mode = "n",
    desc = "AI resume claude session",
  },
  {
    "<leader>ae",
    function()
      send_slash_command "/export"
    end,
    mode = "n",
    desc = "AI export claude session",
  },
  {
    "<leader>agc",
    function()
      send_slash_command "/commit"
    end,
    mode = "n",
    desc = "AI generate commit message",
  },
  {
    "<leader>agd",
    function()
      send_slash_command "/document"
    end,
    mode = "n",
    desc = "AI generate documentation for file",
  },
  {
    "<leader>agr",
    function()
      send_slash_command "/review"
    end,
    mode = "n",
    desc = "AI generate PR review",
  },
  { "<C-h>", "<cmd>wincmd h<cr>", mode = "t", ft = "claude_code" },
}

return M
