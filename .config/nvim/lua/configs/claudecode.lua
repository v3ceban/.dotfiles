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
    local group = vim.api.nvim_create_augroup("ClaudeCodeAutoInsert", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.cmd "startinsert"
      end,
    })
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

--- Focus the Claude terminal and send a prompt once connected.
--- @param prompt string The prompt to feed (e.g. "/commit ")
local function send_prompt(prompt)
  if vim.bo.filetype ~= "claude_code" then
    vim.cmd "ClaudeCodeFocus"
  else
    vim.cmd "startinsert"
  end

  local timer = assert(vim.uv.new_timer())

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
          vim.defer_fn(function()
            vim.fn.chansend(chan, "\x15") -- Ctrl+U to clear the input
            vim.defer_fn(function()
              vim.fn.chansend(chan, "\x03") -- Ctrl+C to interrupt any running command
              vim.defer_fn(function()
                vim.fn.chansend(chan, prompt) -- Send the prompt
                vim.defer_fn(function()
                  vim.fn.chansend(chan, "\r") -- Press Enter
                end, 150)
              end, 150)
            end, 150)
          end, 150)
        end
      end
    end)
  )
end

local function find_claudecode_diff_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].claudecode_diff_tab_name then
      return win
    end
  end
end

local function run_in_diff_win(cmd)
  local win = find_claudecode_diff_win()
  if not win then
    return
  end
  local prev_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(win)
  vim.cmd(cmd)
  if vim.api.nvim_win_is_valid(prev_win) then
    pcall(vim.api.nvim_set_current_win, prev_win)
  end
end

local diff_group = vim.api.nvim_create_augroup("ClaudeCodeDiffKeys", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "OptionSet" }, {
  group = diff_group,
  callback = function(ev)
    if ev.event == "OptionSet" and ev.match ~= "diff" then
      return
    end
    vim.schedule(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.wo.diff and find_claudecode_diff_win() then
        vim.keymap.set("n", "<leader>ay", function()
          run_in_diff_win "ClaudeCodeDiffAccept"
        end, { buffer = bufnr, desc = "AI accept claude change" })
        vim.keymap.set("n", "<leader>an", function()
          run_in_diff_win "ClaudeCodeDiffDeny"
        end, { buffer = bufnr, desc = "AI deny claude change" })
      else
        pcall(vim.keymap.del, "n", "<leader>ay", { buffer = bufnr })
        pcall(vim.keymap.del, "n", "<leader>an", { buffer = bufnr })
      end
    end)
  end,
})

local function force_redraw()
  local bufnr = get_native().get_active_bufnr()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    local width = vim.api.nvim_win_get_width(win)
    vim.api.nvim_win_set_width(win, width - 1)
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, width)
      end
    end, 10)
  end
end

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI toggle claude terminal" },
  { "<leader>ac", "<cmd>ClaudeCodeFocus<cr>", mode = "n", desc = "AI focus claude terminal" },
  { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "AI send file to claude" },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI send selection to claude" },
  {
    "<leader>aa",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    mode = "n",
    desc = "AI send file to claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  },
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
    "<leader>an",
    function()
      send_prompt "/clear"
    end,
    mode = "n",
    desc = "AI new claude session",
  },
  {
    "<leader>ar",
    function()
      send_prompt "/resume"
    end,
    mode = "n",
    desc = "AI resume claude session",
  },
  {
    "<leader>ae",
    function()
      send_prompt "/export"
    end,
    mode = "n",
    desc = "AI export claude session",
  },
  {
    "<leader>agc",
    function()
      send_prompt "/commit"
    end,
    mode = "n",
    desc = "AI generate commit message",
  },
  {
    "<leader>agr",
    function()
      send_prompt "/review"
    end,
    mode = "n",
    desc = "AI generate PR review",
  },
  { "<C-h>", "<cmd>wincmd h<cr>", mode = "t", ft = "claude_code" },
  { "<C-l>", force_redraw, mode = "t", ft = "claude_code", desc = "AI force terminal redraw" },
}

return M
