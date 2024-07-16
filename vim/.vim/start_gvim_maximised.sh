#!/bin/bash

# From: http://vim.wikia.com/wiki/Maximize_or_set_initial_window_size (2018-07-20)

exec=/usr/bin/gvim # location of gvim
$exec -f $* &
pid=$!
winid=""

while [ -z $winid ]
do
    sleep 0.05
    winid=`wmctrl -pl |grep -P "^0x[0-9a-f]+[ ]+[-0-9]+[ ]+$pid" | cut -f1 -d' '`
done

# echo "debug: $exec started, PID=$pid, Window ID=$winid"

# ==> this maximizes the gvim window
wmctrl -i -b add,maximized_vert,maximized_horz -r $winid

# ==> this switches the gvim window to fullscreen
# wmctrl -i -b add,fullscreen -r $winid

