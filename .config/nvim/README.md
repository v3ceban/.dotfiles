# NvChad-Config

My custom configuration for [NeoVim](https://neovim.io/) uses [NvChad](https://nvchad.com/) as the base and includes some
additional plugins to enhance its core functionality.

This config transforms NeoVim into a full-fledged IDE with LSP support, linting, formatting,
autocompletion, AI-powered code suggestions, and more. It also includes some quality of life
improvements and additional features to make coding more enjoyable.

The configuration can be used as is and doesn't require any further setup (aside from
adding your API keys as env variables for AI providers).

> [!NOTE]
> Some Mason packages aren't avaliable on certain ARM processors. Watch out for
> errors and install them manually if needed.

> [!IMPORTANT]
> This is my personal configuration and is not intended to be used as a general-purpose
> neovim distro. Feel free to use it as a base for your own configuration, but be aware that
> my defaults and plugins may not suit your needs. I'm always open to suggestions and PRs,
> but I will not accept them if they don't fit my personal workflow.

## Installation

1. [Install NeoVim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
2. Install NvChad v2.5 dependencies (Git, Nerd Font, GCC, Make, Ripgrep)
3. Run the following commands to delete or move out of the way any old
   config files:

   ```sh
    # Backup if you want to keep the old config
    mv ~/.config/nvim{,.bak}
    mv ~/.local/share/nvim{,.bak}
    mv ~/.local/state/nvim{,.bak}

    # Delete if you don't want to keep the old config
    rm -rf ~/.config/nvim
    rm -rf ~/.local/state/nvim
    rm -rf ~/.local/share/nvim
   ```

4. Install the config by cloning this repository and moving the nvim config to the right place:

   ```sh
    # Clone this repo
    git clone https://github.com/v3ceban/.dotfiles.git v3ceban-dotfiles
    # Move the nvim config to the right place
    mv v3ceban-dotfiles/.config/nvim ~/.config/nvim
    # Remove the cloned repo if you don't need it anymore
    rm -rf v3ceban-dotfiles
   ```

5. ??????
6. PROFIT

## Currently Supported Languages

### HTML

- Uses [html-lsp](https://github.com/microsoft/vscode-html-languageservice) for LSP and linting
- Uses [prettier](https://prettier.io) for formatting
- Uses [emmet](https://github.com/olrtg/emmet-language-server) for LSP snippets

### CSS

- Uses [css-lsp](https://github.com/microsoft/vscode-css-languageservice) for LSP and linting
- Uses [prettier](https://prettier.io) for formatting
- Uses [tailwindcss-language-server](https://github.com/tailwindlabs/tailwindcss-intellisense) for Tailwind LSP
- Uses [rustywind](https://github.com/avencera/rustywind) for Tailwind classes organization

### JavaScript/TypeScript

- Uses [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) for LSP
- Uses [eslintd](https://github.com/mantoni/eslint_d.js/) for linting
- Uses [prettier](https://prettier.io) for formatting
- Requires eslint config to run linting server
  - Run `npm init` if not already done
  - Run `npm init @eslint/config@latest` in the root of the project
- Uses [prisma-language-server](https://github.com/prisma/language-tools) for LSP in Prisma files
<!-- - Uses [eslint-lsp](https://github.com/Microsoft/vscode-eslint) for linting -->

### JSON

- Uses [json-lsp](https://github.com/microsoft/vscode-json-languageservice) for LSP in JSON files
- Uses [fixjson](https://github.com/rhysd/fixjson) for formatting JSON files

### PHP

- Uses [intelephense](https://intelephense.com/) for LSP and linting
- Uses [php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer) for formatting
- Requires a git repo to run linting server
  - To create .git run `git init` in the root of the project

### Lua

- Uses [lua-language-server](https://github.com/LuaLS/lua-language-server) for LSP and linting
- Uses [stylua](https://github.com/JohnnyMorganz/StyLua) for formatting

### Bash

- Uses [bash-language-server](https://github.com/bash-lsp/bash-language-server) for LSP
- Uses [beautysh](https://github.com/lovesegfault/beautysh) for formatting

### C/C++

- Uses [clangd](https://clangd.llvm.org) for LSP and linting
- Uses [clang-format](https://pypi.org/project/clang-format/) for formatting

### Python

- Uses [python-lsp-server](https://github.com/python-lsp/python-lsp-server) for LSP and linting
- Uses [black](https://pypi.org/project/black/) and [isort](https://pycqa.github.io/isort/) for formatting

### Go

- Uses [gopls](https://pkg.go.dev/golang.org/x/tools/gopls) for LSP and linting
- Uses [gofumpt](https://pkg.go.dev/mvdan.cc/gofumpt), [goimports-reviser](https://github.com/incu6us/goimports-reviser), and [golines](https://github.com/segmentio/golines) for formatting

### Markdown

- Uses [Render Markdown](https://github.com/MeanderingProgrammer/render-markdown.nvim) for inline markdown rendering
- Uses [markdowny.nvim](https://github.com/antonk52/markdowny.nvim) for some markdown features in **Visual** mode
  - `<C-k>` to add a link
  - `<C-b>` to make text bold
  - `<C-i>` to make text italic
  - `<C-e>` to make text inline code or code block in **V-Line** mode

### Docker

- Uses [Dockerfile Language Server](https://github.com/rcjsuen/dockerfile-language-server-nodejs) for LSP in Dockerfiles
- Uses [Docker Compose Language Service](https://github.com/microsoft/compose-language-service) for LSP in Docker Compose files

## Extra Plugins/Features (not included in NvChad)

### Blink.cmp

Experimental completion engine integrated with NvChad

- Uses [blink.cmp](https://github.com/Saghen/blink.cmp) as an alternative to nvim-cmp
- Provides faster completion with better performance
- Configured alongside nvim-cmp for compatibility

### Abolish.vim

Plugin that helps with abbreviations and substitutions.

- Uses [Abolish.vim](https://github.com/tpope/vim-abolish) plugin
- Search/Replace trinity mappings:
  - `<leader>sw` - Search word under cursor or selection
  - `<leader>sr` - Search and replace word under cursor or selection
  - `<leader>ss` - Smart substitution with variations (Subvert)
- Smart substitution examples:
  - `:Subvert/child{,ren}/adult{,s}/g` turns `child` into `adult` and `children` into `adults`
  - `:Subvert/di{e,ce}/spinner{,s}/g` turns `die` into `spinner` and `dice` into `spinners`
- Can do much more, see `:h abolish` for usage info

### Claude Code

AI-powered development environment integration. Adding files or selections
requires a [Claude Code](https://github.com/anthropics/claude-code) instance running and configured to use with ide plugin.
Run `claude --ide` or use `/ide` command in claude code to connect and configure
ide connection. You, of course, need to be authenticated to use Claude Code
(you'll get prompted to login when first running `claude` CLI).

- Uses the [Claude Code](https://github.com/coder/claudecode.nvim) plugin for AI-assisted development
- Use `<leader>aa` to add files or selections to Claude
  - In normal mode: add current file
  - In visual mode: add selection
  - In file explorer (NvimTree, neo-tree, oil, etc.): add file/directory
- Use `<leader>ay` to accept Claude's suggested changes
- Use `<leader>an` to deny Claude's suggested changes
- Use `<leader>agc` to generate commit messages using Claude AI
  - This will open a separate claude instance in [headless mode](https://anthropic.mintlify.app/en/docs/claude-code/headless),
    stage all files in current working directory with `git add .` and generate
    a commit message, prompting you (y/N) twice to:
    1. Accept or deny it (you'll see commit message when prompted)
    2. Push to remote or leave it local
  - Claude Code will have access to the following bash commands:
    - `git log *`
    - `git status *`
    - `git diff *`

### Copilot

Enables Copilot autocompletion

- Uses the [Copilot](https://github.com/github/copilot.vim) plugin for autocompletion
- Run `:Copilot auth` to authenticate with GitHub
- Press `<M-l>` in insert mode to accept Copilot autocompletion suggestions
- Press `<M-j>` or `<M-k>` in insert mode to cycle through suggestions

### Flash.nvim

Navigation with search labels and treesitter

- Uses the [Flash.nvim](https://github.com/folke/flash.nvim) plugin
- Enabled in search mode by default
- Treesitter visual selection mapped to `v` in visual/operator-pending mode

### Git-conflict

Plugin that helps resolve git conflicts

- Uses [git-conflict](https://github.com/akinsho/git-conflict.nvim) plugin
- Navigate conflicts: `[c` (previous), `]c` (next)
- Resolve conflicts: `<leader>co` (ours), `<leader>ct` (theirs), `<leader>cb` (both), `<leader>cn` (none)
- See `:h git-conflict` for usage info

### Nvim-surround

Great plugin for surrounding text with brackets, quotes, and html tags

- Uses [Nvim-surround](https://github.com/kylechui/nvim-surround) plugin
- Default keybinds in visual mode changed from `S` to `s`
- See `:h nvim-surround` for usage info

### Nvim-ts-autotag

Automatically closes and renames HTML tags

- Uses [Nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) plugin

### Sort Motion.vim

Adds a sorting functionality using text objects and motions

- Uses [Sort Motion.vim](https://github.com/christoomey/vim-sort-motion) plugin
- Provides `gs` motion to sort lines or text objects
  - `gs` in visual mode to sort selection
  - `gsip` in normal mode to sort paragraph
  - `gsi{` to sort inside curly braces
  - etc...

### Vim-matchquote

Extends the built-in `%` command to match quotes and brackets

- Uses [vim-matchquote](https://github.com/airblade/vim-matchquote/tree/master) plugin
- Replaces the built-in `%` command
- Just works

### Which-key

Interactive keymap guide that helps discover available keybindings

- Uses [which-key.nvim](https://github.com/folke/which-key.nvim) plugin
- Shows available keybindings in a popup when you pause during typing
- Helps learn and remember complex keymaps

### Indent Blankline

Visual indentation guides for better code structure visibility

- Uses [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) plugin
- Shows indentation levels with subtle vertical lines
- Integrates with treesitter for better syntax awareness

## Useful Links

[Conform.nvim formatters](https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters)

[LSPconfig builtins](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)

[None-ls builtins](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md)

[Null-ls builtins](https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md)

[NvChad repository](https://github.com/NvChad/NvChad)

[Nvim-lint linters](https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters)
