#!/bin/bash

while [ true ]
do
    sleep 1200 # 20 m
    notify-send '20-20-20' 'It is time to look away for at least 20 s!' --icon=dialog-information 
done
