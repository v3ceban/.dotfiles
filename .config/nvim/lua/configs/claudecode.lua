local M = {}

M.opts = {
  terminal = {
    split_side = "right",
    split_width_percentage = 0.39,
    snacks_win_opts = {
      keys = {
        {
          "<C-h>",
          function()
            vim.cmd "wincmd h"
          end,
          mode = { "n", "t" },
          buffer = true,
        },
        {
          "<C-l>",
          function()
            vim.cmd "wincmd l"
          end,
          mode = { "n", "t" },
          buffer = true,
        },
      },
    },
  },
}

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI Toggle Claude" },
  { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "AI Select Claude model" },
  { "<leader>aa", "<cmd>ClaudeCodeAdd %<cr>", desc = "AI Add file to Claude" },
  { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI Add selection to Claude" },
  {
    "<leader>aa",
    "<cmd>ClaudeCodeTreeAdd<cr>",
    desc = "AI Add file to Claude",
    ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  },
  -- Diff management
  { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "AI Accept Claude change" },
  { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "AI Deny Claude change" },
  {
    "<leader>agc",
    function()
      vim.fn.system { "git", "add", "." }
      local response = vim.fn.system {
        "claude",
        "-p",
        [[
## Context

- Current git status: !`git status`
- Current git diff: !`git diff --staged`
- Recent commits (10): !`git log -10 --oneline`

## Instructions

Use allowed `Bash` tool and `git` command to get the information about all staged changes. After you access the changes, analyze them and write a short, but comprehensive commit message, that follows commitizen convention. It needs to look like this:

```gitcommit
feat(commit): title of the commit message

Commit message body that explains the changes...
```

Respond only with the commit message wrapped in a code block and nothing else.

## Rules

1. **ALWAYS** respond with the exact commit message wrapped in a code block
2. **ALWAYS** Keep the title under 50 characters and wrap message at 72 characters
3. **ALWAYS** follow commitizen convention
4. **NEVER** use emojis
5. **NEVER** add Claude, Claude Code, Anthropic, or any other AI tool, agent, or company as an author or a co-author of the commit or commit message
6. **ALWAYS** mention breaking changes in the commit message if there are any by adding `BREAKING CHANGE:` section to the commit message body
        ]],
        "--model",
        "haiku",
        "--allowedTools",
        '"Read Bash(git log:*) Bash(git status:*) Bash(git diff:*)"',
      }
      local commit_message = response:match "```gitcommit\n(.+)\n```"
      if commit_message then
        if vim.fn.confirm("Create a commit with this message?\n" .. commit_message, "&Yes\n&No", 2) == 1 then
          vim.fn.system { "git", "commit", "-m", commit_message }
          if vim.fn.confirm("Push this commit to remote?", "&Yes\n&No", 2) == 1 then
            vim.fn.system { "git", "push" }
          end
        end
      end
    end,
  },
}

return M
