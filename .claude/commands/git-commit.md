---
description: Generate Commit Message
model: haiku
allowed-tools:
  - Read
  - Bash(git log:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME log:*)
  - Bash(/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status:*)
  - Bash(/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME diff:*)
---

## Context

- Current git status: `git status`
- Current git diff: `git diff --staged`
- Recent commits (10): `git log -10 --oneline`

## Instructions

Use allowed `Bash` tool and `git` command to get the information about all staged changes. After you access the changes, analyze them and write a short, but comprehensive commit message, that follows commitizen convention. It needs to look like this:

```gitcommit
feat(commit): title of the commit message

Commit message body that explains the changes...
```

After you generate the commit message, use it to commit the changes to the repository with `git commit -m "<commit message>"` and push to remote with `git push`.

## Rules

1. **ALWAYS** respond with the exact commit message wrapped in a code block
2. **ALWAYS** Keep the title under 50 characters and wrap message at 72 characters
3. **ALWAYS** follow commitizen convention
4. **NEVER** use emojis
5. **NEVER** add Claude, Claude Code, Anthropic, or any other AI tool, agent, or company as an author or a co-author of the commit or commit message
6. **ALWAYS** mention breaking changes in the commit message if there are any by adding `BREAKING CHANGE:` section to the commit message body
7. If a project is using a different `git` command or an alias for it, **ALWAYS** use that command or alias instead of `git`. However, if the project is not using any different `git` command or alias, **ALWAYS** use `git` commands.
