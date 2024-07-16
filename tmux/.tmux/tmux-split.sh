#!/usr/bin/env bash

tmux new-session \; \
    split-window -h -p 60 \; \
    select-pane -t 1 \; \
    split-window -v -p 5 \; \
    clock-mode -t 2 \; \
    select-pane -t 3 \; \
    # split-window -v -p 50 \; \
    # send-keys 'vim' C-m \; \

