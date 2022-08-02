# Original theme https://github.com/agnoster/agnoster-zsh-theme

# turns (fractional) seconds into human readable time
# 165392.3129 => 1d 21h 56m 32s
# Based on https://github.com/sindresorhus/pretty-time-zsh
_agnoster_human_time() {
  float total_seconds=$1
  integer days=$(( total_seconds / 60 / 60 / 24 ))
  integer hours=$(( total_seconds / 60 / 60 % 24 ))
  integer minutes=$(( total_seconds / 60 % 60 ))
  float seconds=$(( total_seconds % 60 ))

  (( days > 0 )) && print -n "${days}d "
  (( hours > 0 )) && print -n "${hours}h "
  (( minutes > 0 )) && print -n "${minutes}m "

  if (( total_seconds > 10 )) ; then
    printf "%0.0fs" $seconds
  elif (( total_seconds > 1.5 )) ; then
    printf "%0.1fs" $seconds
  else
    printf "%0.2fs" $seconds
  fi
}

_git_info () {
  # This will fail outside of a git working tree
  local untracked_files git_dirty='' fg_color

  untracked_files=$(git ls-files --other --exclude-standard 2>/dev/null)

  if [ $? = 0 ] ; then
    fg_color=green

    if ! command git diff --quiet --ignore-submodules HEAD &>/dev/null ; then
      git_dirty=' %1{⚙%}'
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
  [ $VIRTUAL_ENV ] && print -n " (${VIRTUAL_ENV:t})"
}

_agnoster_precmd () {
  local last_status=$?

  # Build up string so that it all appears at once
  local preprompt=$'\n'

  if [ $last_status = 0 ] ; then
    preprompt+='%f%k%B%F{green}%1{✔%}%f'
  else
    preprompt+='%f%k%B%F{red}%1{✘%}%f'
  fi

  if [ $SSH_CONNECTION ] ; then
    preprompt+=' %F{yellow}%n@%m%f' # user@host
  fi

  preprompt+=$(_git_info)
  preprompt+=' %F{white}%~%f' # directory
  preprompt+=' %F{blue}%D{%L:%M:%S %p}%f' # time
  preprompt+=$(_virtualenv_info)

  local startseconds=${_agnoster_preexec_timestamp:-$EPOCHREALTIME}
  float elapsed
  (( elapsed = EPOCHREALTIME - startseconds ))
  _agnoster_preexec_timestamp=

  if (( elapsed > 1 )) ; then
    preprompt+=" %F{yellow}$(_agnoster_human_time $elapsed)%f"
  fi

  print -P $preprompt

  if [ $SSH_CONNECTION ] ; then
    print -Pn "\e]2;%n@%m %~\a"
  else
    print -Pn "\e]2;%~\a"
  fi
}

_agnoster_preexec () {
  _agnoster_preexec_timestamp=$EPOCHREALTIME
}

() {
  zmodload zsh/datetime
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd _agnoster_precmd
  add-zsh-hook preexec _agnoster_preexec

  PROMPT='%(!.%F{yellow}root.)%1{❯%}%f%k%b '
}
