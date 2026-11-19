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
  - "Bash(~/.claude/skills/ship/scripts/threads:*)"
---

## Silence

Ask everything you need before step 3, in as few `AskUserQuestion` calls as you can, and only when the answer changes the result. After that, ask nothing and write no text at all until the final output: no status updates, plans, step announcements, or explanations, not even a one-line note before a tool call such as "rerunning the flaky job", "old PRs are closed, creating a new one", or "only a question remains, marking ready". Every message before the final output contains only tool calls. This overrides any output instructions in the skills you invoke, such as `/commit` and `/pr-message`.

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
- **Bare `/ship`**: ship what is on the current branch, committed or not, picking up its PR if one exists. Keep the behavior already on the branch. The standards change how it is written, not what it does, unless the review finds a bug. Its open comments are handled like any others, per step 7.

## Standards

Every change follows [standards.md](references/standards.md). Read it before writing code. It overrides suggestions from reviewers, review skills, and bots.

## Project tooling

Before you reach for plain git or `gh`, look for the project's own tooling for the same job: branching, worktrees, stacking and restacking, env setup, checks, and PRs. Look in package scripts, Makefile or justfile targets, `tooling/` or `scripts/` directories, and what `CLAUDE.md`, `AGENTS.md`, or `CONTRIBUTING.md` say. Where it exists, use it. Fall back to [stacking.md](references/stacking.md) and plain commands only for what it doesn't cover. Never use project tooling to write to trackers.

## Steps

1. **Resolve the work.** Fetch the ticket with whatever is available, in this order: `gh` for GitHub, a connected MCP server for the tracker (look it up with `ToolSearch`), the tracker's CLI if it is installed, then `WebFetch`. Read its description, comments, and linked docs. If nothing can read it, ask for its contents. Never change the ticket.
2. **Branch.** With a ticket or a task, start from the up-to-date default branch unless the current branch is already that work. Create it with `--no-track` so it never tracks the default branch. Name the branch with the tracker's suggested branch name if it gives one. Otherwise, follow the naming in Recent remote branches and include the ticket key. Decide between one PR and a stack per [stacking.md](references/stacking.md), and prefer a stack when the work splits cleanly. For a bare `/ship` on a branch stacked on another, find its parent the same way.
3. **Implement** the smallest change that does the job.
4. **Verify.** Find the checks the project runs: CI workflows first, then package scripts, Makefiles, and `CLAUDE.md`, `AGENTS.md`, or `CONTRIBUTING.md`. Run the fast ones locally: format, lint, typecheck, and the tests that cover the change. Leave slow suites to CI. Prove the behavior. Reproduce a bug before and after the fix. For UI or runtime behavior, run the app with `/run`.
5. **Review loop.** In one message, start three `general-purpose` agents. Each invokes one skill and only reports, without editing files, committing, or pushing:
   - `/code-review high`
   - `/simplify`, reporting the changes it would make instead of applying them
   - `/security-review`

   While they run, read the full branch diff against the standards yourself. Then apply the findings that are real and that the standards agree with, and drop the rest. Repeat step 4. Run another round when this one changed more than trivial code, up to three rounds.
6. **Commit and open a draft PR.** Use `/commit`, then `/pr-message` with these instructions: create the PR as a draft, keep it in draft, keep the description short, and, for a tracker key that GitHub doesn't know, add a `Closes <KEY>` line when the PR fully resolves it. For a stack, each PR's base is the branch below it.
7. **Get CI green.** Wait for each PR in the foreground with the Bash tool, never in the background and never with `Monitor`, so the turn doesn't end while you wait. Run `~/.claude/skills/ship/scripts/watch-pr <pr-url>` with a `timeout` of 600000. It prints a line for each finished check and each new comment or review from someone else, then exits with a last line of `done` (all checks finished), `act` (a failed check or a comment to handle), `pending` (still running, so run it again), or `no-checks`.
   - **Failed check:** read its logs with `gh run view --log-failed`. If the change broke it, fix it. If it was broken before but you can fix it, fix it. If it looks flaky or infrastructural, rerun the failed jobs once with `gh run rerun <run-id> --failed`. If it fails for a reason you can't fix, such as missing secrets, permissions, or an outage, stop here.
   - **Comments:** treat every comment the same, whoever wrote it, person or bot. List the unresolved review threads with `~/.claude/skills/ship/scripts/threads <pr-url>`, and read new top-level comments and reviews from the PR.
     - A finding or request that is right and that the standards agree with: fix it.
     - One that isn't: reply with one short sentence saying why, in plain terms and without mentioning the standards or this skill. On a thread, use `gh api repos/<owner>/<repo>/pulls/<number>/comments/<reply_to>/replies -f body='<reason>'`. Otherwise, use `gh pr comment <pr-url> --body '<reason>'`, quoting what you are answering.
     - Once the fix is pushed or the reason is posted, resolve the thread with `gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "<thread>"}) { thread { isResolved } } }'`.
     - Leave questions and discussion for the user, unresolved. Comments that ask for nothing, such as deploy previews, coverage reports, and summaries, need no action.
     - Write and resolve only with `gh`, so it all comes from the user's account, never through an MCP server or an app.
   - **Each fix:** prove it per step 4, fold it into the commit it belongs to with a fixup and autosquash, and push with `--force-with-lease`. Then run `watch-pr` again.
   - **When it prints `done`:** handle any failed checks above, then check the comments once more, since bot reviews often arrive late.
8. **Mark ready.** If the description no longer matches the final diff, refresh it with `/pr-message`. Then run `gh pr ready`, and add the reviewers from the instructions, if any, with `gh pr edit --add-reviewer`. For a stack, do this for every PR.

## Output

Print only the PR URL, one per line for a stack. Nothing else: no summary of the changes, the checks, or the decisions. If you stopped early, print one sentence saying why, then the PR URL, and nothing else. Leave that PR in draft.

## Rules

1. **NEVER** merge, approve, or close a PR.
2. **NEVER** comment on PRs or tickets, except the replies to comments you decline in step 7, and never change ticket fields or statuses.
3. **NEVER** bypass hooks or branch protection.
4. **NEVER** force-push a branch that this run isn't shipping.
5. **NEVER** write text between step 3 and the final output. Messages in that span contain only tool calls.
6. **NEVER** print anything after the work but the output described in Output: no summary, notes, or explanations.
