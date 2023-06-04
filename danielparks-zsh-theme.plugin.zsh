# Convert seconds into human readable time: 165392.3129 => 1d 21h 56m 32s
# Based on https://github.com/sindresorhus/pretty-time-zsh
_danielparks_theme_humanize_interval () {
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
	else
		printf "%0.1fs" $seconds
	fi
}

_danielparks_theme_git_info_fallback () {
	local gitstatus icons='' fg_color=green

	gitstatus=$(git status --porcelain=1 2>/dev/null) || return 0

	if echo $gitstatus | grep --quiet '^.[^ ?!]' ; then
		# Unstaged changes
		if echo $gitstatus | grep --quiet '^[^ ?!]' ; then
			# Staged changes
			icons+=' %1{⦿%}'
		else
			icons+=' %1{○%}'
		fi
		fg_color=red
	elif echo $gitstatus | grep --quiet '^[^ ?!]' ; then
		# Staged changes
		icons+=' %1{●%}'
		fg_color=yellow
	fi

	if echo $gitstatus | fgrep --quiet '??' ; then
		# Untracked changes
		fg_color=red
	fi

	ref=$(git symbolic-ref --short HEAD 2>/dev/null) ||
		ref=$(git show-ref --head -s --abbrev HEAD 2>/dev/null | head -n1)
	print -n " %F{$fg_color}${ref}${icons}%f"
}

_danielparks_theme_git_info () {
	eval $(git-status-vars 2>/dev/null)

	if [[ -z $repo_state ]] ; then
		# git-status-vars should always output repo_state
		_danielparks_theme_git_info_fallback
		return 0
	fi

	if [[ $repo_state == "NotFound" ]] ; then
		return 0
	fi

	local icons='' fg_color=green
	if [[ $unstaged_count > 0 ]] ; then
		if [[ $staged_count > 0 ]] ; then
			icons+=' %1{⦿%}'
		else
			icons+=' %1{○%}'
		fi
		fg_color=red
	elif [[ $staged_count > 0 ]] ; then
		icons+=' %1{●%}'
		fg_color=yellow
	fi

	if [[ $conflicted_count > 0 ]] ; then
		icons+=' %1{⚠️%} '
	fi

	if [[ $untracked_count > 0 ]] ; then
		fg_color=red
	fi

	local ref=$head_ref1_short
	if [[ -z $ref ]] ; then
		ref=${head_hash:0:8}
	fi

	print -n " %F{$fg_color}${ref}${icons}%f"

	if [[ $repo_state != "Clean" ]] ; then
		# Convert "CamelCase" string to "camel case" (space separated).
		local words=$(sed -e 's/\([a-z]\)\([A-Z]\)/\1 \2/g' <<<$repo_state)
		print -n " %F{red}(${words:l})%f"
	fi

	fg_color=yellow
	if [[ $head_ahead > 0 && $head_behind > 0 ]] ; then
		fg_color=red
	fi

	if [[ $head_ahead > 0 ]] ; then
		print -n " %F{${fg_color}}%1{↑%}${head_ahead}%f"
	fi

	if [[ $head_behind > 0 ]] ; then
		print -n " %F{${fg_color}}%1{↓%}${head_behind}%f"
	fi
}

_danielparks_theme_virtualenv_info () {
	[ $VIRTUAL_ENV ] && print -n " (${VIRTUAL_ENV:t})" || true
}

_danielparks_theme_precmd () {
	local last_status=$?

	local startseconds=${_danielparks_theme_preexec_timestamp:-$EPOCHREALTIME}
	float elapsed
	(( elapsed = EPOCHREALTIME - startseconds ))
	_danielparks_theme_preexec_timestamp=

	# Build up string to prepend to $PROMPT (just printing it won’t work if it
	# doesn’t end with a newline — zsh clears the line when it prints $PROMPT).
	_danielparks_theme_preprompt=

	if [[ $danielparks_theme != compact ]] ; then
		# Blank line before prompt.
		_danielparks_theme_preprompt=$'\n'

		if [[ $danielparks_theme != full && $danielparks_theme != '' ]] ; then
			_danielparks_theme_preprompt+='%B%F{red}Invalid setting for'
			_danielparks_theme_preprompt+=' $danielparks_theme ('$danielparks_theme
			_danielparks_theme_preprompt+='), expected one of "full", "compact", or'
			_danielparks_theme_preprompt+=$' "".%f%b\n\n'
		fi
	fi

	if [ $last_status = 0 ] ; then
		_danielparks_theme_preprompt+='%f%k%B%F{green}%1{✔%}%f'
	else
		_danielparks_theme_preprompt+="%f%k%B%F{red}=${last_status}%f"
	fi

	if [[ $SSH_CONNECTION ]] ; then
		_danielparks_theme_preprompt+=' %F{yellow}%n@%m%f' # user@host
	fi

	if [[ $danielparks_theme != compact ]] ; then
		_danielparks_theme_preprompt+=$(_danielparks_theme_git_info)
	fi

	_danielparks_theme_preprompt+=' %F{white}%~%f' # directory

	if [[ $danielparks_theme != compact ]] ; then
		_danielparks_theme_preprompt+=' %F{blue}%D{%L:%M:%S %p}%f' # time
		_danielparks_theme_preprompt+=$(_danielparks_theme_virtualenv_info)

		if (( elapsed > 0.05 )) ; then
			_danielparks_theme_preprompt+=" %F{yellow}$(_danielparks_theme_humanize_interval $elapsed)%f"
		fi

		_danielparks_theme_preprompt+=$'\n'
	fi

	# Output invisible information for terminal title.
	if [[ $SSH_CONNECTION ]] ; then
		_danielparks_theme_preprompt+=$'\e]2;%n@%m %~\a'
	else
		_danielparks_theme_preprompt+=$'\e]2;%~\a'
	fi

	PROMPT="${_danielparks_theme_preprompt}${_danielparks_theme_prompt}"
}

_danielparks_theme_preexec () {
	_danielparks_theme_preexec_timestamp=$EPOCHREALTIME
}

() {
	zmodload zsh/datetime
	autoload -Uz add-zsh-hook

	add-zsh-hook precmd _danielparks_theme_precmd
	add-zsh-hook preexec _danielparks_theme_preexec

	# 'root' if running as root. As many ❯ as $SHLVL.
	local prompt_chars=$(repeat $SHLVL print -Pn '%1{❯%}')
	_danielparks_theme_prompt="%(!.%F{yellow}root.)${prompt_chars}%f%k%b "
	PROMPT="$_danielparks_theme_prompt"

	if [[ -z $IGNORE_GIT_SUMMARY && -z $IGNORE_GIT_STATUS_VARS ]] \
			&& ! command -v git-status-vars &>/dev/null ; then
		print -Pn '%B%F{red}git-status-vars not installed.%f%b Run' >&2
		print -Pn ' `cargo install git-status-vars` or visit' >&2
		print -Pn ' https://github.com/danielparks/git-status-vars#installation' >&2
		print -Pn ' for instructions. Set IGNORE_GIT_STATUS_VARS=1 to suppress' >&2
		print -P ' this message.' >&2
	fi
}
