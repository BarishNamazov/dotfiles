#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -alF'

alias gnome-settings='XDG_CURRENT_DESKTOP=GNOME gnome-control-center'

# Updated PS1 with branch in brackets, shown only in Git repos
parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/(/;s/$/)/'
}

# Color Variables
BLUE="\[\e[0;34m\]"     # Blue for username and host
WHITE="\[\e[0;37m\]"    # White for the working directory
PURPLE="\[\e[0;35m\]"   # Purple for Git branch
RED="\[\e[0;31m\]"      # Red for non-zero return code
RESET="\[\e[0m\]"       # Reset color to default

# Function to set prompt dynamically
function set_prompt() {
    # Check the return code of the last command
    local ret_code=$?

    # Determine the color for the "$" symbol
    if [ $ret_code -ne 0 ]; then
        PROMPT_SYMBOL="${RED}\$"
    else
        PROMPT_SYMBOL="${RESET}\$"
    fi

    # Set the PS1 prompt
    PS1="${BLUE}\u@\h ${WHITE}\w${PURPLE} \$(parse_git_branch) ${PROMPT_SYMBOL} ${RESET} "
}
PROMPT_COMMAND=set_prompt;

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"

export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND+=';history -a'

export XDG_CONFIG_HOME="$HOME/.config"

# Syntax highlighting and completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
fi

# Git-aware PS1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"

# Reload the shell
alias so='source ~/.bashrc'
