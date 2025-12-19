---
description: Generate PR Message
agent: build
model: github-copilot/gpt-4.1
---

## Context

**PR number:**
!`gh pr view --json number --jq .number`

**PR comments:**
!`gh pr view --json comments --jq '.comments[] | .author.login + "\n" + .body + "\n\n---\n"'`

**PR commits:**
!`gh pr view --json commits --jq '.commits[] | .messageHeadline + "\n" + (.messageBody // "") + "\n\n---\n"'`

**PR diff:**
!`gh pr diff`

!`rm .pr-message.md`

## Instructions

Your job is to write a PR message for this feature branch. Write it to `.pr-message.md`. Make sure to take a look at already opened PR and its comments, if any. Next, look at the updated files, diffs, and anything else you may need to write a detailed and well structured PR message. Proceed with writing the PR message based on the gathered information. It should be formatted in Markdown, with the top header being the title of the PR, followed by a detailed description of the changes made, any issues addressed, and the implications of these changes. Include any relevant links to Linear and corresponding GitHub issues, Projects, and PR requests. After PR message is generated use `gh pr edit --body-file .pr-message.md` command to update the PR message. If PR is in draft mode use `gh pr ready` command to mark it as ready for review. Make sure to follow any additional instructions provided by the user in $1

## Rules

- **NEVER** use level 1 and level 2 headers in the PR message. Your first header should be level 3 (`###`).
- **NEVER** use emojies in PR message.
  - For marked checkmarks use `- [x]` and for unmarked use `- [ ]`. Never use any other characters or symbols.
- **NEVER** add OpenCode, Copilot, OpenAI, ChatGPT, Claude, Claude Code, Anthropic or any other AI tool, agent, or company as co-author of the PR or commit, but do mention that PR message was generated with OpenCode.
  - You may use a single robot emoji here. This is the **ONLY** exception to the emoji rule.
  - It should look like this: `🤖 Generated with OpenCode`
- **ALWAYS** write about breaking changes if they are present in the PR.
- **ALWAYS** include background and future implications of this PR in the PR message.
