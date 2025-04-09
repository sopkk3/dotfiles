#!/bin/bash

selected_dir=$(find ~/git ~/kk -mindepth 1 -maxdepth 1 -type d | fzf --print-query)
input=($selected_dir)
dir=${input[1]}
if [[ ${#input[@]} -lt 2 || -z ${input[1]} ]]; then
  exit 0
fi

if [[ "${input[0]}" == "clone" ]]; then
  if [[ ${#input[@]} -eq 3 ]]; then
    dir="$HOME/${input[1]}/$(basename -s .git ${input[2]})"
    cd "$HOME/${input[1]}"; git clone ${input[2]}
  else
    exit 0
  fi
fi

if [[ "${input[0]}" == "mkdir" ]]; then
  if [[ ${#input[@]} -eq 3 ]]; then
    dir="$HOME/${input[1]}/${input[2]}"
    mkdir -p $dir
  else
    exit 0
  fi
fi

window_name=$(basename $dir)
if tmux has-session -t '$0':$window_name 2> /dev/null; then
  tmux select-window -t $window_name
  exit 0
fi

tmux new-window -c $dir -n $window_name
