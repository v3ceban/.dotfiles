---
description: Generate Commit Message
argument-hint: "[single|multiple] ADDITIONAL_INSTRUCTIONS"
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
- Current git diff: `git diff`
- Recent commits (10): `git log -10 --oneline`

## Arguments

`$ARGUMENTS` may start with a commit mode, followed by optional additional instructions:

- `single`: commit all changes as one atomic commit.
- `multiple`: split the changes into several atomic commits.
- No mode: decide the mode yourself based on the scope of the changes (see Commit Mode).

Everything after the mode, or all of `$ARGUMENTS` when no mode is given, is additional instructions that you must follow.

## Instructions

Use allowed `Bash` tool and `git` commands to get the information about all current changes, including untracked files. Analyze them and decide the commit mode unless it was passed explicitly. Then, for each commit: stage exactly the changes that belong to it, write a short, but comprehensive commit message that follows the Message Format below, and commit with `git commit -m "<commit message>"`.

After the last commit, push to remote with `git push`.

## Commit Mode

Prefer a single commit. Split only when the diff contains independent logical changes that a reviewer would want to read, revert, or cherry-pick separately. Signs that a split is warranted:

- Changes that need different conventional types or scopes, such as a `feat` alongside an unrelated `fix`, or a `refactor` alongside `docs`.
- Changes to unrelated parts of the codebase that do not depend on each other.
- Mechanical changes (formatting, renames, moves, generated files, dependency bumps) mixed with behavioral changes.

Do not split by file, package, or diff size for its own sake. A single feature that touches many files is still one commit. Never split a change so that an intermediate commit is broken, for example one that fails to build or references code introduced in a later commit.

When making multiple commits:

- Stage each commit's changes by path with `git add <paths>`. If a file mixes hunks that belong to different commits, stage only the relevant hunks by piping a patch with those hunks into `git apply --cached`. If a clean split is not feasible, fall back to a single commit and say why.
- Order the commits so each one builds on the previous: mechanical and preparatory changes first, behavioral changes after.
- Before each commit, verify with `git diff --cached --stat` that exactly the intended changes are staged.

## Message Format

Messages follow the [Conventional Commits](https://www.conventionalcommits.org) spec, matching commitlint's `config-conventional` ruleset:

```gitcommit
type(scope): imperative summary of the change

Body that explains the motivation and consequences of the change,
not a restatement of the diff.

BREAKING CHANGE: description of what breaks and how to migrate
```

- `type` is one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`. `feature` is not a legal alias for `feat`.
- `scope` is the package, module, or area touched. Omit it for cross-cutting changes. If the project has an established scope vocabulary in its history, reuse it.
- The summary is in imperative mood, lower case, with no trailing period.
- The body explains why the change was made and what it implies, not which files changed.
- A breaking change gets a `BREAKING CHANGE:` footer and, optionally, a `!` after the type or scope (`feat(api)!: ...`).

## Rules

1. **ALWAYS** respond with the exact commit message wrapped in a code block, one block per commit
2. **ALWAYS** keep the header (type, scope, and summary) at 50 characters or less and wrap body lines at 72 characters
3. **ALWAYS** follow the Message Format above
4. **NEVER** use emojis
5. **NEVER** add Claude, Claude Code, Anthropic, or any other AI tool, agent, or company as an author or a co-author of the commit or commit message
6. **ALWAYS** mention breaking changes in the commit message if there are any by adding `BREAKING CHANGE:` section to the commit message body
7. **NEVER** bypass git hooks with `--no-verify`. If a hook rejects a commit, fix the cause and retry.
8. If a project is using a different `git` command or an alias for it such as `dotfiles` or is in a scope of such alias, **ALWAYS** use that command or alias instead of `git`.
