#!/usr/bin/env bash

function dependency-check () {
    for dependency; do
        if ! command -v "${dependency}" &>/dev/null; then
            echo -e "${dependency} not found. Please install it.\n" >&2
            exit 2
        fi
    done
    unset dependency
}

trap ctrl_c INT

function ctrl_c () {
    echo -e "\n[!] Exiting..."
    tput cnorm; exit 0
}

function key_call () {
    case "${1}" in
        l)
            kill -9 "${last_pid}"
            echo "Next track"
            ;;
        n)
            echo "n press"
            ;;
        "?")
            echo "Choise not found";
            ;;
    esac
}

function playing_whitout_video () {
    tput civis
    for link in "${links_playlist[@]}"; do
        mpv --ytdl "${link}" --ytdl-format=249 > /dev/null 2>&1  &
        last_pid="${!}";
        while true; do
            read -rsn1 input
            key_call "${input}";
        done
    done
    tput cnorm
}

function main () {
    dependency-check "jq" "youtube-dl" "curl" "mpv"
}

main
