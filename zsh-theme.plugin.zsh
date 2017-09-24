# Original theme https://github.com/agnoster/agnoster-zsh-theme

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
# https://github.com/sindresorhus/pretty-time-zsh
_agnoster_human_time() {
  local total_seconds=$1
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))
  (( days > 0 )) && print -n "${days}d "
  (( hours > 0 )) && print -n "${hours}h "
  (( minutes > 0 )) && print -n "${minutes}m "
  print "${seconds}s"
}

_git_info () {
  # This will fail outside of a git working tree
  local untracked_files git_dirty='' fg_color

  untracked_files=$(git ls-files --other --exclude-standard 2>/dev/null)

  if [ $? = 0 ] ; then
    fg_color=green

    if ! command git diff --quiet --ignore-submodules HEAD &>/dev/null ; then
      git_dirty=' ⚙'
      fg_color=yellow
    fi

    if [ ! -z "$untracked_files" ] ; then
      fg_color=red
    fi

    ref=$(git symbolic-ref HEAD 2>/dev/null) ||
      ref="$(git show-ref --head -s --abbrev HEAD |head -n1 2>/dev/null)"
    print -Pn " %F{$fg_color}${ref/refs\/heads\//}${git_dirty}%f"
  fi
}

_virtualenv_info () {
  [ $venv_name ] && print -n " ($venv_name)"
}

_agnoster_precmd () {
  local last_status=$?

  # Build up string so that it all appears at once
  local preprompt=$'\n'

  if [ $last_status = 0 ] ; then
    preprompt+='%f%k%B%F{green}✔%f'
  else
    preprompt+='%f%k%B%F{red}✘%f'
  fi

  preprompt+=' %F{blue}%n@%m%f' # user@host
  preprompt+=$(_git_info)

  preprompt+=' %F{white}%~%f' # directory
  preprompt+=' %F{blue}%D{%L:%M:%S %p}%f' # time
  preprompt+=$(_virtualenv_info)

  local startseconds=${_agnoster_preexec_timestamp:-$EPOCHSECONDS}
  integer elapsed
  (( elapsed = EPOCHSECONDS - startseconds ))

  if (( elapsed > 5 )) ; then
    preprompt+=" %F{yellow}$(_agnoster_human_time $elapsed)%f"
  fi

  print -P $preprompt
}

_agnoster_preexec () {
  _agnoster_preexec_timestamp=$EPOCHSECONDS
}

() {
  zmodload zsh/datetime
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd _agnoster_precmd
  add-zsh-hook preexec _agnoster_preexec

  PROMPT='%(!.%F{yellow}⚡⚡⚡ .)❯%f%k%b '
}
