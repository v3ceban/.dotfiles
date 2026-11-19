---
name: "ship"
description: "Take a ticket, a task, or the current branch to a ready-for-review PR with green CI, without supervision. Use when asked to ship."
disable-model-invocation: true
argument-hint: "[ticket]"
allowed-tools:
  - "Read"
  - "Edit"
  - "Write"
  - "Skill(commit)"
  - "Skill(pr-message)"
  - "Skill(code-review)"
  - "Skill(simplify)"
  - "Skill(security-review)"
  - "Skill(run)"
  - "Bash(git:*)"
  - "Bash(gh:*)"
  - "Bash(~/.claude/skills/ship/scripts/watch-pr:*)"
---

## Context

- Current branch: !`git branch --show-current 2>&1 || true`
- Status: !`git status -sb 2>&1 || true`
- Default branch: !`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name 2>&1 || true`
- PR for this branch: !`gh pr view --json number,url,state,isDraft,baseRefName 2>&1 || true`
- Recent remote branches: !`git branch -r --sort=-committerdate --format='%(refname:short)' 2>&1 | head -10`

## Arguments

`$ARGUMENTS` is `[ticket] [instructions]`:

- **Ticket**: the first word when it is a URL, `#123`, `owner/repo#123`, or a tracker key such as `ABC-123`.
- **Instructions**: everything else. With no ticket, the instructions are the task. They may also name reviewers or narrow the work.
- **Bare `/ship`**: ship what is on the current branch, picking up its PR if one exists. Unresolved review threads on that PR are input: make the changes they ask for when you agree with them, and leave questions and disagreements alone.

## Standards

Every change follows [standards.md](references/standards.md). Read it before writing code. It overrides suggestions from reviewers, review skills, and bots.

## Project tooling

Before you reach for plain git or `gh`, look for the project's own tooling for the same job: branching, worktrees, stacking and restacking, env setup, checks, and PRs. Look in package scripts, Makefile or justfile targets, `tooling/` or `scripts/` directories, and what `CLAUDE.md`, `AGENTS.md`, or `CONTRIBUTING.md` say. Where it exists, use it. Fall back to [stacking.md](references/stacking.md) and plain commands only for what it doesn't cover. Never use project tooling to write to trackers.

## Silence

Ask everything you need before step 3. After that, don't ask questions or print progress until the final output. Batch the questions into as few `AskUserQuestion` calls as you can, and ask only when the answer changes the result.

## Steps

1. **Resolve the work.** Fetch the ticket with whatever is available, in this order: `gh` for GitHub, a connected MCP server for the tracker (look it up with `ToolSearch`), the tracker's CLI if it is installed, then `WebFetch`. Read its description, comments, and linked docs. If nothing can read it, ask for its contents. Never change the ticket.
2. **Branch.** With a ticket or a task, start from the up-to-date default branch unless the current branch is already that work. Name the branch with the tracker's suggested branch name if it gives one. Otherwise, follow the naming in Recent remote branches and include the ticket key. Decide between one PR and a stack per [stacking.md](references/stacking.md), and prefer a stack when the work splits cleanly. For a bare `/ship` on a branch stacked on another, find its parent the same way.
3. **Implement** the smallest change that does the job.
4. **Verify.** Find the checks the project runs: CI workflows first, then package scripts, Makefiles, and `CLAUDE.md`, `AGENTS.md`, or `CONTRIBUTING.md`. Run the fast ones locally: format, lint, typecheck, and the tests that cover the change. Leave slow suites to CI. Prove the behavior. Reproduce a bug before and after the fix. For UI or runtime behavior, run the app with `/run`.
5. **Review loop.** In one message, start three `general-purpose` agents. Each invokes one skill and only reports, without editing files, committing, or pushing:
   - `/code-review high`
   - `/simplify`, reporting the changes it would make instead of applying them
   - `/security-review`

   While they run, read the full branch diff against the standards yourself. Then apply the findings that are real and that the standards agree with, and drop the rest. Repeat step 4. Run another round when this one changed more than trivial code, up to three rounds.
6. **Commit and open a draft PR.** Use `/commit`, then `/pr-message` with these instructions: create the PR as a draft, keep it in draft, keep the description short, and, for a tracker key that GitHub doesn't know, add a `Closes <KEY>` line when the PR fully resolves it. For a stack, each PR's base is the branch below it.
7. **Get CI green.** For each PR, watch it with the `Monitor` tool running `~/.claude/skills/ship/scripts/watch-pr <pr-url>`, with `timeout_ms` set to 1800000. Re-arm it when it expires before printing `done` or `no-checks`. It prints a line for each finished check and each new bot comment or review.
   - **Failed check:** read its logs with `gh run view --log-failed`. If the change broke it, fix it. If it was broken before but you can fix it, fix it. If it looks flaky or infrastructural, rerun the failed jobs once with `gh run rerun <run-id> --failed`. If it fails for a reason you can't fix, such as missing secrets, permissions, or an outage, stop here.
   - **Bot finding:** fix it when it is real and the standards agree. Otherwise ignore it. Never reply to bots or resolve their threads.
   - **Each fix:** prove it per step 4, fold it into the commit it belongs to with a fixup and autosquash, and push with `--force-with-lease`. Then keep watching.
   - **When the watch prints `done`:** check the bot comments and reviews once more, since some arrive late.
8. **Mark ready.** Run `/pr-message` with the reviewers from the instructions, if any. It refreshes the description to the final state and marks the draft ready. For a stack, do this for every PR.

## Output

Print only the PR URL, one per line for a stack. If you stopped early, print one line saying why, followed by the PR URL. Leave that PR in draft.

## Rules

1. **NEVER** merge, approve, or close a PR.
2. **NEVER** comment on or reply in PRs or tickets, and never change ticket fields or statuses.
3. **NEVER** bypass hooks or branch protection.
4. **NEVER** force-push a branch that this run isn't shipping.
