#!/bin/bash

pid=`pgrep wf-recorder`
status=$?

if [ $status != 0 ]
then
  wf-recorder -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).name')" -f $HOME/recordings/$(date +'recording_%Y-%m-%d-%H%M%S.mp4');
else
  pkill --signal SIGINT wf-recorder
fi;
