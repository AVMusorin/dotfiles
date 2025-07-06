#!/usr/bin/env bash

set -e

# Options
VERBOSE=0
DRY_RUN=0

# Backup directory for current files
bkp_timestamp=$(date +%Y-%m-%d_%H%M%S)
BACKUP_DIR=$(mktemp -d "/tmp/dotfiles.bkp.$bkp_timestamp.XXXXXXX")

# Stat
NEW_FILES=0
PROCESSED_FILES=0

function cleanup() {
    if [ -d "$BACKUP_DIR" ] && [ ! "$(find "$BACKUP_DIR" -mindepth 1 -print -quit)" ]; then
        # remove empty directory
        rm -r "$BACKUP_DIR"
    fi
}

trap cleanup INT

function process_file() {
    local file=$1 && shift

    PROCESSED_FILES=$(( PROCESSED_FILES + 1 ))
    orig_file="$HOME/$file"
    source_file="$PWD/$file"
    if [ -L "$orig_file" ]; then
        echo "Symbolic link $orig_file exists, skip..."
        return 0
    fi
    NEW_FILES=$(( NEW_FILES + 1 ))
    if [[ -f "$orig_file" ]]; then
        backup_file "$orig_file" "$file"
    fi
    link_file "$orig_file" "$source_file"
}

function link_file() {
    local orig=$1 && shift
    local new=$1 && shift

    if [[ "$VERBOSE" -eq 1 ]]; then
        diff -bur --color=always "$orig" "$new" && true
    fi

    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[DRY_RUN] process $orig -> $new"
    else
        if [[ -f "$orig" ]]; then
            rm "$orig"
        fi
        local base_folder
        base_folder=$(dirname "$orig")
        mkdir -p "$base_folder"
        ln -s "$new" "$orig"
    fi
}

function backup_file() {
    local source=$1 && shift
    local dest=$1 && shift

    local base_dir
    base_dir=$(dirname "$dest")
    mkdir -p "$BACKUP_DIR/$base_dir"
    cp "$source" "$BACKUP_DIR/$file"
}

function help() {
    cat <<EOL
Usage: ${BASH_SOURCE[0]} [...] [ TEST_NAMES... ]

Options:

    --dry-run       - Dry run.
    --verbose       - Activates extra logging and diffs from files

    -h - Print this help and exit
EOL
}


if ! OPTS=$(getopt -o h -l help,dry-run,verbose -- "$@"); then
    echo "Failed to parse options" >&2
fi

eval set -- "$OPTS"

while true; do
    case "$1" in
        '--dry-run')
            DRY_RUN=1
            shift
            continue
        ;;
        '--verbose')
            VERBOSE=1
            shift
            continue
        ;;
        '-h'|'--help')
            help
            exit 0
        ;;
        '--')
          shift
          break
        ;;
        '*')
          echo "Internal error: unrecognized option '$1'" >&2
          exit 1
       ;;
    esac
done


cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Symlinking..."

# home directory dotfiles
while IFS= read -r -d '' file; do
    # don't link these files
    ignore_files=(
        ".gitmodules"
    )
    filename=$(basename "$file")
    if printf "%s\n" "${ignore_files[@]}" | grep -qxF "$filename"; then
        continue
    fi
    process_file "$file"
done < <(find . -maxdepth 1 -type f -name '.?*' -print0)

echo ".config directory"
# .config directory files
while IFS= read -r -d '' file; do
    process_file "$file"
done < <(find ./.config -type f -print0)

echo "Symlink tmux plugins"
# symlink tmux plugins
while IFS= read -r -d '' directory; do
    name=$(basename "$directory")
    mkdir -p "$HOME/.tmux/plugins"
    if [ -L "$HOME/.tmux/plugins/$name" ]; then
        echo "Symlink $PWD/$directory $HOME/.tmux/plugins/$name exists..."
        continue
    fi
    echo "Symlink $PWD/$directory $HOME/.tmux/plugins/$name"
    ln -s  "$PWD/$directory" "$HOME/.tmux/plugins/$name"
done < <(find ./tmux/plugins -mindepth 1 -maxdepth 1 -type d -print0)

# TODO: check dead links

echo "Statistic:"
echo "New files:       $NEW_FILES"
echo "Processed files: $PROCESSED_FILES"

if [[ "$NEW_FILES" -gt 0 ]]; then
    echo "Backup folder: $BACKUP_DIR"
fi
