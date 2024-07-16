#!/usr/bin/env bash

echo -e "GIT: Review changes and push to remote\n"

echo -n "Review changes... "
gitk
echo "Done!"

read -p "Push repo? [y/n] " proceed
if [[ "$proceed" = "y" ]]; then
    read -p "RUN: git push [optional arguments] " git_push_args
    echo
    eval "git push ${git_push_args}"
else
    echo "Abort."
    exit 1
fi

echo
read -p "Press [Enter] to quit..."

