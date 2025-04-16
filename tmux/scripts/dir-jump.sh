#!/bin/bash

selected_dir=$(find ~/git ~/kk -mindepth 1 -maxdepth 1 -type d | fzf --print-query)
input=($selected_dir)
dir=${input[1]}
if [[ ${#input[@]} -lt 2 || -z ${input[1]} ]]; then
  exit 0
fi

case ${input[0]} in
  "clone")
    if [[ ${#input[@]} -eq 3 ]]; then
      dir="$HOME/${input[1]}/$(basename -s .git ${input[2]})"
      cd "$HOME/${input[1]}"; git clone ${input[2]}
    else
      exit 0
    fi
    ;;
  "mkdir")
    if [[ ${#input[@]} -eq 3 ]]; then
      dir="$HOME/${input[1]}/${input[2]}"
      mkdir -p $dir
    else
      exit 0
    fi
    ;;
  "open")
    if [[ ${#input[@]} -eq 2 ]]; then
      dir="$HOME/${input[1]}"
    else
      exit 0
    fi
    ;;
  "cd")
    if [[ ${#input[@]} -eq 2 ]]; then
      selected_dir=$(find ~/${input[1]} -mindepth 1 -maxdepth 1 -type d | fzf)
      dir=$selected_dir
    else
      exit 0
    fi
    ;;
esac

window_name=$(basename $dir)
if tmux has-session -t '$0':$window_name 2> /dev/null; then
  tmux select-window -t $window_name
  exit 0
fi

tmux new-window -c $dir -n $window_name
