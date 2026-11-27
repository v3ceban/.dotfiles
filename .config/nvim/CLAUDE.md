# CLAUDE.md

Guidance for working in this repository: a personal Neovim config built on NvChad v2.5. Features, plugins, and keybindings are documented in `README.md`.

## Git

This directory is part of a bare dotfiles repository with `$HOME` as the work tree. Never use plain `git`; use:

```sh
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME
```

- Use paths relative to the current directory (`lua/plugins.lua`, not `.config/nvim/lua/plugins.lua`). `$HOME`-relative paths double up and fail.
- Only add files that are already tracked. `lazy-lock.json` is gitignored on purpose.
- The shell is zsh, which does not word-split a command stored in a plain variable. Type the command out or use an array.

## Making changes

- Change only what the task needs and keep the existing code shape. Do not add comments, extract helper functions, deduplicate neighbouring code, or refactor unless asked. If a fix needs a new function, explain why in the reply, not in a code comment.
- Format Lua with `~/.local/share/nvim/mason/bin/stylua --check lua/` (settings in `.stylua.toml`).
- When a change alters something `README.md` documents, update it there and keep it concise.
- New Mason tools must also be added to `mason.pkgs` in `lua/chadrc.lua`.

## Non-obvious conventions

- `lua/configs/*.lua` files are `require`d from `lua/plugins.lua` while specs are parsed. They must return an opts table or function and must not `require` the plugin at top level, or the plugin loads eagerly.
- Map visual-mode keys with `"x"`, not `"v"`. `"v"` also covers select mode, where a printable key should replace a snippet placeholder. Control and alt keys that should still work there (`<C-z>`, `<M-S-hjkl>`) stay `"v"`.
- `lua/mappings.lua` runs in `vim.schedule` after startup, on top of `nvchad.mappings`. `vim.keymap.del` throws if the mapping does not exist.
- This is Neovim 0.12 with nvim-treesitter on its `main` branch, so legacy treesitter APIs are gone. Check the installed plugin source under `~/.local/share/nvim/lazy/` and `:checkhealth <plugin>` instead of assuming an API.
- NvChad's blink spec disables nvim-cmp. `lua/configs/cmp.lua` and its spec are kept on purpose.

## Verifying

- Test against the real config headlessly, always with a timeout because a prompt will hang it: `timeout 20 nvim --headless -n -i NONE -c "luafile probe.lua"`.
- Inspect state from `vim.defer_fn` (about 1s), since mappings are scheduled. Set `vim.g.ui_entered = true` before `:edit` so NvChad's file-based lazy loading fires.
- To exercise a mapping, feed keys with mode `"m"` and check the result in a later `vim.defer_fn`.
- Keep probe scripts and test files outside the repository in `/tmp` directory.
