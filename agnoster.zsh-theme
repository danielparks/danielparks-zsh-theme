# Original theme https://github.com/agnoster zsh theme

ZSH_THEME_GIT_PROMPT_DIRTY='±'

function _git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="$(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
  echo "${ref/refs\/heads\//}$(parse_git_dirty)"
}

function _git_info() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local FG_COLOR=green
    if [[ -n $(parse_git_dirty) ]]; then
      FG_COLOR=yellow
    fi

    if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        FG_COLOR=red
    fi
    echo "%{%F{$FG_COLOR}%} $(_git_prompt_info) %{%F{$BG_COLOR}"
  else
    echo ""
  fi
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT_HOST='%{%b%F{gray}%} %(?.%{%F{green}%}✔.%{%F{red}%}✘)%{%F{yellow}%} %n %{%F{black}%}'
PROMPT_DIR='%{%F{white}%} %~%  '
PROMPT_SU='%(!.%{%F{blue}%}⮀%{%F{yellow}%} ⚡ %{%F{black}%}.%{%F{blue}%})%{%f%b%}'

PROMPT='%{%f%b%}$PROMPT_HOST($(_git_info))$PROMPT_DIR$PROMPT_SU
$(virtualenv_info)❯ '
RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
