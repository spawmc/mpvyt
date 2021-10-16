#!/usr/bin/env bash

socket_dir="/tmp/mpvsocket"
last_pid=""

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

function pause_or_play () {
    local status=$(echo '{ "command": ["get_property", "pause"] }' | socat - /tmp/mpvsocket | jq '.data');
    if [[ "${status}" == "true" ]]; then
        echo "Playing";
        echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpvsocket;
    elif [[ "${status}" == "false" ]]; then
        echo "Stoped";
        echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket;
    fi
}

function key_call () {
    case "${1}" in
        l)
            kill -9 "${last_pid}";
            echo "Next track";
            ;;
        n)
            echo "n press";
            ;;
        p)
            pause_or_play;
            ;;
        "?")
            echo "Choise not found";
            ;;
    esac
}

function mpv_whitout_video () {
    mpv --ytdl "${1}" --ytdl-format=249 --input-ipc-server="${socket_dir}" > /dev/null 2>&1 &
    last_pid="${!}";
}


function playing_whitout_video () {
    tput civis
    for link in "${links_playlist[@]}"; do
        mpv_whitout_video "${link}"
        while true; do
            read -rsn1 input
            key_call "${input}";
        done
    done
    tput cnorm
}

function main () {
    dependency-check "jq" "youtube-dl" "curl" "mpv" "socat"
    playing_whitout_video
}

main
