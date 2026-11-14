#!/usr/bin/env bash
#
# Test the install scripts in a temporary HOME, with stubs for GitHub, the
# network and the steps. Run by validate-config.sh.

set -euo pipefail

repo="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

failures=0

# expect NAME WANT GOT: report a failure if GOT differs from WANT
expect() {
    if [[ "$2" != "$3" ]]; then
        printf 'FAIL %s\n  want: %s\n  got:  %s\n' "$1" "$2" "$3" >&2
        failures=$((failures + 1))
    fi
}

# has NAME LINE OUTPUT: report a failure if OUTPUT lacks the line LINE
has() {
    if ! grep -qxF -- "$2" <<<"$3"; then
        printf 'FAIL %s\n  missing line: %s\n' "$1" "$2" >&2
        failures=$((failures + 1))
    fi
}

# stub PATH TEXT: an executable shell script at PATH that prints TEXT
stub() {
    mkdir -p "$(dirname -- "$1")"
    printf '#!/bin/sh\necho "%s"\n' "$2" >"$1"
    chmod +x "$1"
}

test_install_repos() {
    local home="$tmp/repos/home" bin="$tmp/repos/bin" out status r
    local personal="$home/projects/_personal"
    for r in marked unmarked foreign; do
        mkdir -p "$personal/$r"
        git -C "$personal/$r" init -q
    done
    git -C "$personal/marked" remote add origin git@github.com:me/marked.git
    git -C "$personal/unmarked" remote add origin https://github.com/me/unmarked
    git -C "$personal/foreign" remote add origin git@github.com:other/foreign.git
    printf '#!/bin/sh\n# install-repos: tools\nread -r x && echo INPUT; echo MARKED\n' \
        >"$personal/marked/install.sh"
    stub "$personal/unmarked/install.sh" UNMARKED
    chmod +x "$personal/marked/install.sh"
    mkdir -p "$bin"
    cat >"$bin/gh" <<'EOF'
#!/bin/sh
case "$1 $2" in
    "auth status") exit 0 ;;
    "repo list") printf 'foreign\nmarked\nmissing\nunmarked\n' ;;
    *) exit 1 ;;
esac
EOF
    chmod +x "$bin/gh"

    status=0
    out="$(HOME="$home" PATH="$bin:$PATH" "$repo/scripts/install-repos.sh" --owner me 2>&1 <<<"typed")" \
        || status=$?
    expect "install-repos: exit status" 1 "$status"
    has "install-repos: marked install.sh runs" MARKED "$out"
    expect "install-repos: input reaches install.sh" "" "$(grep -x INPUT <<<"$out" || true)"
    expect "install-repos: unmarked install.sh runs" "" "$(grep -x UNMARKED <<<"$out" || true)"
    has "install-repos: unmarked skipped" \
        "Skipping unmarked: its install.sh lacks the line '# install-repos: tools'" "$out"
    has "install-repos: foreign skipped" \
        "Skipping me/foreign: $personal/foreign is a clone of another repository" "$out"
    has "install-repos: failed clone" "Failed: missing" "$out"
}

test_bootstrap() {
    local root="$tmp/boot/dotfiles" home="$tmp/boot/home" bin="$tmp/boot/bin" s out status
    mkdir -p "$root/scripts" "$home"
    cp "$repo/scripts/bootstrap.sh" "$root/scripts/"
    for s in install.sh scripts/install-pkgs.sh scripts/update-nvim.sh \
            scripts/install-tree-sitter.sh scripts/install-nerd-fonts.sh \
            scripts/install-repos.sh; do
        stub "$root/$s" "ran $s"
    done
    stub "$bin/pre-commit" "ran pre-commit"

    out="$(HOME="$home" PATH="$bin:$PATH" "$root/scripts/bootstrap.sh" | grep '^ran ')"
    expect "bootstrap: order" "ran install.sh
ran scripts/install-pkgs.sh
ran pre-commit
ran scripts/update-nvim.sh
ran scripts/install-tree-sitter.sh
ran scripts/install-nerd-fonts.sh
ran scripts/install-repos.sh" "$out"

    stub "$home/.local/bin/nvim" ""
    mkdir -p "$home/.local/share/fonts/Hack"
    out="$(HOME="$home" PATH="$bin:$PATH" "$root/scripts/bootstrap.sh")"
    expect "bootstrap: Neovim skipped" "" "$(grep -x 'ran scripts/update-nvim.sh' <<<"$out" || true)"
    expect "bootstrap: fonts skipped" "" "$(grep -x 'ran scripts/install-nerd-fonts.sh' <<<"$out" || true)"

    printf '#!/bin/sh\nexit 3\n' >"$root/scripts/install-pkgs.sh"
    status=0
    out="$(HOME="$home" PATH="$bin:$PATH" "$root/scripts/bootstrap.sh")" || status=$?
    expect "bootstrap: failed step status" 3 "$status"
    expect "bootstrap: stops at failed step" "" "$(grep -x 'ran pre-commit' <<<"$out" || true)"
}

test_tree_sitter() {
    local home="$tmp/ts/home" bin="$tmp/ts/bin" out
    stub "$home/.cargo/bin/cargo" 'cargo $*'
    stub "$bin/tree-sitter" "tree-sitter 0.25.9"

    out="$(HOME="$home" PATH="$bin:$PATH" "$repo/scripts/install-tree-sitter.sh")"
    has "tree-sitter: old version is rebuilt" "cargo install --locked tree-sitter-cli" "$out"

    stub "$home/.cargo/bin/tree-sitter" "tree-sitter 0.27.2"
    out="$(HOME="$home" PATH="$bin:$PATH" "$repo/scripts/install-tree-sitter.sh")"
    has "tree-sitter: ~/.cargo/bin first" "Tree-sitter CLI 0.27.2 is installed." "$out"

    rm "$home/.cargo/bin/tree-sitter"
    stub "$bin/tree-sitter" "tree-sitter 0.26.1"
    out="$(HOME="$home" PATH="$bin:$PATH" "$repo/scripts/install-tree-sitter.sh")"
    has "tree-sitter: required version kept" "Tree-sitter CLI 0.26.1 is installed." "$out"
}

test_install_repos
test_bootstrap
test_tree_sitter

if ((failures > 0)); then
    echo "$failures install script checks failed." >&2
    exit 1
fi
echo "Install script checks passed."
