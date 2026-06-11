---
name: resolve-merge-conflict
description: Resolve git merge conflicts during a merge, rebase, cherry-pick, or stash pop. Use when the user says "resolve the merge conflict", "fix conflicts", "I have conflicts", a merge/rebase stopped with conflicts, or files contain conflict markers (<<<<<<<, =======, >>>>>>>).
---

# Resolve Merge Conflict

This skill guides resolving git merge conflicts safely and correctly.

## When to Use

- A `git merge`, `git rebase`, `git cherry-pick`, or `git stash pop` halted with conflicts
- The user asks to resolve, fix, or finish conflicts
- Files contain conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`

## Core Principle

**Never blindly pick one side.** A conflict means both sides changed the same lines. The correct resolution usually preserves the *intent* of both changes. Understand what each side did before choosing.

## Workflow

### 1. Assess state

Run these to understand the situation:

```bash
git status                          # what operation is in progress, which files conflict
git diff --name-only --diff-filter=U  # list only unmerged files
```

Identify which operation is active. It changes what "ours" and "theirs" mean:

| Operation | `--ours` / HEAD | `--theirs` |
|-----------|-----------------|------------|
| merge | current branch | branch being merged in |
| rebase | branch being rebased onto (upstream) | your commits being replayed |
| cherry-pick | current branch | the commit being picked |

Note the **inversion during rebase** — `ours` and `theirs` are flipped vs. a merge. Verify before using `--ours`/`--theirs` shortcuts.

### 2. Inspect each conflict

For every conflicted file, read it and find the marker blocks:

```
<<<<<<< HEAD
ours side
=======
theirs side
>>>>>>> <ref>
```

To see what each side actually changed relative to the common ancestor:

```bash
git log --merge -p <file>     # commits touching the conflict
git show :1:<file>            # common ancestor (base)
git show :2:<file>            # ours
git show :3:<file>            # theirs
```

For tricky conflicts, enable 3-way markers (`diff3` style) to also show the base:

```bash
git checkout --conflict=diff3 <file>
```

### 3. Resolve

Edit each file to the correct combined result and **remove all conflict markers**. Decide per-hunk:

- Both changes needed → integrate both
- One supersedes the other → keep the right one, understand why
- Whole-file pick (only when sure):
  - `git checkout --ours <file>` / `git checkout --theirs <file>`

After editing, scan for any leftover markers across the repo:

```bash
git grep -nE '^(<{7}|={7}|>{7})( |$)' || echo "no markers left"
```

### 4. Stage and verify

```bash
git add <resolved-files>
git diff --check        # warns on leftover conflict markers / whitespace errors
```

Build / run tests if the project has them — a clean merge can still be logically broken.

### 5. Complete the operation

```bash
git merge --continue        # or just `git commit` for a plain merge
git rebase --continue
git cherry-pick --continue
```

For a stash pop conflict: resolve, `git add`, then `git stash drop` once satisfied (pop does not auto-drop on conflict).

## Escape Hatches

If something looks wrong, abort and reassess — do not force a bad resolution:

```bash
git merge --abort
git rebase --abort
git cherry-pick --abort
```

## Rules

- Read both sides and the base before deciding. Preserve intent, not just one branch.
- Remove every conflict marker. Verify with `git diff --check` and `git grep`.
- During rebase, remember `ours`/`theirs` are inverted.
- Run tests/build after resolving — markerless does not mean correct.
- When unsure which side is right, ask the user; don't guess on semantically important code.
