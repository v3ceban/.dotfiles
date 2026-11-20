---
name: "pr-message"
description: "Write and apply a PR title and description for the current branch. Use when asked to write a pr message."
allowed-tools:
  - "Read"
  - "Bash(git log:*)"
  - "Bash(git status:*)"
  - "Bash(git diff:*)"
  - "Bash(git branch:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh pr diff:*)"
  - "Bash(gh pr list:*)"
  - "Bash(gh issue view:*)"
  - "Bash(gh repo view:*)"
model: "opus"
effort: "medium"
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

Read each one with `gh issue view <number>` to understand the motivation behind the change. Do not invent issue numbers.

Then write the PR message in Markdown, the way one teammate writes to another:

- **Title:** plain text on the first line, not a header. Short, and about what changes for the reader, not how. Follow the repository's PR title convention if `gh pr list --state merged --limit 10` shows one.
- **Description:** open with the problem in a sentence or two, then say what the PR does about it in a sentence or two. Most PRs need nothing more. Add only what a reviewer needs and can't get from the diff: a breaking change and how to migrate, a decision they would otherwise question, or how to test it when that isn't obvious. Use a short list only when the PR does several separate things, and headers only when the description has sections that need them.
- **Issues:** link them with closing keywords (`Closes #123`) only when the PR fully resolves them. Otherwise reference them plainly (`Related to #123`). Link each piece of work once. A GitHub issue that mirrors a ticket in another tracker, which its body or title usually shows, is the same work, so link the tracker's ticket and leave the GitHub issue out. Use the GitHub issue only when no other tracker has the work.

Apply the title and description directly to the PR without printing them in your response. Pass the body through stdin with a quoted heredoc so Markdown and backticks are not interpreted by the shell:

```bash
gh pr edit --title "<title>" --body-file - <<'EOF'
<body>
EOF
```

- **PR exists:** update it with `gh pr edit` as above. Only **AFTER** the message is applied, if the PR is in draft mode, mark it ready for review with `gh pr ready`.
- **No PR yet:** create it with `gh pr create --base <default branch> --title "<title>" --body-file -` and the same heredoc, then print only its URL. If the current branch is the default branch, or has no upstream, or is ahead of its upstream (see Branch status), do not create the PR; tell the user what to push first, and only then print the title and description in a single code block, since they can't be applied yet. If Branch status shows uncommitted changes, mention that they are not part of the PR.

Follow any additional instructions in `$ARGUMENTS`; they override the defaults above.

## Rules

1. **NEVER** pad the description. No `Background`, `Changes`, `Summary`, or `Follow-up` scaffolding, no future work unless the PR leaves something a reviewer must know, no filler, no hedging. Cut every sentence that doesn't help a reviewer.
2. **NEVER** describe changes that are not in the diff, and never restate the diff or walk through it file by file.
3. **ALWAYS** describe breaking changes.
4. Headers, when used, start at level 3 (`###`).
5. For checklists use `- [x]` and `- [ ]`. Never use any other characters or symbols for checkmarks.
6. **NEVER** use emojis.
7. **NEVER** add Claude, Claude Code, Anthropic, or any other AI tool as an author or co-author.
8. **NEVER** print the title, the description, or a summary of what you did once it is applied. Print nothing, or only the URL of a PR you created.
