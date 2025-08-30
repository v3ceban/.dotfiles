local M = {}

M.prompts = {
  commit = [[
# Generate a commit message

## Task

Write a commit message for the changes in the project.

### Details, Context, and Instructions

Use `Bash` tool and `git` command to get the information about all staged changes.
After you access the changes, analyze them and write a short, but comprehensive
commit message, that follows commitizen convention that looks like this:

```gitcommit
feat(commit): title of the commit message

Commit message body that explains the changes...
```

After the message is generated, commit it using `git commit -m "<message>"` command
and push it to the remote repository, if it exists, using `git push` command.

### Rules

1. ALWAYS Keep the title under 50 characters and wrap message at 72 characters
2. ALWAYS follow commitizen convention
4. NEVER use emojis
3. NEVER add Claude, Claude Code, Openai, Codex, Opencode, or any other AI tool or
   agent as an author or a co-author of the commit or commit message
4. ALWAYS mention breaking changes in the commit message if there are any by
   adding `BREAKING CHANGE:` section to the commit message body
  ]],

  documentation = [[
# Add documentation comments

## Task
Add documentation comments to the provided code selection.

### Details, Context, and Instructions
Look at the provided @selection and add docummentation comments to all logical
parts of the code. Use the appropriate documentation style for the programming
language of selection. For example:
- For Python, use triple quotes (""" """) for docstrings.
- For JavaScript/TypeScript, use JSDoc style comments (/** */) with @param,
  @returns, and @example tags with example usages wrapped in corresponding
  language code blocks (e.g., ```javascript ... ```).
- For Go, use // comments with special formatting for functions and types.
- Etc.

Apply comments directly above the relevant code elements (functions, classes, methods, etc.).

### Rules
1. ALWAYS use the appropriate documentation style for the programming language of the selection.
2. ALWAYS ensure comments are clear, concise, and informative.
3. NEVER add comments to trivial code that is self-explanatory.
4. NEVER use emojis in comments.
5. NEVER add Claude, Claude Code, Openai, Codex, Opencode, or any other AI tool or
   agent as an author or a co-author of the comments or code.
6. Provide examples of usage in the comments where applicable.
7. If the programming language of the selection is not recognized, use plain English comments.
  ]],
}

M.opts = {
  prompts = {
    explain = {
      description = "Explain code near cursor",
      prompt = "Explain @cursor and its context",
    },
    fix = {
      description = "Fix diagnostics",
      prompt = "Fix these @diagnostics",
    },
    optimize = {
      description = "Optimize selection",
      prompt = "Optimize @selection for performance and readability",
    },
    document = {
      description = "Document selection",
      prompt = M.prompts.documentation,
    },
    test = {
      description = "Add tests for selection",
      prompt = "Add tests for @selection",
    },
    review_buffer = {
      description = "Review buffer",
      prompt = "Review @buffer for correctness and readability",
    },
    review_diff = {
      description = "Review git diff",
      prompt = "Review the following git diff for correctness and readability:\n@diff",
    },
    generate_commit = {
      description = "Generate commit message",
      prompt = M.prompts.commit,
    },
  },
  input = {
    prompt = "Ask opencode: ",
    icon = "󱚣 ",
  },
  terminal = {
    auto_close = true,
    win = {
      position = "right",
      enter = true,
      bo = {
        filetype = "opencode_terminal",
      },
    },
    env = {
      -- Other themes have visual bugs in embedded terminals: https://github.com/sst/opencode/issues/445
      OPENCODE_THEME = "system",
    },
  },
}

M.keys = {
  {
    "<leader>aA",
    function()
      require("opencode").ask()
    end,
    mode = "n",
    desc = "AI Ask opencode",
  },
  {
    "<leader>aa",
    function()
      require("opencode").ask "@cursor: "
    end,
    mode = "n",
    desc = "AI Ask opencode about line",
  },
  {
    "<leader>aa",
    function()
      require("opencode").ask "@selection: "
    end,
    mode = "v",
    desc = "AI Ask opencode about selection",
  },
  {
    "<leader>an",
    function()
      require("opencode").command "session_new"
    end,
    mode = "n",
    desc = "AI New opencode session",
  },
  {
    "<leader>ar",
    function()
      require("opencode").select_prompt()
    end,
    mode = { "n", "v" },
    desc = "AI Run opencode prompt",
  },
  -- window management
  {
    "<M-a>",
    function()
      require("opencode").toggle()
    end,
    mode = { "n", "t" },
    desc = "AI Toggle opencode window",
  },
  {
    "<Esc>",
    function()
      vim.cmd "q"
    end,
    mode = { "n", "t", "i", "v", "o" },
    ft = "opencode_ask",
  },
  {
    "<M-j>",
    function()
      require("opencode").command "messages_half_page_down"
    end,
    mode = { "n", "t" },
    desc = "AI Scroll down in opencode terminal",
    buffer = true,
    ft = "opencode_terminal",
  },
  {
    "<M-k>",
    function()
      require("opencode").command "messages_half_page_up"
    end,
    mode = { "n", "t" },
    desc = "AI Scroll up in opencode terminal",
    buffer = true,
    ft = "opencode_terminal",
  },
  {
    "<C-h>",
    function()
      vim.cmd "wincmd h"
    end,
    mode = { "n", "t" },
    buffer = true,
    ft = "opencode_terminal",
  },
  {
    "<C-l>",
    function()
      vim.cmd "wincmd l"
    end,
    mode = { "n", "t" },
    buffer = true,
    ft = "opencode_terminal",
  },
  -- prompt execution
  {
    "<leader>agc",
    function()
      vim.fn.system { "git", "add", "." }
      require("opencode").prompt(M.prompts.commit)
    end,
    mode = "n",
    desc = "AI Generate commit message",
  },
  {
    "<leader>agd",
    function()
      require("opencode").prompt(M.prompts.documentation)
    end,
    mode = "n",
    desc = "AI Generate documentation comments",
  },
}

return M
