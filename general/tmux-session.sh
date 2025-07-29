#!/bin/bash
# Save and restore the state of tmux sessions, windows, and panes.
# Adapted from https://github.com/mislav/dotfiles/blob/master/bin/tmux-session
# Usage: tmux-session.sh [save|restore]

set -e

SAVE_FILE="${TMUX_SESSION_FILE:-$HOME/.tmux-session}"
VERBOSE="${VERBOSE:-0}"

# Check if tmux is installed
if ! command -v tmux >/dev/null 2>&1; then
  echo "Error: tmux is not installed" >&2
  exit 1
fi

# Capture session, window, and pane information
dump() {
  local d=$'\t'
  tmux list-panes -a -F "#S${d}#W${d}#P${d}#{pane_current_path}${d}#{pane_current_command}"
}

# Save tmux state to file
save() {
  if ! dump > "$SAVE_FILE"; then
    echo "Error: Failed to save session to $SAVE_FILE" >&2
    exit 1
  fi
  chmod 600 "$SAVE_FILE"  # Secure file permissions
  [ "$VERBOSE" -eq 1 ] && echo "Saved tmux state to $SAVE_FILE"
}

# Get terminal size, fallback to defaults if stty fails
terminal_size() {
  local size
  size=$(stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }') || true
  echo "${size:- -x80 -y24}"  # Default to 80x24 if stty fails
}

# Check if a session exists
session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

# Add a window to an existing session
add_window() {
  local session="$1" window="$2" dir="$3"
  if [[ -d "$dir" ]]; then
    tmux new-window -d -t "$session:" -n "$window" -c "$dir"
    [ "$VERBOSE" -eq 1 ] && echo "Added window $window to session $session in $dir"
  else
    [ "$VERBOSE" -eq 1 ] && echo "Skipping window $window in session $session: directory $dir does not exist"
  fi
}

# Add a pane to a window
add_pane() {
  local session="$1" window="$2" pane="$3" dir="$4" command="$5"
  if [[ -d "$dir" ]]; then
    if [[ "$pane" -gt 1 ]]; then
      tmux split-window -t "$session:$window.$((pane-1))" -c "$dir" -h
      [ "$VERBOSE" -eq 1 ] && echo "Added pane $pane to $session:$window in $dir"
    fi
    # Optionally send command to pane (e.g., for shells)
    if [[ -n "$command" && "$command" != "tmux" ]]; then
      tmux send-keys -t "$session:$window.$pane" "$command" C-m
      [ "$VERBOSE" -eq 1 ] && echo "Sent command '$command' to pane $pane in $session:$window"
    fi
  fi
}

# Create a new session
new_session() {
  local session="$1" window="$2" dir="$3" dimensions="$4"
  if [[ -d "$dir" ]]; then
    cd "$dir" && tmux new-session -d -s "$session" -n "$window" "$dimensions"
    [ "$VERBOSE" -eq 1 ] && echo "Created session $session with window $window in $dir"
  else
    [ "$VERBOSE" -eq 1 ] && echo "Skipping session $session: directory $dir does not exist"
  fi
}

# Restore sessions, windows, and panes
restore() {
  tmux start-server
  local count=0
  local dimensions="$(terminal_size)"
  local last_session="" last_window=""

  if [[ ! -r "$SAVE_FILE" ]]; then
    echo "Error: Cannot read $SAVE_FILE" >&2
    exit 1
  fi

  while IFS=$'\t' read -r session_name window_name pane_id dir command; do
    # Skip invalid or unwanted entries
    if [[ -z "$session_name" || -z "$window_name" || -z "$pane_id" || -z "$dir" ]]; then
      [ "$VERBOSE" -eq 1 ] && echo "Skipping invalid entry: session=$session_name, window=$window_name, pane=$pane_id, dir=$dir"
      continue
    fi
    if [[ "$window_name" == "log" || "$window_name" == "man" ]]; then
      [ "$VERBOSE" -eq 1 ] && echo "Skipping window $window_name in session $session_name"
      continue
    fi

    if [[ "$session_name" != "$last_session" ]]; then
      if session_exists "$session_name"; then
        [ "$VERBOSE" -eq 1 ] && echo "Session $session_name already exists"
      else
        new_session "$session_name" "$window_name" "$dir" "$dimensions"
        count=$((count + 1))
      fi
      last_session="$session_name"
      last_window=""
    fi

    if [[ "$window_name" != "$last_window" ]]; then
      if session_exists "$session_name"; then
        add_window "$session_name" "$window_name" "$dir"
      fi
      last_window="$window_name"
    fi

    add_pane "$session_name" "$window_name" "$pane_id" "$dir" "$command"
  done < "$SAVE_FILE"

  echo "Restored $count sessions"
}

# Parse command-line arguments
case "$1" in
  save)
    save
    ;;
  restore)
    restore
    ;;
  *)
    echo "Usage: $0 {save|restore}" >&2
    echo "Set VERBOSE=1 for detailed output" >&2
    echo "Set TMUX_SESSION_FILE to override default save file (~/.tmux-session)" >&2
    exit 1
    ;;
esac

# EOF
