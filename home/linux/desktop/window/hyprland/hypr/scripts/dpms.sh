#!/usr/bin/env bash

hyprctl workspaces > /dev/null

if [ $? -ne 0 ]; then
    hyprctl dispatch dpms off
fi
