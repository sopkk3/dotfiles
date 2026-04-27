#!/usr/bin/env bash

selected=$(tmux list-windows -a -F '#S: #I: #W' | fzf)
[ -z "$selected" ] && exit 0
session=$(echo "$selected" | cut -d: -f1 | tr -d ' ')
index=$(echo "$selected" | cut -d: -f2 | tr -d ' ')
tmux switch-client -t "${session}:${index}"
