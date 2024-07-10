#!/bin/bash

set -uo pipefail

LIST_PANES="$(tmux list-panes -F '#F' )"
PANE_ZOOMED="$(echo "${LIST_PANES}" | grep Z)"
PANE_COUNT="$(echo "${LIST_PANES}" | wc -l | bc)"

if [ "${PANE_COUNT}" = 1 ]; then
  tmux split-window -c "#{pane_current_path}"
elif [ -n "${PANE_ZOOMED}" ]; then
  tmux select-pane -t:.-
else
  tmux resize-pane -Z -t1
fi
