local M = {}

local commit_prompt = [[
# Generate a commit message

## Taks

Write a commit message for the changes in the project.

### Details, Context, and Instructions

Use `Bash` tool and `git` command to get the information about all staged changes.
After you access the changes, analyze them and write a short, but comprehensive
commit message, that follows commitizen convention. Wrap the whole message in code
block with language `gitcommit` like this:

```gitcommit
feat(commit): added commit message
```

### Rules

1. ALWAYS Keep the title under 50 characters and wrap message at 72 characters
2. ALWAYS follow commitizen convention
3. ALWAYS wrap the commit message in the code block with `gitcommit` message
4. NEVER use emojies
5. NEVER add Claude or Claude Code as an author or a co-author of the commit or commit message
]]

M.opts = {
  -- Terminal Configuration
  terminal = {
    split_side = "right", -- "left" or "right"
    split_width_percentage = 0.35,
    provider = "snacks", -- "auto", "snacks", "native", "external", or custom provider table
    auto_close = true,
    show_native_term_exit_tip = false,
    snacks_win_opts = {
      position = "float",
      width = 0.8,
      height = 0.8,
      border = "rounded",
    },
  },
}

M.keys = {
  { "<M-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI Toggle sidebar" },
  { "<leader>ac", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "AI Toggle sidebar" },
  { "<leader>af", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "AI Add selection" },
  {
    "<leader>af",
    function()
      local ft = vim.bo.filetype
      if ft == "NvimTree" or ft == "neo-tree" or ft == "oil" or ft == "minifiles" then
        vim.cmd "ClaudeCodeTreeAdd"
      else
        vim.cmd "ClaudeCodeAdd %"
      end
    end,
    desc = "AI Add file",
    mode = "n",
  },
  { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "AI Accept edit" },
  { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "AI Deny edit" },
  {
    "<leader>agc",
    function()
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
    end,
    desc = "Generate commit message",
    mode = "n",
  },
}

return M
