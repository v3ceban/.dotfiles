---
description: Generate Commit Message
agent: commiter
---

## Context

**Current git status:**
!`git status`

**Current git diff:**
!`git diff --staged`

**Recent commits (10):**
!`git log -10 --oneline`

## Instructions

Analyze staged changes and write a short, but comprehensive commit message, that follows commitizen convention. It needs to look like this:

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
5. **NEVER** add OpenCode, Copilot, OpenAI, ChatGPT, Claude, Claude Code, Anthropic, or any other AI tool, agent, or company as an author or a co-author of the commit or commit message
6. **ALWAYS** mention breaking changes in the commit message if there are any by adding `BREAKING CHANGE:` section to the commit message body
