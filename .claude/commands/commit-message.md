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
