# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Neovim configuration built on NvChad v2.5 framework, transforming Neovim into a full-featured IDE with LSP support, AI integration, and productivity enhancements.

## Configuration Architecture

**Loading Chain**: `init.lua` → Lazy.nvim bootstrap → NvChad v2.5 → custom plugins → configurations → mappings

**Core Structure**:
- `init.lua` - Entry point, bootstraps Lazy.nvim and loads NvChad base
- `lua/plugins.lua` - Custom plugin specifications with lazy loading configs
- `lua/chadrc.lua` - NvChad UI theme and dashboard configuration (Catppuccin theme, custom nvdash)
- `lua/options.lua` - Editor settings, autocommands, and highlight group customizations
- `lua/mappings.lua` - Extended keybindings on top of NvChad defaults
- `lua/configs/` - Individual plugin configurations

## Language Ecosystem

**LSP Configuration** (`lua/configs/lspconfig.lua`):
- Standard servers: bashls, dockerls, html, jsonls, prismals, docker_compose_language_service
- Special configurations:
  - `clangd` - UTF-16 offset encoding for C/C++
  - `ts_ls` - TypeScript with disabled suggestions (relies on other tools)
  - `intelephense` - PHP with custom global storage path
  - `gopls` - Go with complete unimported, placeholders, unused params analysis
  - `pylsp` - Python with increased mccabe threshold, E501/W503 ignore, 120 char line length
  - `tailwindcss` - Extensive filetype support including templating languages
  - `emmet_language_server` - HTML/CSS snippets for multiple template types

**Formatting** (`lua/configs/conform.lua`):
- Multi-tool chains: `rustywind` + `prettierd` for Tailwind + Prettier formatting
- Language-specific: `stylua` (Lua), `black`+`isort` (Python), `gofumpt`+`goimports-reviser`+`golines` (Go)
- Format-on-save enabled with 2.5s timeout, LSP fallback

**Linting** (`lua/configs/lint.lua`):
- Dynamic ESLint configuration detection with directory caching
- Searches for ESLint configs in current/parent directories (supports both legacy and flat config formats)
- Caches config directory paths to avoid repeated filesystem traversal
- Auto-triggers on `BufEnter`, `BufWritePost`, `CursorHold`

## Development Commands

**Plugin Management**:
- `:Lazy` - Main plugin manager interface
- `:Lazy update` - Update all plugins and regenerate lockfile
- `:Lazy reload {plugin}` - Reload specific plugin without restart
- `:Lazy profile` - Check plugin loading performance

**Health Checks**:
- `:checkhealth` - General Neovim health diagnostics
- `:checkhealth lspconfig` - LSP server status
- `:checkhealth mason` - Mason tool installation status

**Configuration Testing**:
- Restart Neovim completely to test major changes
- Use `:source %` for immediate Lua configuration reloading
- `:messages` to view startup errors

**Installation & Dependencies**:
- Requires NeoVim with NvChad v2.5 dependencies (Git, Nerd Font, GCC, Make, Ripgrep)
- Mason packages may need manual installation on ARM processors
- JavaScript/TypeScript projects need ESLint config: `npm init @eslint/config@latest`
- PHP projects require git repository initialization for LSP: `git init`

## AI Integration Workflow

**GitHub Copilot**:
- Authentication: `:Copilot auth`
- Insert mode: `<M-l>` accept, `<M-j>`/`<M-k>` cycle suggestions
- Configured with `g:copilot_no_tab_map = true` to prevent Tab conflicts

**Claude Code Integration**:
- `<M-a>` - Toggle Claude Code window
- `<leader>ac` - Focus Claude Code window
- `<leader>af` - Add file (normal mode) or selection (visual mode) to Claude Code context
- `<leader>aa` - Accept Claude Code suggested diffs
- `<leader>ad` - Deny Claude Code suggested diffs
- `<leader>agc` - Auto git-add and AI-generated commit message (uses opencode CLI with GPT-4)
- Terminal: Right-side split (35% width) with Snacks.nvim provider, floating interface

## Key Customizations

**Keybinding Patterns**:
- Search/Replace trinity: `<leader>sw` (search), `<leader>sr` (replace), `<leader>ss` (subvert with Abolish)
- Git navigation: `[h]`/`]h` (hunks), `[c]`/`]c` (conflicts), `[d]`/`]d` (diagnostics)
- Buffer management: `<leader>x` (close with count support), number+`<Tab>` (go to buffer N)

**Visual Enhancements**:
- Global statusline (`laststatus=3`)
- Relative line numbers with Treesitter folding
- Rounded borders for LSP floats and diagnostics
- Custom highlight groups for Markdown rendering and Git conflicts

**Auto-commands**:
- `.env*` files → bash filetype for syntax highlighting
- `docker-compose*.y{a,}ml` → `yaml.docker-compose` filetype for specialized LSP
- LSP signature parameter highlighting on attach
- Quickfix window auto-close behaviors (`<CR>`, `q`, `<Esc>`, `d` to delete entry)
- Auto file reload on external changes

## Plugin Ecosystem

**Core Extensions**:
- `vim-abolish` - Advanced search/replace with word variations (`<leader>ss`)
- `flash.nvim` - Enhanced navigation with search labels and treesitter (`v` for visual selection)
- `git-conflict.nvim` - Conflict resolution with `[c]`/`]c` navigation and `<leader>gc*` actions
- `nvim-surround` - Text surrounding operations (`cs`, `ds`, `ys`, visual `s`)
- `vim-sort-motion` - Sorting functionality (`gs` motion)
- `nvim-ts-autotag` - Auto HTML tag closing/renaming
- `indent-blankline.nvim` - Visual indentation guides
- `render-markdown.nvim` + `markdowny.nvim` - Enhanced markdown editing
