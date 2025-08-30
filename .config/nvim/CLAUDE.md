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
- Standard servers: bashls, docker_compose_language_service, dockerls, html, jsonls, prismals
- Special configurations:
  - `clangd` - UTF-16 offset encoding for C/C++
  - `ts_ls` - TypeScript with disabled suggestions (relies on other tools)
  - `intelephense` - PHP with custom global storage path and telemetry disabled
  - `gopls` - Go with complete unimported, placeholders, unused params analysis
  - `pylsp` - Python with mccabe threshold 50, E501/W503 ignore, 120 char line length
  - `cssls` - CSS with unknown at-rules ignored
  - `tailwindcss` - Extensive filetype support including templating languages (40+ filetypes)
  - `emmet_language_server` - HTML/CSS snippets for templating languages

**Formatting** (`lua/configs/conform.lua`):
- Multi-tool chains: `rustywind` + `prettier` for Tailwind + Prettier formatting
- Language-specific: 
  - `stylua` (Lua)
  - `black` + `isort` (Python) with fast mode
  - `gofumpt` + `goimports-reviser` + `golines` (Go) with unused imports removal
  - `clang-format` (C/C++/Java/Proto/CUDA/C#)
  - `beautysh` (Shell scripts) with 2-space indent
  - `fixjson` (JSON), `prettier` (JSON5/YAML/Markdown/GraphQL)
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

**OpenCode Integration**:
- `<M-a>` - Toggle opencode terminal window
- `<leader>aA` - Ask opencode a question
- `<leader>aa` - Ask about current line (normal) or selection (visual)
- `<leader>ar` - Run predefined prompts (explain, fix, optimize, document, test, review)
- `<leader>an` - Start new opencode session
- `<leader>agc` - Auto git-add and AI-generated commit message
- `<leader>agd` - Generate documentation comments
- Terminal: Right-side split with window navigation (`<C-h>`, `<C-l>`), scroll (`<M-j>`, `<M-k>`)

## Key Customizations

**Keybinding Patterns**:
- Search/Replace trinity: `<leader>sw` (search), `<leader>sr` (replace), `<leader>ss` (subvert with Abolish)
- Git navigation: `[h]`/`]h` (hunks), `[c]`/`]c` (conflicts), `[d]`/`]d` (diagnostics)
- Buffer management: `<leader>x` (close with count support), `<Tab>`/`<S-Tab>` (next/prev), number+`<Tab>` (go to buffer N)
- Visual selection movement: `J`/`K` (move selection up/down), `>`/`<` (indent with re-selection)
- Window resizing: `<C-Up>`/`<C-Down>` (height), `<C-Left>`/`<C-Right>` (width)
- Universal save/quit: `<C-s>` (save all), `<C-q>` (quit all), `<C-z>` disabled

**Visual Enhancements**:
- Global statusline (`laststatus=3`)
- Relative line numbers with Treesitter folding
- Rounded borders for LSP floats and diagnostics
- Custom highlight groups for Markdown rendering and Git conflicts

**Auto-commands**:
- `.env*` files → bash filetype, `~/.ssh/hosts` → sshconfig filetype
- `docker-compose*.y{a,}ml` → `yaml.docker-compose` filetype for specialized LSP
- LSP signature parameter highlighting on attach (bold + italic)
- Quickfix window behaviors: `<CR>` (open and close), `q`/`<Esc>` (close), `o` (open only), `d` (delete entry)
- Auto file reload on external changes (`autoread` + multiple triggers)
- ESLint config cache clearing on directory change

## Plugin Ecosystem

**Core Extensions**:
- `vim-abolish` - Search/replace trinity (`<leader>sw`/`sr`/`ss`) with smart word variations
- `blink.cmp` - Experimental fast completion engine (alongside nvim-cmp)
- `flash.nvim` - Enhanced navigation with treesitter visual selection (`v`)
- `git-conflict.nvim` - Conflict resolution (`[c]`/`]c` navigation, `<leader>c*` actions)
- `nvim-surround` - Text surrounding operations (`cs`, `ds`, `ys`, visual `s`)
- `vim-sort-motion` - Sorting functionality (`gs` motion)
- `nvim-ts-autotag` - Auto HTML tag closing/renaming
- `indent-blankline.nvim` - Visual indentation guides
- `render-markdown.nvim` + `markdowny.nvim` - Enhanced markdown editing
- `which-key.nvim` - Interactive keymap guide
- `vim-matchquote` - Enhanced `%` command for quotes/brackets
- `opencode.nvim` - AI integration with GPT models
