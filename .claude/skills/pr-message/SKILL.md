---
name: pr-message
description: Write and apply a PR title and description for the current branch. Use when asked to write a pr message.
allowed-tools:
  - Read
  - Bash(git log:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git branch:*)
  - Bash(gh pr view:*)
  - Bash(gh pr diff:*)
  - Bash(gh pr list:*)
  - Bash(gh issue view:*)
  - Bash(gh repo view:*)
model: opus
effort: medium
argument-hint: ADDITIONAL_INSTRUCTIONS
---

## Context

- Current branch: !`git branch --show-current 2>&1 || true`
- Branch status: !`git status -sb 2>&1 || true`
- Default branch: !`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>&1 || true`
- Current PR: !`gh pr view --json number,url,title,body,isDraft,baseRefName,headRefName,closingIssuesReferences 2>&1 || true`
- PR comments: !`gh pr view --comments 2>&1 || true`
- PR commits: !`gh pr view --json commits --jq '.commits[].messageHeadline' 2>&1 || true`
- PR diff: !`gh pr diff 2>&1 || true`

If the above shows `no pull requests found`, there is no PR for this branch yet. Gather the same context locally instead: commits with `git log <base>..HEAD` and the diff with `git diff <base>...HEAD`, where `<base>` is the default branch (prefer `origin/<base>` if it exists).

## Instructions

Write a PR message for this feature branch. Start with the existing PR, if any: its current title, body, and comments may contain context, decisions, or reviewer requests that the message should reflect. Then read the commits and diff, and open the changed files where the diff alone does not explain the change.

Find related GitHub issues:

- Issues already linked to the PR via `closingIssuesReferences`.
- Issue references (`#123`, `owner/repo#123`, issue URLs) in the branch name, commit messages, PR body, and comments.

Read each one with `gh issue view <number>` to understand the motivation behind the change. Do not invent issue numbers; if none are found, omit the section.

Then write the PR message in Markdown:

- A concise title on the first line as plain text (not a header), following the repository's existing PR title convention if one is evident from `gh pr list --state merged --limit 10`.
- A description covering the background and motivation, what changed and why, any breaking changes with migration notes, and future implications or follow-up work.
- Links to related issues using closing keywords (`Closes #123`) only when the PR fully resolves the issue; otherwise reference it plainly (`Related to #123`).

Apply the title and description directly to the PR without printing them in your response. Pass the body through stdin with a quoted heredoc so Markdown and backticks are not interpreted by the shell:

```bash
gh pr edit --title "<title>" --body-file - <<'EOF'
<body>
EOF
```

- **PR exists:** update it with `gh pr edit` as above. Only **AFTER** the message is applied, if the PR is in draft mode, mark it ready for review with `gh pr ready`.
- **No PR yet:** create it with `gh pr create --base <default branch> --title "<title>" --body-file -` and the same heredoc, then report its URL. If the current branch is the default branch, or has no upstream, or is ahead of its upstream (see Branch status), do not create the PR; tell the user what to push first, and only then print the title and description in a single code block, since they can't be applied yet. If Branch status shows uncommitted changes, mention that they are not part of the PR.

Follow any additional instructions in `$ARGUMENTS`; they override the defaults above.

## Rules

1. **NEVER** use level 1 or level 2 headers in the PR description. The first header must be level 3 (`###`).
2. **NEVER** use emojis.
3. For checklists use `- [x]` and `- [ ]`. Never use any other characters or symbols for checkmarks.
4. **NEVER** add Claude, Claude Code, Anthropic, or any other AI tool as an author or co-author.
5. **ALWAYS** describe breaking changes if there are any.
6. **ALWAYS** include the background and future implications of the PR.
7. **NEVER** describe changes that are not in the diff, and do not restate the diff file by file. Explain the intent and impact.
