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
3. NEVER use emojis
4. NEVER add Claude, Claude Code, Openai, Codex, Opencode, or any other AI tool or
   agent as an author or a co-author of the commit or commit message
5. ALWAYS mention breaking changes in the commit message if there are any by
   adding `BREAKING CHANGE:` section to the commit message body
6. NEVER respond with anything other than the commit message and the commands you
   used to create it
