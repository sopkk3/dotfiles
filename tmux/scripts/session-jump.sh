#!/usr/bin/env bash

current=$(tmux display-message -p '#S')

fzf_out=$(tmux list-sessions -F '#S' 2>/dev/null | grep -v "^${current}$" \
  | fzf --print-query --prompt="session> ")

[ -z "$fzf_out" ] && exit 0

query=$(echo "$fzf_out" | sed -n '1p')
selection=$(echo "$fzf_out" | sed -n '2p')

case "$query" in
  kill*)
    target=$(echo "$query" | awk '{print $2}')
    [ -z "$target" ] && exit 0
    tmux kill-session -t "$target"
    exit 0
    ;;
  new*)
    name=$(echo "$query" | awk '{print $2}')
    [ -z "$name" ] && exit 0
    ;;
  *)
    if [ -n "$selection" ]; then
      tmux switch-client -t "$selection"
      exit 0
    else
      name="$query"
    fi
    ;;
esac

[ -z "$name" ] && exit 0

dir_selected=$(find ~/git ~/kk ~/scripts -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
  | fzf --prompt="dir for '$name'> ")
dir=${dir_selected:-$HOME}
window_name=$(basename "$dir")

tmux new-session -ds "$name" -c "$dir" -n "$window_name"
tmux send-keys -t "${name}:${window_name}" 'nvim' C-m
tmux switch-client -t "$name"
