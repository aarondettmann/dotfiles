#!/usr/bin/env bash
#
# Install or update Nerd Fonts from the GitHub release archives into
# ~/.local/share/fonts/<FONT>. Run with --help for usage.

set -euo pipefail

# Archive names as published at https://github.com/ryanoasis/nerd-fonts/releases
default_fonts=(
    JetBrainsMono   # kitty
    Hack            # conky
)

tag="latest"
fonts=()
while (($# > 0)); do
    case "$1" in
        --tag)
            [[ $# -ge 2 ]] || { echo "Error: --tag requires a value" >&2; exit 2; }
            tag="$2"
            shift
            ;;
        -h|--help)
            cat <<USAGE
Usage: ./scripts/install-nerd-fonts.sh [--tag TAG] [FONT ...]

Install or update Nerd Fonts into ~/.local/share/fonts/<FONT>, replacing any
previous installation of that font. Archives are verified against the SHA-256
list published with the release.

Options:
  --tag TAG  Release tag such as "v3.5.1" (default: latest release).
  FONT       Archive name without extension, e.g. "JetBrainsMono", "FiraCode".
             Default: ${default_fonts[*]}
USAGE
            exit 0
            ;;
        -*)
            echo "Error: unknown option: $1" >&2
            exit 2
            ;;
        *)
            fonts+=("$1")
            ;;
    esac
    shift
done
((${#fonts[@]} > 0)) || fonts=("${default_fonts[@]}")

font_dir="$HOME/.local/share/fonts"
if [[ "$tag" == "latest" ]]; then
    url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"
else
    url="https://github.com/ryanoasis/nerd-fonts/releases/download/${tag}"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
cd "$tmp_dir"

echo "Fetching checksums (${tag})..."
curl -fsSL -o SHA-256.txt "$url/SHA-256.txt"

for font in "${fonts[@]}"; do
    asset="${font}.tar.xz"
    echo "Downloading ${asset}..."
    curl -fL --progress-bar -o "$asset" "$url/$asset"

    # Fails if the checksum does not match or the asset is not listed.
    grep " ${asset}\$" SHA-256.txt | sha256sum --check --quiet

    dest="$font_dir/$font"
    rm -rf "$dest"
    mkdir -p "$dest"
    tar xJf "$asset" -C "$dest"
    echo "Installed ${font} -> ${dest}"
done

echo "Refreshing font cache..."
fc-cache -f "$font_dir"
