#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# (C) edloaa
# 2019-01-30

import time
import datetime
import os
from colour import Color, web2hex, rgb2hex, hex2rgb


# TODO:
# - don't allow duplicates in gradient colour list
# - make sure that always n_desired points are returned


TMUX_SOCKET_NAME="default"
TMUX_CHANGE_COLOR_CMD='tmux -L {:s} setw -g clock-mode-colour "{:s}"'


def set_tmux_clock_colour(colour_id):
    """
    Send command to TMUX sessions to update the clock colour.

    Args:
        :colour_id: (str) name of colour (valid TMUX format)
    """

    cmd = TMUX_CHANGE_COLOR_CMD.format(TMUX_SOCKET_NAME, colour_id)
    print(cmd)
    os.system(cmd)


def gen_colour_gradient(colour_supports, n_desired):
    """
    Return colour gradient in hex format.

    Args:
        :colour_supports: (str-list) list of colour support points
        :n_desired: (int) number of colours in gradient

    Returns:
        :gradient: (str-list) gradient colour list
    """

    colour_list = [Color(colour) for colour in colour_supports]
    n_list = len(colour_list)
    n_per_pair = int(n_desired/(n_list-1))
    gradient = []

    for i in range(n_list - 1):
        c1 = colour_list[i]
        c2 = colour_list[i+1]
        gradient += list(c1.range_to(c2.hex, n_per_pair))

    for i, colour in enumerate(gradient):
        gradient[i] = Color(colour).hex_l

    return list(gradient)


def colour_gradient():
    """
    Make TMUX change colour over the course of the day.
    """

    gradient = gen_colour_gradient(["blue", "green", "yellow", "red"], 24*60)

    while True:
        hour = datetime.datetime.now().hour
        minute = datetime.datetime.now().minute
        dayminute = hour*60 + minute

        set_tmux_clock_colour(str(gradient[dayminute]))
        time.sleep(60)


if __name__ == '__main__':
    colour_gradient()

