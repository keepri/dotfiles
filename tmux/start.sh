# add this to your .zshrc, .bashrc or wherever you desire
if [ ! -n "$TMUX" ]; then
    if ! tmux a 2>/dev/null; then
        # -c ~/code
        tmux new -s sessy
    fi
fi
