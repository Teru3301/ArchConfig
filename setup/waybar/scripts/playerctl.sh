#!/bin/bash
output=$(playerctl metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}}"}')
if [ -z "$output" ]; then
    echo '{"text": "No music", "alt": "stopped", "tooltip": "No music playing"}'
else
    echo "$output"
fi