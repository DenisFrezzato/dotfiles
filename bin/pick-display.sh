#!/bin/bash

connectedOutputs=($(xrandr --query | grep " connected" | cut -d" " -f1))

if [ ${#connectedOutputs[@]} -eq 2 ]
then
    # Activate the external display and set it as the primary one.
    xrandr --output ${connectedOutputs[1]} --auto --primary --right-of ${connectedOutputs[0]}
fi

