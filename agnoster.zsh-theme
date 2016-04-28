# Original theme https://github.com/agnoster zsh theme

ZSH_THEME_GIT_PROMPT_DIRTY='⚙ '

function _git_info() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    local git_dirty=$(parse_git_dirty)
    local FG_COLOR=green
    if [[ -n "$git_dirty" ]]; then
      FG_COLOR=yellow
    fi

    if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        FG_COLOR=red
    fi


    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="$(git show-ref --head -s --abbrev HEAD |head -n1 2> /dev/null)"
    echo "%F{$FG_COLOR}%B${git_dirty}${ref/refs\/heads\//}%f%b"
  else
    echo ""
  fi
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function set_prompt {
  local exit_code='%(?.%F{green}✔.%F{red}✘)%f'
  local user='%F{blue}%n@%m%f'
  local directory='%B%F{white}%~%f%b'
  local su='%(!.%F{black}%K{yellow} ⚡ .)'
  local time='%F{blue}%D{%L:%M:%S %p}%f'

  PROMPT="
%f%k%b$exit_code $user "'$(_git_info)'" $directory $time
"'$(virtualenv_info)'"$su❯%f%k%b "
  RPROMPT=
}

set_prompt
