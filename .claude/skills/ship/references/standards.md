# Standards

The bar for every change `/ship` makes and every PR `/pr-review` reviews. Less code is better code. A change that removes more lines than it adds is usually the right one.

## Size

- The smallest diff that solves the problem. Fix the case that exists, not every case that could.
- No abstractions, options, flags, params, env vars, config, retries, queues, timeouts, fallbacks, or compatibility shims that nobody asked for. Hardcode until something needs it to vary.
- No defensive code for states that can't happen. Guard at system boundaries and trust internal types. Don't wrap code that can't fail.
- No one-caller helpers or wrappers, no separate types or constants file for a single consumer, no `-v2`, `new-`, or `run-` style names.
- No new dependencies or languages when the existing stack can do it.
- Delete dead code, unused exports, and anything the change made obsolete.

## DRY and YAGNI

- Reuse what exists: components, hooks, helpers, contexts, scripts, patterns. Extend the existing thing instead of building a parallel one.
- Fix duplication, even outside the task's scope. Scope creep is welcome when it removes code.
- Do it the way the surrounding code does it.

## Comments

- None, except comments required by a linter, formatter, or the language, and doc comments on library-level exported APIs so they show up in the LSP.
- Never TODOs, change narration ("now uses X", "removed Y"), section banners, or comments that restate the code. Removing a comment means deleting it, not trimming it.

## Types

- Type safety to the end. No `any`, casts, non-null assertions, stringly-typed values, or types that allow illegal states.
- One source of truth per shape. Infer types from it (for example from a DB schema) instead of redeclaring them.
- Follow the codebase's error-handling model instead of ad-hoc try/catch.

## HTML and CSS

- HTML adds semantics. CSS does styling. An element that only wraps a single child or exists for styling is wasted: delete it and move the styling to CSS or to the child. Prefer semantic elements over `div` and `span`.
- Use component APIs as designed, for example an icon prop instead of an icon child.

## Root causes

- Fix the first place the system goes wrong. A guard, retry, or special case around a symptom is not a fix.

## Complete

- Every caller and usage of a changed thing is updated, and every check CI runs passes.

## Output and prose

- Less is more. PR descriptions, commit messages, review comments, logs, and CLI output are short and to the point. No summaries, filler, or restating the diff.
- Scripts and CLIs print only what the user needs and ask for no confirmations that aren't needed.

## Git

- Clean history. Amend or fixup changes into the commit they belong to, and rebase and force-push your own branches with `--force-with-lease` whenever it keeps history clean. No empty, WIP, or probe commits.
- Never bypass hooks. Never add AI attribution.
