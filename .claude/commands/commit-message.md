# Generate a commit message

## Taks

Write a commit message for the changes in the project.

### Details, Context, and Instructions

Use `git add .` command to stage all changed files. Then use `git` command to get the
information about all staged changes. After you access the changes, analyze them and
write a short, but comprehensive commit message, that follows commitizen convention.
When you create the message, commit the staged changes with `git commit -m "COMMIT_MESSAGE"`
command, where `COMMIT_MESSAGE` is the message you generated. When changes are commited,
push them to remote with `git push` command.

### Rules

1. ALWAYS Keep the title under 50 characters and wrap message at 72 characters
2. ALWAYS follow commitizen convention
3. NEVER use emojies
4. NEVER add Claude or Claude Code as an author or a co-author of the commit or commit message
