#!/bin/bash

PLAYER=$1
COMMAND=$2

# Default command is "show"
if [ -z "$COMMAND" ]; then
    COMMAND="show"
fi

if [ "$COMMAND" = "show" ]; then
    info=$(playerctl --player="$PLAYER" metadata --format '{{status}}|{{artist}}|{{title}}|{{duration(position)}}' 2>/dev/null)
    if [ -z "$info" ]; then
        # No player or no song
        echo "No song playing"
        exit 0
    fi

    IFS='|' read -r status artist title position <<< "$info"
    printf "%s - %s (%s)" "$artist" "$title" "$position"
    exit 0
fi

# If player not running, start it
if ! playerctl --player="$PLAYER" status -s &>/dev/null; then
    $PLAYER &
    sleep 1
fi

case "$COMMAND" in
    prev)
        playerctl --player="$PLAYER" previous ;;
    play-pause)
        playerctl --player="$PLAYER" play-pause ;;
    next)
        playerctl --player="$PLAYER" next ;;
    *)
        echo "Invalid command: $COMMAND"
        exit 1 ;;
esac
