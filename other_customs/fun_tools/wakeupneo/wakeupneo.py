#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# wakeupneo.py -- "The Matrix" scence written in Python
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

import time, os, sys, random

def slcl(n):
    time.sleep(n)
    os.system('clear')

msg1 = 'Wake up, Neo...\nThe Matrix has you...\nFollow the white rabbit.\n'
msg2 = 'Knock, kock, Neo.'

try:
    os.system('clear')
    print('\033[1;32m', end='')

    for char in msg1:
        if char == '\n':
            slcl(2)
        else:
            print(char, end='')
            sys.stdout.flush()
            time.sleep(random.uniform(0.05,0.25))

    print(msg2, '\033[0m', end='')
    sys.stdout.flush()
    slcl(2)

except KeyboardInterrupt:
    print('\033[0m')
    os.system('clear')
    sys.exit(130)

