#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${CURRENT_DIR}/config/colors.env
source ${CURRENT_DIR}/config/symbols.env

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Color configuration
BG="${bg_dark}"
FG="${fg}"

MAIN_BG=${blue}
MAIN_FG=${dark3}

# Status bar
tmux_set "status-position" "bottom"
tmux_set "status-justify" "left"

tmux_set "status-left-length" 100
tmux_set "status-right-length" 100

tmux_set "status-bg" "${BG}"
tmux_set "status-fg" "${FG}"

tmux_set "status-left-style" "bg=${MAIN_BG},fg=${MAIN_FG}"
tmux_set "status-right-style" "bg=${MAIN_BG},fg=${MAIN_FG}"
