require "nvchad.mappings"

local map = vim.keymap.set

-- General
map({ "n", "i", "v", "t" }, "<C-s>", "<cmd>wa<CR>", { desc = "save all files" })
map({ "n", "i", "v", "t" }, "<C-q>", "<cmd>qa!<CR>", { desc = "close all buffers and quit" })
map({ "n", "i", "v", "t" }, "<C-z>", "<nop>")
map({ "n", "v" }, "Q", "q")
map({ "v" }, "<C-c>", "y", { desc = "general copy selection" })
map({ "v" }, "<C-x>", "d", { desc = "general cut selection" })

-- Search and replace
local function escape_pattern(text)
  return text:gsub("[/\\]", "\\%0")
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
local tabufline = require "nvchad.tabufline"
local close_floats = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      vim.api.nvim_win_close(win, true)
    end
  end
end
map("n", "<leader>x", function()
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
map("n", "<tab>", function()
  if vim.bo.filetype ~= "snacks_terminal" and vim.bo.filetype ~= "NvTerm_float" then
    close_floats()
    tabufline.next()
  end
end, { desc = "buffer goto next" })
map("n", "<S-tab>", function()
  if vim.bo.filetype ~= "snacks_terminal" and vim.bo.filetype ~= "NvTerm_float" then
    close_floats()
    tabufline.prev()
  end
end, { desc = "buffer goto prev" })
for i = 1, 9, 1 do
  map("n", string.format("%s<Tab>", i), function()
    if vim.t.bufs and vim.t.bufs[i] then
      vim.api.nvim_set_current_buf(vim.t.bufs[i])
    end
  end, { desc = string.format("tabufline go to buffer %s", i), silent = true })
end

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

-- Github Copilot
map(
  { "i" },
  "<M-l>",
  [[copilot#Accept("\\<CR>")]],
  { desc = "AI accept suggestion", expr = true, replace_keycodes = false, silent = true }
)
map({ "i" }, "<M-j>", "copilot#Next()", { desc = "AI next suggestion", expr = true, silent = true })
map({ "i" }, "<M-k>", "copilot#Previous()", { desc = "AI previous suggestion", expr = true, silent = true })

-- OpenCode
map({ "n" }, "<leader>agc", function()
  vim.notify("Generating commit message...", vim.log.levels.INFO)
  if vim.fn.confirm("Stage all changes before generating commit message?", "&Yes\n&No", 2) == 1 then
    vim.fn.system { "git", "add", "." }
  end
  local status = vim.fn.systemlist { "git", "status" }
  local diff = vim.fn.systemlist { "git", "diff", "--staged", "-U0" }
  local log = vim.fn.systemlist { "git", "log", "-10" }
  local response = vim.fn.system {
    "opencode",
    "run",
    [[
## Context
**Current git status:**
]]
      .. table.concat(status, "\n")
      .. [[
**Current git diff:**
]]
      .. table.concat(diff, "\n")
      .. [[
**Recent commits (10):**
]]
      .. table.concat(log, "\n")
      .. [[

## Instructions

Analyze staged changes and write a short, but comprehensive commit message, that follows commitizen convention. It needs to look like this:

```gitcommit
feat(commit): title of the commit message

Commit message body that explains the changes...
```

Respond only with the commit message wrapped in a code block and nothing else.

## Rules

1. **ALWAYS** respond **ONLY** with the exact commit message wrapped in a code block and **NOTHING ELSE**
2. **ALWAYS** Keep the title under 50 characters and wrap message at 72 characters
3. **ALWAYS** follow commitizen convention
4. **NEVER** use emojis
5. **NEVER** add OpenCode, Copilot, OpenAI, ChatGPT, Claude, Claude Code, Anthropic, or any other AI tool, agent, or company as an author or a co-author of the commit or commit message
6. **ALWAYS** mention breaking changes in the commit message if there are any by adding `BREAKING CHANGE:` section to the commit message body
        ]],
    "--agent",
    "commiter",
    "--model",
    "github-copilot/gpt-4.1",
  }
  local commit_message = response:match "```gitcommit\n(.+)\n```"
  if commit_message then
    if vim.fn.confirm("Create a commit with this message?\n" .. commit_message, "&Yes\n&No", 2) == 1 then
      vim.fn.system { "git", "commit", "-m", commit_message }
      if vim.fn.confirm("Push this commit to remote?", "&Yes\n&No", 2) == 1 then
        vim.fn.system { "git", "push" }
      end
    end
  else
    local error_message = (response:match "Error:%s*(.+)" or response):gsub("\27%[[0-9;]*m", "")
    vim.notify("Error: " .. error_message, vim.log.levels.ERROR)
  end
end, { desc = "AI generate commit message" })

-- Flash.nvim
map({ "v", "o" }, "v", function()
  require("flash").treesitter()
end, { desc = "select treesitter node visually" })
