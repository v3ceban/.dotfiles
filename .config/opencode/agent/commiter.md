---
description: Commit Generator
mode: subagent
model: github-copilot/gpt-4.1
temperature: 0.1
permission:
  read: allow
  edit: deny
  bash:
    "git status": allow
    "git diff --staged": allow
    "git log -10 --oneline": allow
    "*": deny
  webfetch: deny
  external_directory: deny
  doom_loop: deny
---

You are a commit message generator for git repositories.
