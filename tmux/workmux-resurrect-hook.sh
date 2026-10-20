#!/usr/bin/env bash

# tmux-resurrect restores sidebar panes as shells, losing @workmux_role.
# Store their positions in the snapshot and remove only newly restored copies.
set -euo pipefail

case "${1:-}" in
  save)
    snapshot=${2:?snapshot path required}
    tmux list-panes -a -F $'#{session_name}\t#{window_index}\t#{pane_index}\t#{@workmux_role}' |
      awk -F '\t' '$4 == "sidebar" { print "workmux_sidebar\t" $1 "\t" $2 "\t" $3 }' >> "$snapshot"
    ;;
  before)
    existing=" $(tmux list-panes -a -F '#{pane_id}' | tr '\n' ' ') "
    tmux set-option -gq @workmux_resurrect_existing_panes "$existing"
    ;;
  after)
    existing=$(tmux show-option -gqv @workmux_resurrect_existing_panes)
    tmux set-option -gu @workmux_resurrect_existing_panes
    [[ -n $existing ]] || exit 0

    resurrect_dir=$(tmux show-option -gqv @resurrect-dir)
    if [[ -z $resurrect_dir ]]; then
      if [[ -d $HOME/.tmux/resurrect ]]; then
        resurrect_dir=$HOME/.tmux/resurrect
      else
        resurrect_dir=${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect
      fi
    fi
    snapshot=$resurrect_dir/last
    [[ -f $snapshot ]] || exit 0

    while IFS=$'\t' read -r kind session window pane; do
      [[ $kind == workmux_sidebar ]] || continue
      [[ $window =~ ^[0-9]+$ && $pane =~ ^[0-9]+$ ]] || continue
      target="$session:$window.$pane"
      info=$(tmux display-message -p -t "$target" -F '#{pane_id} #{@workmux_role}' 2>/dev/null) || continue
      read -r pane_id role <<< "$info"
      [[ $pane_id =~ ^%[0-9]+$ && ${role:-} != sidebar ]] || continue
      case "$existing" in
        *" $pane_id "*) continue ;;
      esac
      tmux kill-pane -t "$pane_id"
    done < "$snapshot"
    ;;
  *)
    echo 'usage: workmux-resurrect-hook.sh {save SNAPSHOT|before|after}' >&2
    exit 2
    ;;
esac
