#!/usr/bin/env bash
# Dump all comments on the PR for the current branch: inline review comments,
# review summaries, and general issue comments. Read-only.
set -euo pipefail

pr=$(gh pr view --json number,title,url 2>/dev/null) || {
  echo "No PR found for the current branch."; exit 0;
}
num=$(jq -r .number <<<"$pr")
repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)

printf 'PR #%s — %s\n%s\n\n' "$num" "$(jq -r .title <<<"$pr")" "$(jq -r .url <<<"$pr")"

echo "== Inline review comments =="
gh api "repos/$repo/pulls/$num/comments" --paginate \
  --jq '.[] | "[\(.path):\(.line // .original_line)] \(.user.login):\n  \(.body | gsub("\n";"\n  "))\n"' \
  || echo "(none)"

echo "== Review summaries =="
gh api "repos/$repo/pulls/$num/reviews" --paginate \
  --jq '.[] | select(.body != "") | "\(.user.login) [\(.state)]:\n  \(.body | gsub("\n";"\n  "))\n"' \
  || echo "(none)"

echo "== General comments =="
gh api "repos/$repo/issues/$num/comments" --paginate \
  --jq '.[] | "\(.user.login):\n  \(.body | gsub("\n";"\n  "))\n"' \
  || echo "(none)"
