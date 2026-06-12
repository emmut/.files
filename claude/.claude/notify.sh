#!/bin/bash
# Claude Code notification hook.
# Usage: notify.sh "message"
# Skips the notification when the originating tmux pane is focused
# (pane active in its window, window active, and the terminal app frontmost).

msg="${1:-Claude Code}"
title="Claude Code"

if [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ]; then
  label=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name}:#{window_name}' 2>/dev/null)
  [ -n "$label" ] && title="Claude Code — $label"

  pane_focused=$(tmux display-message -p -t "$TMUX_PANE" \
    '#{&&:#{pane_active},#{&&:#{window_active},#{session_attached}}}' 2>/dev/null)

  if [ "$pane_focused" = "1" ]; then
    front=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
    case "$front" in
      [Gg]hostty|kitty|[Aa]lacritty|iTerm2|Terminal) exit 0 ;;
    esac
  fi
fi

osascript -e 'on run argv' \
  -e 'display notification (item 1 of argv) with title (item 2 of argv)' \
  -e 'end run' "$msg" "$title"
