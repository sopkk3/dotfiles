#!/usr/bin/env bash

selected=$(tmux list-windows -F '#I: #W' | fzf)
[ -z "$selected" ] && exit 0
index=$(echo "$selected" | cut -d: -f1)
tmux select-window -t ":$index"
