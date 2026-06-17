#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 2019-01-30

import datetime
import subprocess
import sys
import time

from colour import Color


# TODO:
# - don't allow duplicates in gradient colour list
# - make sure that always n_desired points are returned


TMUX_SOCKET_NAME = "default"


def set_tmux_clock_colour(colour_id):
    """
    Send command to TMUX sessions to update the clock colour.

    Args:
        :colour_id: (str) name of colour (valid TMUX format)
    """

    cmd = [
        "tmux",
        "-L",
        TMUX_SOCKET_NAME,
        "setw",
        "-g",
        "clock-mode-colour",
        colour_id,
    ]
    print(" ".join(cmd))
    result = subprocess.run(cmd, check=False, capture_output=True, text=True)
    if result.returncode != 0:
        stderr = result.stderr.strip() if result.stderr else "unknown error"
        print(
            f"Failed to set tmux clock colour (exit {result.returncode}): {stderr}",
            file=sys.stderr,
        )


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
    n_per_pair = n_desired // (n_list - 1)
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
