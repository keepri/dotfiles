if [ ! -n "$TMUX" ]; then
    if ! tmux a 2>/dev/null; then
        tmux new -c ~/code -s sessy
    fi
fi
