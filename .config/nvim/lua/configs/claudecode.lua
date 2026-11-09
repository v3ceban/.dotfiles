local M = {}

--- @type table | nil
local native = nil

local function get_native()
  if not native then
    native = require "claudecode.terminal.native"
  end
  return native
end

local function force_redraw()
  local bufnr = get_native().get_active_bufnr()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local chan = vim.b[bufnr].terminal_job_id
  local win = vim.fn.win_findbuf(bufnr)[1]
  if not chan or not win then
    return
  end
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  vim.fn.jobresize(chan, width, height - 1)
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].terminal_job_id == chan then
      vim.fn.jobresize(chan, width, height)
    end
  end, 10)
end

local function apply_buf_opts()
  local bufnr = get_native().get_active_bufnr()
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    vim.bo[bufnr].filetype = "claude_code"
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].matchpairs = ""
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
  env = { TMUX = "" },
  terminal = {
    provider = custom_provider,
    split_width_percentage = 0.40,
    show_native_term_exit_tip = false,
  },
  diff_opts = {
    layout = "unified",
    open_in_new_tab = true,
    hide_terminal_in_new_tab = true,
    auto_resize_terminal = false,
    on_new_file_reject = "close_window",
  },
}

--- Focus the Claude terminal and submit a prompt once connected.
--- @param prompt string The prompt to submit (e.g. "/commit")
local function send_prompt(prompt)
  if vim.bo.filetype ~= "claude_code" then
    vim.cmd "ClaudeCodeFocus"
  else
    vim.cmd "startinsert"
  end

  local claudecode = require "claudecode"
  local terminal = require "claudecode.terminal"
  local deadline = vim.uv.now() + 10000
  local timer = assert(vim.uv.new_timer())

  timer:start(
    0,
    50,
    vim.schedule_wrap(function()
      local connected = claudecode.is_claude_connected()
      if not connected and vim.uv.now() < deadline then
        return
      end
      timer:stop()
      timer:close()
      if not connected then
        vim.notify("Claude didn't connect, prompt not sent", vim.log.levels.WARN)
        return
      end
      -- Ctrl+S stashes input, Ctrl+C interrupts any running turn, then submit
      local steps = { { "\x13", { submit = false } }, { "\x03", { submit = false } }, { prompt } }
      for _, step in ipairs(steps) do
        terminal.send_to_terminal(unpack(step))
      end
    end)
  )
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("ClaudeCodeDiffKeys", { clear = true }),
  pattern = "ClaudeCodeDiffOpened",
  callback = function(ev)
    if ev.data.tab_number and ev.data.target_window ~= ev.data.diff_window then
      pcall(vim.api.nvim_win_close, ev.data.target_window, false)
    end
    local buf = vim.api.nvim_win_get_buf(ev.data.diff_window)
    vim.keymap.set(
      "n",
      "<leader>ay",
      "<cmd>ClaudeCodeDiffAccept<cr>",
      { buffer = buf, desc = "AI accept claude change" }
    )
    vim.keymap.set("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { buffer = buf, desc = "AI deny claude change" })
  end,
})

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI toggle claude terminal" },
  { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "AI send file to claude" },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI send selection to claude" },
  {
    "<leader>aa",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    mode = "n",
    desc = "AI send file to claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
  },
  {
    "<M-i>",
    function()
      vim.cmd "ClaudeCode"
      require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
      local term_win = vim.api.nvim_get_current_win()
      vim.cmd "ClaudeCode"
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(term_win) then
          vim.api.nvim_set_current_win(term_win)
        end
      end)
    end,
    mode = { "n", "t" },
    ft = "claude_code",
  },
  {
    "<C-n>",
    function()
      vim.cmd "ClaudeCode"
      vim.cmd "NvimTreeToggle"
      vim.cmd "ClaudeCode"
    end,
    mode = { "n", "t" },
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
    "<leader>ac",
    function()
      send_prompt "/compact"
    end,
    mode = "n",
    desc = "AI compact claude session",
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
      send_prompt "/code-review"
    end,
    mode = "n",
    desc = "AI generate code review",
  },
  {
    "<leader>ags",
    function()
      send_prompt "/simplify report the suggested cleanups; do NOT edit any files!"
    end,
    mode = "n",
    desc = "AI generate simplify review",
  },
  {
    "<leader>agv",
    function()
      send_prompt "/security-review"
    end,
    mode = "n",
    desc = "AI generate vulnerability review",
  },
  { "<M-S-h>", "<cmd>TmuxNavigateLeft<CR>", mode = { "n", "t" }, ft = "claude_code" },
  { "<M-S-j>", "<cmd>TmuxNavigateDown<CR>", mode = { "n", "t" }, ft = "claude_code" },
  { "<M-S-k>", "<cmd>TmuxNavigateUp<CR>", mode = { "n", "t" }, ft = "claude_code" },
  { "<M-S-l>", "<cmd>TmuxNavigateRight<CR>", mode = { "n", "t" }, ft = "claude_code" },
  { "<C-l>", force_redraw, mode = { "n", "t" }, ft = "claude_code", desc = "AI force terminal redraw" },
}

return M
