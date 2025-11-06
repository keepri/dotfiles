#!/bin/bash

if [ -d "$HOME/.config/aliases" ]; then
    for alias_file in "$HOME/.config/aliases"/*.sh; do
        if [ "$alias_file" = "${BASH_SOURCE[0]}" ]; then
            continue
        fi

        if [ -r "$alias_file" ]; then
            source "$alias_file"
        fi
    done
fi
