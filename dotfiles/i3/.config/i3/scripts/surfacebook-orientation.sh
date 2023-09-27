#!/usr/bin/env zsh

if ! which monitor-sensor; then
  exit 1
fi

TOUCHSCREEN="IPTS 045E:0020 Touchscreen"

monitor-sensor --accel | while read orientation; do
  case $orientation in
    *bottom-up*)
      xrandr -o inverted
      xinput set-prop "${TOUCHSCREEN}" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
      ;;
    *left-up*)
      xrandr -o left
      xinput set-prop "${TOUCHSCREEN}" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
      ;;
    *right-up*)
      xrandr -o right
      xinput set-prop "${TOUCHSCREEN}" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
      ;;
    *normal*)
      xrandr -o normal
      xinput set-prop "${TOUCHSCREEN}" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
      ;;
  esac
done
