#!/bin/bash

selected_dir=$(find ~/git -mindepth 1 -maxdepth 1 -type d | fzf)
if [[ -z $selected_dir ]]; then
    exit 0
fi
window_name=$(basename $selected_dir)

if tmux has-session -t '$0':$window_name 2> /dev/null; then
    tmux select-window -t $window_name
    exit 0
fi

tmux new-window -c $selected_dir -n $window_name
