#!/bin/sh
exec doas tee /sys/class/backlight/intel_backlight/brightness
