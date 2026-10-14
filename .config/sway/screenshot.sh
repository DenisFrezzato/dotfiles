#!/bin/sh
# usage: screenshot.sh window|region|output [copy]
mode=$2
case $1 in
  window) set -- -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ;;
  region) g=$(slurp) || exit 1; set -- -g "$g" ;;
  output) set -- -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')" ;;
  *) echo "usage: $0 window|region|output [copy]" >&2; exit 2 ;;
esac
if [ "$mode" = copy ]; then
  grim "$@" - | wl-copy -t image/png && notify-send "Screenshot copied"
else
  grim "$@" && notify-send "Screenshot saved"
fi
