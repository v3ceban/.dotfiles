require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Resets
local modes = vim.env.TMUX and { "n", "t" } or { "n" }
unmap(modes, "<C-h>")
unmap(modes, "<C-j>")
unmap(modes, "<C-k>")
unmap(modes, "<C-l>")

-- General
map({ "n" }, "<C-s>", "<cmd>wa<CR>", { desc = "save all files" })
map({ "n" }, "<C-q>", "<cmd>qa!<CR>", { desc = "close all buffers and quit" })
map({ "n", "i", "v", "t" }, "<C-z>", "<nop>")
map({ "n", "i", "v", "t" }, "<C-S-z>", "<nop>")
map({ "n", "v" }, "Q", "q")
map({ "v" }, "<C-c>", "y", { desc = "clipboard copy selection" })
map({ "v" }, "<C-x>", "d", { desc = "clipboard cut selection" })
map("n", "<M-S-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "switch window left" })
map("n", "<M-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "switch window down" })
map("n", "<M-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "switch window up" })
map("n", "<M-S-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "switch window right" })

-- Search and replace
local function escape_pattern(text)
  return text:gsub("[/\\.]", "\\%0")
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
map({ "v" }, "<leader>sw", function()
  vim.cmd 'normal! "zy'
  local text = escape_pattern(vim.fn.getreg "z")
  vim.fn.setreg("/", text)
  vim.cmd "normal! n"
end, { desc = "search selection", noremap = true })
map({ "v" }, "<leader>sr", function()
  vim.cmd 'normal! "zy'
  local text = escape_pattern(vim.fn.getreg "z")
  vim.fn.feedkeys(
    ":%s/" .. text .. "/" .. text .. "/gc" .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
    "n"
  )
end, { desc = "search replace selection", noremap = true })
map({ "v" }, "<leader>ss", function()
  vim.cmd 'normal! "zy'
  local text = escape_pattern(vim.fn.getreg "z")
  vim.fn.feedkeys(
    ":%Subvert/"
      .. text
      .. "/"
      .. text
      .. "/gc"
      .. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
    "n"
  )
end, { desc = "search subvert selection", noremap = true })

-- Selection movement
map({ "v" }, "J", ":m '>+1<CR>gv=gv", { desc = "move selection down", silent = true })
map({ "v" }, "K", ":m '<-2<CR>gv=gv", { desc = "move selection up", silent = true })
map({ "v" }, ">", ">gv", { desc = "indent selection right", silent = true })
map({ "v" }, "<", "<gv", { desc = "indent selection left", silent = true })

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
  vim.diagnostic.jump {
    count = -1,
    float = {
      border = "rounded",
    },
  }
end, { desc = "lsp previous diagnostic", silent = true })
map({ "n" }, "]d", function()
  vim.diagnostic.jump {
    count = 1,
    float = {
      border = "rounded",
    },
  }
end, { desc = "lsp next diagnostic", silent = true })
map({ "n" }, "K", function()
  vim.lsp.buf.hover { border = "rounded" }
end, { desc = "lsp show available info", silent = true })
map({ "i" }, "<M-K>", function()
  vim.lsp.buf.signature_help { border = "rounded" }
end, { desc = "lsp show signature help", silent = true })
map({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "lsp code action", silent = true })

-- Gitsigns
map({ "n" }, "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<CR>", { desc = "git blame line" })
map({ "n" }, "<leader>gB", "<cmd>lua require('gitsigns').blame()<CR>", { desc = "git blame file" })
map({ "n" }, "<leader>gd", "<cmd>lua require('gitsigns').diffthis()<CR>", { desc = "git diff file" })
map({ "n" }, "[h", "<cmd>lua require('gitsigns').prev_hunk()<CR>", { desc = "git previous hunk" })
map({ "n" }, "]h", "<cmd>lua require('gitsigns').next_hunk()<CR>", { desc = "git next hunk" })

-- NeoCodeium
map({ "i" }, "<M-l>", function()
  require("neocodeium").accept()
end, { desc = "AI accept suggestion", silent = true })
map({ "i" }, "<M-j>", function()
  require("neocodeium").cycle(1)
end, { desc = "AI next suggestion", silent = true })
map({ "i" }, "<M-k>", function()
  require("neocodeium").cycle(-1)
end, { desc = "AI previous suggestion", silent = true })

-- Flash.nvim
map({ "v", "o" }, "v", function()
  require("flash").treesitter()
end, { desc = "select treesitter node visually" })
