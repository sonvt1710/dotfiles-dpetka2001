#     ╭────────────────────────────────────────────────────────────────────╮
#     │             Set length for prompt directory components             │
#     ╰────────────────────────────────────────────────────────────────────╯
# NOTE: No need for this since we use `tide`

# set -g fish_prompt_pwd_dir_length 2

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                       Set EDITOR and VISUAL                        │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx EDITOR nvim
set -gx VISUAL nvim

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                           Configure fzf                            │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx FZF_DEFAULT_COMMAND "rg --files"
set -gx FZF_DEFAULT_OPTS "--layout=reverse --bind='ctrl-r:reload(rg --hidden --files)' --header='"Press CTRL-R to reload\n\n"' --border -m \
--bind 'ctrl-v:execute(nvim {+})' --bind 'ctrl-d:reload(find . -type d)'"
# set -gx FZF_CTRL_T_COMMAND "rg --files"
set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"

#     ╭────────────────────────────────────────────────────────────────────╮
#     │         Avoid loading ranger default config more than once         │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx RANGER_LOAD_DEFAULT_RC FALSE

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                             Set locale                             │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx LC_CTYPE en_US.UTF-8
set -gx LC_NUMERIC en_US.UTF-8

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                          Change MANPAGER                           │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -gx TZ ":Europe/Athens"

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                Set notification duration for `done`                │
#     ╰────────────────────────────────────────────────────────────────────╯
set -U __done_notification_duration 60000 # 5 seconds
set -U __done_notification_command "notify-send --hint=int:transient:1 --urgency=\$urgency --icon=utilities-terminal --app-name=fish --expire-time=\$__done_notification_duration \$title \$message"

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                          Extend $MANPATH                           │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx MANPATH $MANPATH ~/share/man

#     ╭────────────────────────────────────────────────────────────────────╮
#     │              Start ssh-agent when starting fish shell              │
#     ╰────────────────────────────────────────────────────────────────────╯
fish_ssh_agent

#     ╭────────────────────────────────────────────────────────────────────╮
#     │                        Set XDG directories                         │
#     ╰────────────────────────────────────────────────────────────────────╯
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
