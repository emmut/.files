---
name: resolve-merge-conflict
description: Resolve git merge conflicts during a merge, rebase, cherry-pick, or stash pop. Use when the user says "resolve the merge conflict", "fix conflicts", "I have conflicts", a merge/rebase stopped with conflicts, or files contain conflict markers (<<<<<<<, =======, >>>>>>>).
---

# Resolve Merge Conflict

Never blindly pick one side — understand what each side changed and preserve the intent of both. When unsure which side is semantically right, ask the user.

- During **rebase**, `ours`/`theirs` are inverted vs. merge: `--ours` = upstream, `--theirs` = your commits being replayed.
- See base/ours/theirs: `git show :1:<file>` / `:2:` / `:3:`, or `git checkout --conflict=diff3 <file>` for 3-way markers.
- After resolving: verify no leftover markers (`git diff --check`, `git grep -nE '^(<{7}|={7}|>{7})( |$)'`), then build/test — markerless ≠ correct.
- Stash pop does not auto-drop on conflict: resolve, `git add`, then `git stash drop`.
- If resolution looks wrong, abort (`--abort`) and reassess rather than forcing it.
