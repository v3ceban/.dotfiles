local M = {}

M.opts = {
  env = { TMUX = "" },
  terminal = {
    provider = "native",
    split_width_percentage = 0.40,
    show_native_term_exit_tip = false,
  },
  diff_opts = {
    open_in_new_tab = true,
    hide_terminal_in_new_tab = true,
    on_new_file_reject = "close_window",
  },
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ClaudeCodeTerminal", { clear = true }),
  pattern = "claudecode",
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.bo[ev.buf].matchpairs = ""
    vim.keymap.set("t", "<C-z>", "<nop>", { buffer = ev.buf })
    for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
      vim.wo[win].winfixwidth = true
    end
    vim.api.nvim_create_autocmd("BufEnter", { buffer = ev.buf, command = "startinsert" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("ClaudeCodeDiffKeys", { clear = true }),
  pattern = "ClaudeCodeDiffOpened",
  callback = function(ev)
    local diff_win = ev.data.diff_window
    local orig_buf = vim.api.nvim_win_get_buf(ev.data.target_window)
    local function map(lhs, cmd, desc)
      for _, buf in ipairs { vim.api.nvim_win_get_buf(diff_win), orig_buf } do
        vim.keymap.set("n", lhs, function()
          vim.api.nvim_set_current_win(diff_win)
          vim.cmd(cmd)
        end, { buffer = buf, desc = desc })
      end
    end
    map("<leader>ay", "ClaudeCodeDiffAccept", "AI accept claude change")
    map("<leader>an", "ClaudeCodeDiffDeny", "AI deny claude change")
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffClosed",
      once = true,
      callback = function()
        pcall(vim.keymap.del, "n", "<leader>ay", { buffer = orig_buf })
        pcall(vim.keymap.del, "n", "<leader>an", { buffer = orig_buf })
      end,
    })
  end,
})

--- Force the Claude terminal to redraw by shrinking its PTY one row, then restoring it.
local function force_redraw()
  local chan = vim.b.terminal_job_id
  if not chan then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local width = vim.api.nvim_win_get_width(win)
  local height = vim.api.nvim_win_get_height(win)
  vim.fn.jobresize(chan, width, height - 1)
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].terminal_job_id == chan then
      vim.fn.jobresize(chan, width, height)
    end
  end, 10)
end

--- Focus the Claude terminal and submit a prompt once connected.
--- @param prompt string The prompt to submit (e.g. "/commit")
local function send_prompt(prompt)
  if vim.bo.filetype ~= "claudecode" then
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
    ft = "claudecode",
  },
  {
    "<C-n>",
    function()
      vim.cmd "ClaudeCode"
      vim.cmd "NvimTreeToggle"
      vim.cmd "ClaudeCode"
    end,
    mode = { "n", "t" },
    ft = "claudecode",
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
  { "<M-S-h>", "<cmd>TmuxNavigateLeft<CR>", mode = { "n", "t" }, ft = "claudecode" },
  { "<M-S-j>", "<cmd>TmuxNavigateDown<CR>", mode = { "n", "t" }, ft = "claudecode" },
  { "<M-S-k>", "<cmd>TmuxNavigateUp<CR>", mode = { "n", "t" }, ft = "claudecode" },
  { "<M-S-l>", "<cmd>TmuxNavigateRight<CR>", mode = { "n", "t" }, ft = "claudecode" },
  { "<C-l>", force_redraw, mode = { "n", "t" }, ft = "claudecode", desc = "AI force terminal redraw" },
}

return M
