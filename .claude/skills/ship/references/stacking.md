# Stacked PRs with plain git

A stack is a chain of branches, each based on the one below it, with one PR per branch whose base is the branch below.

## When to stack

Prefer a stack over one large PR when the work splits into units that each make sense, build, and pass CI on their own. Typical splits: mechanical changes (renames, moves, dependency bumps) before behavior, a refactor before the feature that needs it, backend before the UI that uses it. Don't split a unit that only works with the next one.

## Build

Build bottom-up. Finish each unit, including verification and the review loop, on its own branch before branching the next one from it:

```bash
git switch -c <unit-2-branch> <unit-1-branch>
```

A later fix that belongs to a lower unit goes into that unit's commit as a fixup, then the whole stack is rebased with the refs updated, from the top branch:

```bash
git commit --fixup=<sha-in-lower-unit>
GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash --update-refs <default-branch>
git push --force-with-lease origin <every-branch-in-the-stack>
```

## PRs

Each PR's base is the branch directly below it. The bottom PR's base is the default branch.

## Find the parent of an existing branch

The parent is the nearest branch with an open PR whose tip is an ancestor of `HEAD`:

```bash
current=$(git branch --show-current)
gh pr list --author @me --state open --json headRefName --jq '.[].headRefName' | while read -r b; do
  [ "$b" = "$current" ] && continue
  git merge-base --is-ancestor "origin/$b" HEAD 2>/dev/null && echo "$(git rev-list --count "origin/$b..HEAD") $b"
done | sort -n | head -1 | cut -d' ' -f2
```

No output means the parent is the default branch.

## Restack

After a lower branch changes, rebase from the top branch with `--update-refs` onto the bottom branch's base and force-push every branch with `--force-with-lease`.

After a lower PR is squash-merged, replay only the child's own commits onto the default branch and retarget its PR:

```bash
git rebase --onto origin/<default-branch> <old-parent-tip> <child-branch>
gh pr edit <child-pr> --base <default-branch>
```

GitHub retargets child PRs on its own when the merged branch is deleted, but the child's history still needs the rebase.
