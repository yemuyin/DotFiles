#!/bin/bash

window_info=$(niri msg focused-window)

app_id=$(echo "$window_info" | grep "App ID:" | sed 's/  App ID: "\(.*\)"/\1/')
pid=$(echo "$window_info" | grep "PID:" | sed 's/  PID: \(.*\)/\1/')
title=$(echo "$window_info" | grep "Title:" | sed 's/  Title: "\(.*\)"/\1/')

[ -z "$title" ] && title="Sin título"

notify-send " Window Info" " App ID: $app_id |  PID: $pid |  Title: $title"
