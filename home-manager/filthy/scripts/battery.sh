#!/usr/bin/env bash

echo "{\"percentage\": \"$(cat /sys/class/power_supply/BAT0/capacity)\", \"status\": \"$(cat /sys/class/power_supply/BAT0/status)\"}"
