#!/bin/bash

RT_SIGNAL_NUM=1;

get_signal_num() {
    echo $RT_SIGNAL_NUM;
}

CMD=$1;
LISTENER=$2;

send_signal_to_caller() {
    if [ -n $LISTENER ]; then
        pkill -RTMIN+$(get_signal_num) $LISTENER;
    fi
}


# Function to switch keyboard layout
# Changes in all devices so we can get correctly below
switch_lang() {
    # Fetch devices and construct the batch command
    keyboards=$(hyprctl devices -j | jq -r '.keyboards[] | .name');
    batch_command="";
    for keyboard in $keyboards; do
        batch_command+="switchxkblayout ${keyboard} next;";
    done
    hyprctl --batch "$batch_command";
    send_signal_to_caller;
}

# Function to get the current keyboard layout
# by just getting any
get_lang() {
    hyprctl devices -j |
        jq -r '.keyboards[0].active_keymap' |
        cut -c1-2 |
        tr 'A-Z' 'a-z';
}

case $CMD in
get-signal_num)
    get_signal
    ;;
switch-lang)
    switch_lang
    ;;
get-lang)
    get_lang
    ;;
*)
    echo "Usage: $0 {get_signal_num|switch-lang|get-lang}"
    exit 1
    ;;
esac

exit 0;
