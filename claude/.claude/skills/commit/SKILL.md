---
name: commit
description: Create a git commit following this repo's conventions. Use when the user says "commit", "commit this", "make a commit", or "/commit".
model: claude-haiku-4-5-20251001
---

# Commit

Stage the relevant changes and commit them. Match the existing history — check `git log --oneline` if unsure.

## Message format

`<gitmoji> <short lowercase imperative subject>` — no type/scope prefix, no trailing period. Usually a single line; add a body only when the change needs explaining.

Common gitmoji: 🔧 config/tooling · ✨ feature · 🐛 fix · ♻️ refactor · 📝 docs · 🚚 move/rename · 💄 ui · 🚧 wip · 🎉 init

## Rules

- Commit only what the user asked for; don't sweep in unrelated staged changes.
- No `Co-Authored-By` or generated-with trailers.
