#!/bin/sh

awk '{print $1" "$2}' < /proc/loadavg
