HISTFILE=~/.history
SAVEHIST=10000000
HISTSIZE=10000000

# Don't overwrite, append!
setopt APPEND_HISTORY
# Write after each command
# setopt INC_APPEND_HISTORY
# Killer: share history between multiple shells
setopt SHARE_HISTORY
# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS
# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
