#!/usr/bin/env bash

selected_dir=$(find ~/git ~/kk ~/scripts -mindepth 1 -maxdepth 1 -type d | fzf --print-query)
IFS=$'\n' read -r -d '' -a input <<< "$selected_dir" || true
IFS=' ' read -r -a args <<< "${input[0]}"
dir=${input[1]}
[[ -z "$dir" && ! "${args[0]}" =~ ^(clone|mkdir|open|cd)$ ]] && exit 0

case ${args[0]} in
  "clone")
    if [[ ${#args[@]} -eq 3 ]]; then
      dir="$HOME/${args[1]}/$(basename -s .git ${args[2]})"
      cd "$HOME/${args[1]}"; git clone ${args[2]}
    else
      exit 0
    fi
    ;;
  "mkdir")
    if [[ ${#args[@]} -eq 3 ]]; then
      dir="$HOME/${args[1]}/${args[2]}"
      mkdir -p $dir
    else
      exit 0
    fi
    ;;
  "open")
    if [[ ${#args[@]} -eq 2 && -d ~/${args[1]} ]]; then
      dir="$HOME/${args[1]}"
    else
      exit 0
    fi
    ;;
  "cd")
    if [[ ${#args[@]} -eq 2 && -d ~/${args[1]} ]]; then
      selected_dir=$(find ~/${args[1]} -mindepth 1 -maxdepth 1 -type d | fzf)
      dir=$selected_dir
      [[ -z "$dir" ]] && exit 0
    else
      exit 0
    fi
    ;;
esac

session=$(tmux display-message -p '#S')
window_name=$(basename "$dir")

match=$(tmux list-windows -a -F '#{session_name}:#{window_name}' 2>/dev/null \
  | awk -v wname="$window_name" '$1 ~ (":" wname "$") { print $1; exit }')

if [[ -n "$match" ]]; then
  match_session="${match%%:*}"
  tmux switch-client -t "$match_session"
  tmux select-window -t "$match"
  exit 0
fi

window_index=$(tmux new-window -t "${session}:" -c "$dir" -n "$window_name" -P -F '#{window_index}')
tmux send-keys -t "${session}:${window_index}" 'nvim' C-m
