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

function link_file() {
    local orig=$1 && shift
    local new=$1 && shift

    if [[ "$VERBOSE" -eq 1 ]]; then
        diff -bur --color=always "$orig" "$new" && true
    fi

    backup_file "$orig"
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo "[DRY_RUN] process $orig -> $new"
    else
        rm "$orig"
        ln -s "$new" "$orig" && echo "   ...linked"
    fi
}

function backup_file() {
    local file=$1 && shift

    local filename
    filename=$(basename "$file")
    cp "$file" "$BACKUP_DIR/$filename"
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

while IFS= read -r -d '' file; do
    PROCESSED_FILES=$(( PROCESSED_FILES + 1 ))
    orig_file="$HOME/$file"
    source_file="$PWD/$file"
    if [ -L "$orig_file" ]; then
        echo "Symbolic link $orig_file exists, skip..."
        continue
    fi
    NEW_FILES=$(( NEW_FILES + 1 ))
    link_file "$orig_file" "$source_file"
done < <(find . -maxdepth 1 -type f -name '.?*' -print0)

echo "Statistic:"
echo "New files:       $NEW_FILES"
echo "Processed files: $PROCESSED_FILES"

if [[ "$NEW_FILES" -gt 0 ]]; then
    echo "Backup folder: $BACKUP_DIR"
fi
