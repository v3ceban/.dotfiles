require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Resets
local modes = vim.env.TMUX and { "n", "t" } or { "n" }
unmap(modes, "<C-h>")
unmap(modes, "<C-j>")
unmap(modes, "<C-k>")
unmap(modes, "<C-l>")
unmap("s", "<leader>/")

-- General
map({ "n" }, "<C-s>", "<cmd>wa<CR>", { desc = "save all files" })
map({ "n" }, "<C-q>", "<cmd>qa!<CR>", { desc = "close all buffers and quit" })
map({ "n", "i", "v", "t" }, "<C-z>", "<nop>")
map({ "n", "i", "v", "t" }, "<C-S-z>", "<nop>")
map({ "n", "x" }, "Q", "q")
map({ "x" }, "<C-c>", "y", { desc = "clipboard copy selection" })
map({ "x" }, "<C-x>", "d", { desc = "clipboard cut selection" })
map({ "n", "v" }, "<M-S-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "switch window left" })
map({ "n", "v" }, "<M-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "switch window down" })
map({ "n", "v" }, "<M-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "switch window up" })
map({ "n", "v" }, "<M-S-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "switch window right" })

-- Search and replace
local function escape_pattern(text)
  return [[\V]] .. vim.fn.escape(text, [[/\]]):gsub("\n", [[\n]]):gsub("\t", [[\t]])
end
local function escape_replacement(text)
  return (vim.fn.escape(text, [[/\&~]]):gsub("\n", [[\r]]):gsub("\t", [[\t]]))
end
map({ "n" }, "<leader>sw", [[:/<C-r><C-w><CR>]], { desc = "search word", noremap = true })
map(
  { "n" },
  "<leader>sr",
  [[:%s/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>]],
  { desc = "search replace word", noremap = true }
)
map(
  { "n" },
  "<leader>ss",
  [[:%Subvert/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>]],
  { desc = "search subvert word", noremap = true }
)
map({ "x" }, "<leader>sw", function()
  vim.cmd 'normal! "zy'
  vim.fn.setreg("/", escape_pattern(vim.fn.getreg "z"))
  vim.cmd "normal! n"
end, { desc = "search selection", noremap = true })
map({ "x" }, "<leader>sr", function()
  vim.cmd 'normal! "zy'
  local text = vim.fn.getreg "z"
  vim.fn.feedkeys(
    ":%s/"
      .. escape_pattern(text)
      .. "/"
      .. escape_replacement(text)
      .. "/gc"
      .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
    "n"
  )
end, { desc = "search replace selection", noremap = true })
map({ "x" }, "<leader>ss", function()
  vim.cmd 'normal! "zy'
  local text = vim.fn.getreg("z"):gsub("\n$", "")
  if text:find "\n" then
    return vim.notify("Subvert can't take multi-line selections", vim.log.levels.WARN)
  end
  local sep = text:find("/", 1, true) and "#" or "/"
  vim.fn.feedkeys(
    ":%Subvert"
      .. sep
      .. text
      .. sep
      .. text
      .. sep
      .. "gc"
      .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
    "n"
  )
end, { desc = "search subvert selection", noremap = true })

-- Selection movement
map({ "x" }, "J", ":m '>+1<CR>gv=gv", { desc = "move selection down", silent = true })
map({ "x" }, "K", ":m '<-2<CR>gv=gv", { desc = "move selection up", silent = true })
map({ "x" }, ">", ">gv", { desc = "indent selection right", silent = true })
map({ "x" }, "<", "<gv", { desc = "indent selection left", silent = true })

-- Resize windows
map({ "n" }, "<C-Up>", "<C-w>+", { desc = "resize increase window height" })
map({ "n" }, "<C-Down>", "<C-w>-", { desc = "resize decrease window height" })
map({ "n" }, "<C-Right>", "<C-w>>", { desc = "resize increase window width" })
map({ "n" }, "<C-Left>", "<C-w><", { desc = "resize decrease window width" })

-- Tabufline
map("n", "<leader>x", function()
  local tabufline = require "nvchad.tabufline"
  local count = vim.v.count > 0 and vim.v.count or 1
  for _ = 1, count do
    local success = pcall(function()
      tabufline.close_buffer()
    end)
    if not success then
      vim.cmd "q"
      break
    end
  end
end, { desc = "close tab or window" })

-- Diagnostics and LSP
map({ "n" }, "[d", function()
  vim.diagnostic.jump { count = -1 }
end, { desc = "lsp previous diagnostic", silent = true })
map({ "n" }, "]d", function()
  vim.diagnostic.jump { count = 1 }
end, { desc = "lsp next diagnostic", silent = true })
map({ "n" }, "K", function()
  vim.lsp.buf.hover { border = "rounded" }
end, { desc = "lsp show available info", silent = true })
map({ "i" }, "<M-K>", function()
  vim.lsp.buf.signature_help { border = "rounded" }
end, { desc = "lsp show signature help", silent = true })
map({ "n", "x" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "lsp code action", silent = true })

-- Gitsigns
map({ "n" }, "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "git blame line", silent = true })
map({ "n" }, "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "git blame file", silent = true })
map({ "n" }, "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "git diff file", silent = true })
map({ "n" }, "<leader>gD", "<cmd>Gitsigns diffthis 'main'<CR>", { desc = "git diff file vs main", silent = true })
map({ "n" }, "[h", "<cmd>Gitsigns nav_hunk 'prev'<CR>", { desc = "git previous hunk", silent = true })
map({ "n" }, "]h", "<cmd>Gitsigns nav_hunk 'next'<CR>", { desc = "git next hunk", silent = true })

-- Flash.nvim
map({ "x", "o" }, "v", function()
  require("flash").treesitter()
end, { desc = "select treesitter node visually" })
