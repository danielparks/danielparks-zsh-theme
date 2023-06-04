# Ensure we only use our git configuration. ($HOME is a temporary directory.)
export GIT_CONFIG_GLOBAL=$HOME/.gitconfig GIT_CONFIG_SYSTEM=/dev/null

# Disable warning message about git-status-vars
export IGNORE_GIT_STATUS_VARS=1

# GitHub actions fail if these are not set.
git config --global user.email "null@example.com"
git config --global user.name "Test Runner"

source danielparks-zsh-theme.plugin.zsh
after_test () {
	(
		_danielparks_theme_precmd 2>&1
		print -P "${PROMPT}your-command here"
	) | sed -e 's/^/  /'
}

assert_prompt_eq () {
	check_arguments assert_preprompt_eq 1 "$@"
	assert_eq "$(_danielparks_theme_precmd 2>&1)" ""
	_danielparks_theme_precmd 2>&1 >/dev/null
	assert_eq "$PROMPT" "$1"
}

assert_git_info_eq () {
	check_arguments assert_git_info_eq 1 "$@"
	assert_eq "$(_danielparks_theme_git_info 2>&1)" "$1"
}

assert_git_info_fallback_eq () {
	check_arguments assert_git_info_fallback_eq 1 "$@"
	assert_eq "$(_danielparks_theme_git_info_fallback 2>&1)" "$1"
}

mkdir_cd () {
	check_arguments mkdir_cd 1 "$@"
	mkdir -p $1
	cd $1
}

cd_repo () {
	check_arguments cd_repo 1 "$@"
	cd ~/$1
}

create_cd_repo () {
	check_arguments create_cd_repo 1 "$@"
	mkdir_cd ~/"$1"
	git init --quiet
}

clone_cd_repo () {
	check_arguments clone_cd_repo 2 "$@"
	cd
	git clone --quiet "$1" "$2"
	cd "$2"
}

change_files_then_commit () {
	for file in "$@" ; do
		echo $EPOCHREALTIME >$file
	done
	git add "$@"
	git commit --quiet -m "Modified: $*"
}

make_commit_repo () {
	git init --quiet
	change_files_then_commit a b
}
