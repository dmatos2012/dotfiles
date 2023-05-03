#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar
#
# # Launch bar1 and bar2
# From their README
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# MONITOR=DPI-4 polybar --reload i3bar 2>&1 | tee -a /tmp/polybar1.log & disown
# MONITOR=HDMI-0 polybar --reload i3bar 2>&1 | tee -a /tmp/polybar1.log & disown
# # polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
#
# echo "Bars launched..."
#
#From https://github.com/polybar/polybar/issues/763
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload i3bar &
  done
else
  polybar --reload i3bar &
fi
