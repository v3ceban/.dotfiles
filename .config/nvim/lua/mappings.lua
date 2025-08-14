require "nvchad.mappings"

local map = vim.keymap.set

-- General
map({ "n", "i", "v", "t" }, "<C-s>", "<cmd>wa<CR>", { desc = "Save all files" })
map({ "n", "i", "v", "t" }, "<C-q>", "<cmd>qa!<CR>", { desc = "Close all buffers and quit" })
map({ "n", "i", "v", "t" }, "<C-z>", "<nop>")
map({ "n", "v" }, "Q", "q")
map({ "v" }, "<C-c>", "y", { desc = "general Copy selection" })
map({ "v" }, "<C-x>", "d", { desc = "general Cut selection" })

-- Search and replace
map({ "n" }, "<leader>sw", [[:/<C-r><C-w><CR>]], { desc = "Search word", noremap = true })
map(
  { "n" },
  "<leader>sr",
  [[:%s/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>]],
  { desc = "Search replace word", noremap = true }
)
map(
  { "n" },
  "<leader>ss",
  [[:%Subvert/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>]],
  { desc = "Search subvert word", noremap = true }
)
map({ "v" }, "<leader>sw", [["zy:/<C-r>z<CR>]], { desc = "Search selection", noremap = true })
map(
  { "v" },
  "<leader>sr",
  [["zy:%s/<C-r>z/<C-r>z/gc<Left><Left><Left>]],
  { desc = "Search replace selection", noremap = true }
)
map(
  { "v" },
  "<leader>ss",
  [["zy:%Subvert/<C-r>z/<C-r>z/gc<Left><Left><Left>]],
  { desc = "Search subvert selection", noremap = true }
)

-- Selection movement
map({ "v" }, "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map({ "v" }, "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
map({ "v" }, ">", ">gv", { desc = "Indent selection right", silent = true })
map({ "v" }, "<", "<gv", { desc = "Indent selection left", silent = true })

-- Resize windows
map({ "n" }, "<C-Up>", "<C-w>+", { desc = "Resize increase window height" })
map({ "n" }, "<C-Down>", "<C-w>-", { desc = "Resize decrease window height" })
map({ "n" }, "<C-Right>", "<C-w>>", { desc = "Resize increase window width" })
map({ "n" }, "<C-Left>", "<C-w><", { desc = "Resize decrease window width" })

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
  end, { desc = string.format("Tabufline go to buffer %s", i), silent = true })
end

-- Diagnostics and LSP
map({ "n" }, "[d", function()
  vim.diagnostic.jump {
    count = -1,
    float = {
      border = "rounded",
    },
  }
end, { desc = "LSP previous diagnostic", silent = true })
map({ "n" }, "]d", function()
  vim.diagnostic.jump {
    count = 1,
    float = {
      border = "rounded",
    },
  }
end, { desc = "LSP next diagnostic", silent = true })
map({ "n" }, "K", function()
  vim.lsp.buf.hover { border = "rounded" }
end, { desc = "LSP show available info", silent = true })
map({ "i" }, "<M-K>", function()
  vim.lsp.buf.signature_help { border = "rounded" }
end, { desc = "LSP show signature help", silent = true })
map({ "n", "v" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "LSP code action", silent = true })

-- Gitsigns
map({ "n" }, "<leader>gb", "<cmd>lua require('gitsigns').blame_line()<CR>", { desc = "Git blame line" })
map({ "n" }, "[h", "<cmd>lua require('gitsigns').prev_hunk()<CR>", { desc = "Git previous hunk" })
map({ "n" }, "]h", "<cmd>lua require('gitsigns').next_hunk()<CR>", { desc = "Git next hunk" })

-- Git conflict
map({ "n" }, "<leader>gco", "<cmd>GitConflictChooseOurs<CR>", { desc = "Git choose our commit" })
map({ "n" }, "<leader>gct", "<cmd>GitConflictChooseTheirs<CR>", { desc = "Git choose theirs commit" })
map({ "n" }, "<leader>gcn", "<cmd>GitConflictChooseNone<CR>", { desc = "Git choose none commits" })
map({ "n" }, "<leader>gcb", "<cmd>GitConflictChooseBoth<CR>", { desc = "Git choose both commits" })
map({ "n" }, "[c", "<cmd>GitConflictPrevConflict<CR>", { desc = "Git previous conflict" })
map({ "n" }, "]c", "<cmd>GitConflictNextConflict<CR>", { desc = "Git next conflict" })

-- Github Copilot
map(
  { "i" },
  "<M-l>",
  [[copilot#Accept("\\<CR>")]],
  { desc = "AI Accept suggestion", expr = true, replace_keycodes = false, silent = true }
)
map({ "i" }, "<M-j>", "copilot#Next()", { desc = "AI Next suggestion", expr = true, silent = true })
map({ "i" }, "<M-k>", "copilot#Previous()", { desc = "AI Previous suggestion", expr = true, silent = true })

-- Generate Commit Message
map({ "n" }, "<leader>agc", function()
  local commit_prompt = [[
# Generate a commit message

## Task

Write a commit message for the changes in the project.

### Details, Context, and Instructions

Use `Bash` tool and `git` command to get the information about all staged changes.
After you access the changes, analyze them and write a short, but comprehensive
commit message, that follows commitizen convention. Wrap the whole message in code
block with language `gitcommit` like this:

```gitcommit
feat(commit): title of the commit message

Commit message body that explains the changes...
```

### Rules

1. ALWAYS Keep the title under 50 characters and wrap message at 72 characters
2. ALWAYS follow commitizen convention
3. ALWAYS wrap the commit message in the code block with `gitcommit` message
4. NEVER use emojies
5. NEVER add Claude or Claude Code as an author or a co-author of the commit or commit message
6. ALWAYS mention breaking changes in the commit message if there are any by
   adding `BREAKING CHANGE:` section to the commit message body
  ]]
  vim.fn.system { "git", "add", "." }
  print "Generating commit message..."
  vim.cmd "redraw"
  local handle = io.popen("opencode run '" .. commit_prompt .. "' -m github-copilot/gpt-4.1 2>/dev/null")
  if handle then
    local commit_message = handle:read("*a"):match "```gitcommit\n(.-)\n```"
    handle:close()
    if commit_message then
      local commit_choice = vim.fn.confirm("Create a commit with this message?\n" .. commit_message, "&Yes\n&No", 2)
      if commit_choice == 1 then
        vim.fn.system { "git", "commit", "-m", commit_message }
        local push_choice = vim.fn.confirm("Push this commit to remote?", "&Yes\n&No", 2)
        if push_choice == 1 then
          vim.fn.system { "git", "push" }
        end
      end
    end
  else
    print "Failed to generate commit message"
  end
end, {
  desc = "AI Generate commit message",
  expr = true,
  silent = true,
})

-- Flash.nvim
map({ "v", "o" }, "v", function()
  require("flash").treesitter()
end, { desc = "Select treesitter node visually" })
