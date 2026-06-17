#!/usr/bin/env bash
set -euo pipefail

# wakeupneo.sh -- "The Matrix" scene written in Bash
# Copyright (C) 2012,2018 Aaron Dettmann
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
    local str="$*"
    while [[ -n "$str" ]]; do
        printf '%c' "$str"
        str=${str#?}
        sleep ".$((RANDOM % 2 + 1))"
    done
}

slcl() {
    sleep 2
    clear
}

ctrl_c() {
    printf '\e[0m'
    clear
    exit 130
}

trap ctrl_c INT TSTP

msg='Wake up, Neo...
The Matrix has you...
Follow the white rabbit.'

clear
printf '\e[1;32m'

while IFS= read -r line; do
    teip "$line"
    slcl
done <<< "$msg"

printf '%s' "Knock, knock, Neo."
slcl

printf '\e[0m'
