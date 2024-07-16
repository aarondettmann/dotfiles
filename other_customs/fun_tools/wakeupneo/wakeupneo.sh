#!/usr/bin/env bash

# wakeupneo.sh -- "The Matrix" scence written in Bash
# Copyright (C) 2012,2018 edloaa <edloaa at gmail dot com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

teip() {
    str="$@"
    while [ -n "$str" ]; do
        printf "%c" "$str"
        str=${str#?}
        sleep .$(($RANDOM%2+1))
    done
}

slcl() {
    sleep 2
    clear
}

ctrl_c() {
    echo -e '\e[0m'
    clear
    exit 130
}

trap ctrl_c 2 20

msg='Wake up, Neo...
The Matrix has you...
Follow the white rabbit.'

clear
echo -en '\e[1;32m'

echo "$msg" | \
    while read line; do
        teip "$line"
        slcl
    done

    echo -n "Knock, kock, Neo."
    slcl

    echo -en '\e[0m'

