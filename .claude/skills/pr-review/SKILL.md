---
name: "pr-review"
description: "Review someone else's pull request and leave the findings as a pending GitHub review for the user to edit and submit. Use when asked to review a PR."
disable-model-invocation: true
argument-hint: "<pr-url|number>"
allowed-tools:
  - "Read"
  - "Bash(git fetch:*)"
  - "Bash(git show:*)"
  - "Bash(git grep:*)"
  - "Bash(git log:*)"
  - "Bash(git diff:*)"
  - "Bash(gh pr view:*)"
  - "Bash(gh pr diff:*)"
  - "Bash(gh issue view:*)"
  - "Bash(gh repo view:*)"
  - "Bash(gh api:*)"
---

## Arguments

`$ARGUMENTS` is a PR URL or number. If it is empty, end the turn without doing or printing anything.

## Silence

Don't ask questions or print anything until the final output.

## Standards

The bar is [standards.md](../ship/references/standards.md), the same one `/ship` holds its own code to. Violations of it are findings.

## Steps

1. **Gather.**
   - **The PR:** `gh pr view <arg> --json number,url,title,body,author,headRefOid,closingIssuesReferences` and `gh pr diff <arg>`.
   - **Your login:** `gh api user --jq .login`.
   - **Linked tickets**, from closing references and from keys or URLs in the title, body, and branch. Read them with whatever is available, in this order: `gh` for GitHub, a connected MCP server for the tracker (look it up with `ToolSearch`), the tracker's CLI, then `WebFetch`. Skip any you can't read.
   - **Threads and your pending review:**

     ```sh
     gh api graphql -F o=<owner> -F r=<repo> -F n=<number> -f query='
       query($o: String!, $r: String!, $n: Int!) {
         repository(owner: $o, name: $r) {
           pullRequest(number: $n) {
             id
             reviews(states: PENDING, first: 1) { nodes { id body viewerDidAuthor } }
             reviewThreads(first: 100) {
               nodes { id isResolved path line comments(first: 50) { nodes { author { login } body } } }
             }
           }
         }
       }'
     ```

2. **Read the code around the diff** at the PR's head, without touching the working tree.
   - **From a clone of the PR's repository:** run `git fetch origin pull/<number>/head`, then read with `git show FETCH_HEAD:<path>` and search with `git grep <pattern> FETCH_HEAD`.
   - **From anywhere else:** use `gh api "repos/<owner>/<repo>/contents/<path>?ref=<headRefOid>" --jq .content | base64 -d`.
3. **Review it yourself**, the way a senior teammate would, without review skills or subagents. Look at two things:
   - **The code:** bugs a careful reader would catch, and standards violations.
   - **The vibe:** does the approach fit the problem and the codebase? Is it in the right place and the right size? Does it do what its tickets ask, and no more?

   Flag what matters. Don't hunt for every possible issue. A PR that is fine gets no comments.
4. **Re-review.** For each unresolved thread you started, check whether the head commit addresses it. Unaddressed threads get a reply. Addressed ones get nothing.
5. **Filter.** Drop anything an existing thread already raises, whoever wrote it, and anything a linter or formatter would catch.
6. **Post as pending.** Use your pending review from step 1 when `viewerDidAuthor` is true. Otherwise create one. Never create a second one, and never submit it.
   - **Create:** `addPullRequestReview(input: {pullRequestId})` with no `event`.
   - **Finding on a diff line:** `addPullRequestReviewThread(input: {pullRequestReviewId, path, line, side: RIGHT, body})`, adding `startLine` and `startSide` for a range.
   - **Reply to a thread from step 4:** `addPullRequestReviewThreadReply(input: {pullRequestReviewId, pullRequestReviewThreadId, body})`.
   - **Finding outside the diff:** append it to the review body as `path:line` plus the comment, with `updatePullRequestReview(input: {pullRequestReviewId, body})`. Keep any text already in the body.

## Comments

One problem per comment, in one or two short sentences. Say what is wrong and what to do instead. Use a `suggestion` block when the fix is small and exact. No praise, no summaries, no headings, no severity labels.

## Output

Print one line: `<N> pending comments on <pr-url>`, or `Nothing to flag on <pr-url>` when there are no findings.
