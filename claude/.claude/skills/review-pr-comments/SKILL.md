---
name: review-pr-comments
description: Show and review the comments on the current branch's open PR (inline review comments, review summaries, and general comments). Use when the user says "review PR comments", "what comments are on my PR", "check PR feedback", or invokes /review-pr-comments.
---

# Review PR Comments

Fetch every comment on the PR for the current branch and help triage them.

## Fetch (run, don't reimplement)

The fetch logic lives in a bundled script so it does not have to be processed.
Run it via the `!` prefix so its output lands directly in context:

```
! bash ~/.claude/skills/review-pr-comments/fetch.sh
```

It prints three groups: inline review comments (`[file:line]`), review
summaries (with state), and general comments. "No PR found" → branch has no
open PR; stop.

## Review

From that output:

1. Group comments by file, then by theme (bug, style, question, nit).
2. For each actionable comment: quote it, give a one-line take, and propose a
   concrete fix or reply.
3. Flag blocking items (CHANGES_REQUESTED, correctness, security) first.
4. List open questions needing the author's input.

Do not edit code unless asked — this is read-only triage.
