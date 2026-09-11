---
name: resolve-merge-conflict
description: Resolve git merge conflicts during a merge, rebase, cherry-pick, or stash pop, or resolve a pull request's conflicts against its base branch. Use when the user says "resolve the merge conflict", "fix conflicts", "I have conflicts", "resolve conflicts on PR #123" or passes a PR number/URL, a merge/rebase stopped with conflicts, or files contain conflict markers (<<<<<<<, =======, >>>>>>>).
---

# Resolve Merge Conflict

Never blindly pick one side — understand what each side changed and preserve the intent of both. When unsure which side is semantically right, ask the user.

- During **rebase**, `ours`/`theirs` are inverted vs. merge: `--ours` = upstream, `--theirs` = your commits being replayed.
- See base/ours/theirs: `git show :1:<file>` / `:2:` / `:3:`, or `git checkout --conflict=diff3 <file>` for 3-way markers.
- After resolving: verify no leftover markers (`git diff --check`, `git grep -nE '^(<{7}|={7}|>{7})( |$)'`), then build/test — markerless ≠ correct.
- Stash pop does not auto-drop on conflict: resolve, `git add`, then `git stash drop`.
- If resolution looks wrong, abort (`--abort`) and reassess rather than forcing it.

## Given a PR instead of an active conflict

Arg may be a number (`#123`, `123`) or a PR URL. Resolve conflicts the PR has against its base:

```bash
gh pr view <pr> --json number,headRefName,baseRefName,headRepositoryOwner,mergeable,url
git fetch origin
gh pr checkout <pr>              # from a clone of the PR's repo; adds the fork remote if cross-repo
git merge origin/<baseRefName>   # or: git rebase origin/<baseRefName> if that branch is rebase-style
```

Then resolve as above. Notes:

- `mergeable: MERGEABLE` → nothing to do, say so instead of merging anyway.
- Don't switch branches in a checkout someone else is working in — use a fresh worktree (`git worktree add`) when the current one is dirty or shared.
- Merge vs rebase: default merge (safe, no force-push). Rebase only if the user asks or the branch's history says so; then the push is `--force-with-lease`.
- Push only when the user asks.
