setopt prompt_subst
setopt promptpercent

autoload colors
colors

autoload -Uz vcs_info
#zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

local zcock_emo=""
precmd_vcs_info() {
    vcs_info
}

zcock_update() {
    zcock_emo="$(zcock)"
}

precmd_functions+=( precmd_vcs_info zcock_update )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "- %{$fg[green]%}[%b]%{$reset_color%}"

local current_dir='%{$fg[cyan]%}%3c%{$reset_color%}'
local return_code="%(?..%{$fg[red]%}%? ⚑%{$reset_color%}) $(echo -ne "\0")"
local git_info='${vcs_info_msg_0_}'

zcock_update

RPROMPT="${current_dir} ${git_info} ${return_code}"
if [ "$EUID" = "0" ] || [ "$USER" = "root" ] ; then
	PROMPT=$'\n'"$(echo -ne ${zcock_emo}) %{$fg_bold[black]%}@%M%{$reset_color%} %(1j.[%j] .)%{$fg_bold[yellow]%}❱%{$reset_color%} "
else
	PROMPT=$'\n'"$(echo -ne ${zcock_emo}) %{$fg_bold[black]%}@%M%{$reset_color%} %(1j.[%j] .)%{$fg_bold[blue]%}❱%{$reset_color%} "
fi

