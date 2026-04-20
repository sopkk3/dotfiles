#!/usr/bin/env bash

selected_dir=$(find ~/git ~/kk ~/scripts -mindepth 1 -maxdepth 1 -type d | fzf --print-query)
IFS=$'\n' read -r -d '' -a input <<< "$selected_dir" || true
IFS=' ' read -r -a args <<< "${input[0]}"
dir=${input[1]}
if [[ -z "${args[0]}" && -z "${input[1]}" ]]; then
  exit 0
fi

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
    if [[ ${#args[@]} -eq 2 ]]; then
      dir="$HOME/${args[1]}"
    else
      exit 0
    fi
    ;;
  "cd")
    if [[ ${#args[@]} -eq 2 ]]; then
      selected_dir=$(find ~/${args[1]} -mindepth 1 -maxdepth 1 -type d | fzf)
      dir=$selected_dir
    else
      exit 0
    fi
    ;;
esac

session=$(tmux display-message -p '#S')
window_name=$(basename $dir)
if tmux has-session -t "${session}:${window_name}" 2> /dev/null; then
  tmux select-window -t "${session}:${window_name}"
  exit 0
fi

tmux new-window -t "${session}:" -c "$dir" -n "$window_name"
tmux send-keys -t "${session}:${window_name}" 'nvim' C-m
