#!/usr/bin/env bash
#
# Clone the personal GitHub repositories into ~/projects/_personal and
# install their tools. Run with --help for usage.
#
# The repositories are listed with the GitHub CLI, so that this public file
# names none of the private ones. Existing clones are not pulled.
#
# A repository opts in with an executable install.sh that contains the
# line "# install-repos: tools". The script runs without input, installs
# for the current user and can be run again to update.

set -euo pipefail

dest_dir="$HOME/projects/_personal"
marker='# install-repos: tools'

owner="aarondettmann"
dry_run=false
while (($# > 0)); do
    case "$1" in
        --owner)
            [[ $# -ge 2 ]] || { echo "Error: --owner requires a value" >&2; exit 2; }
            owner="$2"
            shift
            ;;
        -n|--dry-run)
            dry_run=true
            ;;
        -h|--help)
            cat <<USAGE
Usage: ./scripts/install-repos.sh [--owner OWNER] [-n|--dry-run]

Clone the GitHub repositories of OWNER into $dest_dir/<name>,
unless already cloned there, then run the install.sh of every clone that
contains the line "$marker".

Options:
  --owner OWNER  GitHub user (default: $owner).
  -n, --dry-run  List what would be cloned and installed, change nothing.
USAGE
            exit 0
            ;;
        *)
            echo "Error: unknown argument: $1" >&2
            exit 2
            ;;
    esac
    shift
done

# need COMMAND: install the apt package COMMAND if the command is missing
need() {
    command -v "$1" >/dev/null 2>&1 && return
    if [[ "$dry_run" == true ]]; then
        echo "Would install '$1'"
        return
    fi
    echo "Installing '$1'..."
    sudo apt-get update -qq
    sudo apt-get install --yes "$1"
}

need git
need gh

if ! gh auth status >/dev/null 2>&1; then
    echo "The GitHub CLI is not logged in; starting 'gh auth login'..."
    gh auth login
fi

# slug URL: the "owner/name" of a GitHub remote URL, in lower case
slug() {
    local s="$1"
    s="${s%.git}"
    s="${s%/}"
    s="${s#*github.com[:/]}"
    printf '%s\n' "${s,,}"
}

if ! names_text="$(gh repo list "$owner" --limit 1000 --json name --jq '.[].name' | sort)"; then
    echo "Error: listing the repositories of '$owner' failed" >&2
    exit 1
fi
mapfile -t names <<<"$names_text"
if [[ -z "${names[0]:-}" ]]; then
    echo "Error: '$owner' has no repositories" >&2
    exit 1
fi

failed=()
repos=()
for name in "${names[@]}"; do
    target="$dest_dir/$name"
    if [[ -e "$target/.git" ]]; then
        url="$(git -C "$target" config --get remote.origin.url || true)"
        if [[ "$(slug "$url")" == "$(slug "$owner/$name")" ]]; then
            repos+=("$target")
        else
            echo "Skipping $owner/$name: $target is a clone of another repository" >&2
        fi
        continue
    fi
    if [[ -e "$target" ]]; then
        echo "Skipping $owner/$name: $target exists and is not a clone" >&2
        continue
    fi
    if [[ "$dry_run" == true ]]; then
        echo "Would clone $owner/$name into $target"
        continue
    fi
    echo "Cloning $owner/$name into $target..."
    mkdir -p "$dest_dir"
    if ! gh repo clone "$owner/$name" "$target" -- --quiet; then
        failed+=("$name")
        echo "Error: cloning $owner/$name failed" >&2
        continue
    fi
    repos+=("$target")
done

for repo in "${repos[@]}"; do
    name="$(basename -- "$repo")"
    [[ -x "$repo/install.sh" ]] || continue
    if ! grep -qxF -- "$marker" "$repo/install.sh"; then
        echo "Skipping $name: its install.sh lacks the line '$marker'"
        continue
    fi

    if [[ "$dry_run" == true ]]; then
        echo "Would run $repo/install.sh"
        continue
    fi

    echo "Installing the tools of $name..."
    if ! (cd -- "$repo" && ./install.sh </dev/null); then
        failed+=("$name")
        echo "Error: installing the tools of $name failed" >&2
    fi
done

case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) echo "Warning: ~/.local/bin is not on PATH; open a new login shell." >&2 ;;
esac

if ((${#failed[@]} > 0)); then
    echo "Failed: ${failed[*]}" >&2
    exit 1
fi

echo "Done."
