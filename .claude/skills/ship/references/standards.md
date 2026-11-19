# Standards

The bar for every change `/ship` makes and every PR `/pr-review` reviews. Less code is better code. A change that removes more lines than it adds is usually the right one.

## The project comes first

The project's own conventions win over everything below: its instruction files (`CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`), its linters and formatters, and the patterns its existing code follows for structure, naming, types, errors, and tests. Read them before writing or judging code, and follow them even where you would choose differently.

## Size

- The smallest change that fully solves the problem at its root. Solve the problem in front of you, not hypothetical future ones.
- Well engineered, not over-engineered. The design fits the problem's real shape and the codebase's patterns. Add an abstraction, option, config value, retry, fallback, or compatibility layer when the problem needs it, never just in case. When a simpler design is just as correct, choose it, but never trade correctness or robustness for fewer lines.
- No defensive code for states that can't happen. Validate at system boundaries and trust what is inside them.
- No one-caller helpers or wrappers, no separate file for something with one consumer, and no `-v2`, `new-`, or `run-` style names.
- No new dependencies or languages when the existing stack can do it.
- Delete dead code, unused exports, and anything the change made obsolete.

## DRY and YAGNI

- Reuse what exists: functions, components, modules, scripts, patterns. Extend the existing thing instead of building a parallel one.
- Fix duplication, even outside the task's scope. Scope creep is welcome when it removes code.

## Comments

- None, except comments the language or tooling requires, and doc comments on public library APIs so they show up in editors.
- Never TODOs, change narration ("now uses X", "removed Y"), section banners, or comments that restate the code. Removing a comment means deleting it, not trimming it.

## Correctness

- Keep the strongest guarantees the project's language and tooling give. Never weaken them to make code compile or pass, for example with casts, ignores, or suppressions.
- One source of truth per shape or rule. Derive from it instead of redeclaring it.
- Fix the first place the system goes wrong. A guard, retry, or special case around a symptom is not a fix.
- Every caller and usage of a changed thing is updated, and every check CI runs passes.

## HTML and CSS

HTML describes the document's structure. CSS creates its layout and look. Every element must carry meaning: a `<ul>` and `<li>` for a list, a `<section>` for a region, a `<nav>` for navigation, a `<menu>` for a set of commands, a `<button>` for an action. Use generic containers like `<div>` and `<span>` only when no semantic element fits and the element still groups something meaningful.

- Never add an element only to style, position, group, or space its children, whether it wraps one child or several.
- A single child never needs a wrapper. Move the styles onto the child, passing a class through when it is a component:

  ```html
  <!-- Instead of -->
  <div class="bg-muted p-4"><Card /></div>

  <!-- write -->
  <Card class="bg-muted p-4" />
  ```

- Lay out siblings by styling the parent they already have with grid or flex, or make them one component whose root is the meaningful element, such as a list. Reach for pseudo-elements before adding markup for decoration.
- Use the framework's fragment where it needs a single root without an element.
- Use component APIs as designed, for example an icon prop instead of an icon child, instead of working around them.

## Output and prose

- Less is more. PR descriptions, commit messages, review comments, logs, and CLI output are short, written for a human to read, and to the point. No summaries, filler, or restating the diff.
- Scripts and CLIs print only what the user needs and ask for no confirmations that aren't needed.

## Git

- Clean history. Amend or fixup changes into the commit they belong to, and rebase and force-push your own branches with `--force-with-lease` whenever it keeps history clean. No empty, WIP, or probe commits.
- Never bypass hooks. Never add AI attribution.
