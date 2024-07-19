#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${CURRENT_DIR}/config/colors.env
source ${CURRENT_DIR}/config/symbols.env

get_hostname() {
    local hostname
    if command -v scutil > /dev/null 2>&1 ; then
        hostname=$(scutil --get ComputerName)
    else
        hostname=$(hostname -f)
    fi
    printf "%s" $hostname
}

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

WIN_FG="$MAIN_BG"
WIN_BG="$MAIN_FG"

# Status bar
tmux_set "status-position" "bottom"
tmux_set "status-justify" "left"

tmux_set "status-left-length" 100
tmux_set "status-right-length" 100

tmux_set "status-bg" "${BG}"
tmux_set "status-fg" "${FG}"

tmux_set "status-left-style" "bg=${MAIN_BG},fg=${MAIN_FG}"
tmux_set "status-right-style" "bg=${MAIN_BG},fg=${MAIN_FG}"

# Left segment
LS=" ${session_icon} #S #[bg=${WIN_BG},fg=${WIN_FG}]${larrow}"
tmux_set "status-left" "${LS}"

# Window segment
tmux_set "window-status-separator" "#[bg=${WIN_BG},fg=${WIN_FG}]${lseparator}"

tmux_set "window-status-style"         "bg=${WIN_BG},fg=${WIN_FG}"
tmux_set "window-status-current-style" "bg=${WIN_BG},fg=${FG} bold"
tmux_set "window-status-last-style"    "bg=${WIN_BG},fg=${WIN_FG} italics"

last_segment="#{?window_end_flag,#[bg=${BG}#,fg=${WIN_BG}]${larrow},}"
WF="#I:#W#F${last_segment}"

tmux_set "window-status-format" "$WF"
tmux_set "window-status-current-format" "$WF"

# Right segment
host_segment="#[bg=${WIN_BG},fg=${MAIN_BG}]${rarrow}#[bg=${MAIN_BG},fg=${MAIN_FG}] ${host_icon} $(get_hostname)"
user_segment="#[bg=${BG},fg=${WIN_BG}]${rarrow}#[bg=${WIN_BG},fg=${WIN_FG}] ${user_icon} $(whoami)"
prefix_segment="#[bg=${BG},fg=${MAIN_BG}]#{?window_zoomed_flag,${zoom_icon},} #{prefix_highlight}"
RS="${prefix_segment} ${user_segment}${host_segment}"

tmux_set "status-right" "$RS"
