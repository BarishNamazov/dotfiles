#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- helpers ---------------------------------------------------------------

# Safely append a command to PROMPT_COMMAND
__append_prompt_command() {
    if [ -z "$PROMPT_COMMAND" ]; then
        PROMPT_COMMAND="$1"
    else
        PROMPT_COMMAND="$PROMPT_COMMAND;$1"
    fi
}

# Finds nearest .venv directory upward from $PWD
__find_nearest_venv() {
    local p="$PWD"
    while [ "$p" != "/" ]; do
        if [ -d "$p/.venv" ] && [ -f "$p/.venv/bin/activate" ]; then
            printf "%s/.venv" "$p"
            return 0
        fi
        p="$(dirname "$p")"
    done
    return 1
}

# Auto-activate/deactivate Python venvs named ".venv"
__auto_venv() {
    local target
    if target="$(__find_nearest_venv)"; then
        if [ -z "$VIRTUAL_ENV" ] || [ "$VIRTUAL_ENV" != "$target" ]; then
            # shellcheck source=/dev/null
            . "$target/bin/activate" >/dev/null 2>&1
        fi
    else
        if [ -n "$VIRTUAL_ENV" ] && type deactivate >/dev/null 2>&1; then
            deactivate >/dev/null 2>&1
        fi
    fi
}

# --- setup blocks ----------------------------------------------------------

setup_aliases() {
    alias ls='ls --color=auto'
    alias ll='ls -alF'

    # Git helpers
    alias gpom='git pull origin main'
    alias gpob='git push origin "$(git rev-parse --abbrev-ref HEAD)"'

    # Reload the shell
    alias so='source ~/.bashrc'

    alias vim=nvim
    alias v=nvim
}

setup_prompt_helpers() {
    # Updated PS1 with branch in brackets, shown only in Git repos
    parse_git_branch() {
        git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/(/;s/$/)/'
    }
}

setup_colors() {
    # Color Variables
    BLUE="\[\e[0;34m\]"     # Blue for username and host
    WHITE="\[\e[0;37m\]"    # White for the working directory
    PURPLE="\[\e[0;35m\]"   # Purple for Git branch
    RED="\[\e[0;31m\]"      # Red for non-zero return code
    RESET="\[\e[0m\]"       # Reset color to default
}

setup_prompt() {
    # Function to set prompt dynamically
    set_prompt() {
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

    # Exactly as before: base PROMPT_COMMAND is set_prompt
    PROMPT_COMMAND=set_prompt
}

setup_path() {
    export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
    export PATH="$PATH:/usr/local/bin:/usr/local/sbin"
    export PATH="$HOME/.npm-global/bin:$PATH"
}

setup_history() {
    export HISTSIZE=
    export HISTFILESIZE=
    export HISTCONTROL=ignoreboth:erasedups
    shopt -s histappend
    __append_prompt_command 'history -a'

    # Added: show timestamps in history (non-invasive)
    export HISTTIMEFORMAT='%F %T  '
}

setup_xdg() {
    export XDG_CONFIG_HOME="$HOME/.config"
}

setup_completion() {
    # Syntax highlighting and completion
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        # shellcheck source=/dev/null
        . /usr/share/bash-completion/bash_completion
    fi

    if [ -f /usr/share/fzf/key-bindings.bash ]; then
        # shellcheck source=/dev/null
        source /usr/share/fzf/key-bindings.bash
        # shellcheck source=/dev/null
        source /usr/share/fzf/completion.bash
    fi

    # Added: lesspipe for smarter `less` if available
    if command -v lesspipe >/dev/null 2>&1; then
        eval "$(SHELL=/bin/sh lesspipe)"
    fi
}

setup_git_ps1() {
    # Git-aware PS1 flags (unchanged)
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWUPSTREAM="auto"
}

setup_python_env() {
    # Added: auto-activate local .venv on directory change via PROMPT_COMMAND
    __append_prompt_command '__auto_venv'
}

# --- run setup -------------------------------------------------------------

setup_aliases
setup_prompt_helpers
setup_colors
setup_prompt
setup_path
setup_history
setup_xdg
setup_completion
setup_git_ps1
setup_python_env
