---
name: review-commit
description: Review the latest commit or the current branch's changes against its base. Use when the user says "review my last commit", "review this commit", "review my branch", "review my changes", "/review-commit", or wants feedback on recently committed work (not uncommitted diffs).
---

# Review Commit / Branch

Read-only review of committed work. Do not modify files.

## Scope

- Explicit argument (SHA, `HEAD~2`, branch) wins.
- "commit" / "last commit" → that single commit.
- Otherwise: branch diff vs merge-base of the base branch (`main`/`master`/`develop`, or remote HEAD) if multiple commits ahead; else latest commit.
- Diff >2000 lines: review file-by-file, source first, skip generated files/lockfiles.

## Review

Read surrounding code when a hunk is ambiguous — verify findings against actual code, not pattern matching. Priority order:

1. Correctness, regressions in callers/contracts
2. Security
3. Missing/weakened tests
4. Commit message vs diff mismatch, unrelated changes smuggled in
5. Simplification/dead code

Skip: formatter-level style, naming taste, pre-existing issues outside changed lines.

## Report

1. Verdict line: ship it / minor issues / needs fixes, plus scope ("3 commits on `feature-x` vs `main`, 12 files").
2. Findings by severity: `file:line`, problem, why, concrete fix.
3. Non-blocking notes, if any.
