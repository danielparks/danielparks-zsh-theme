# Disable git configuration
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

fail () {
	echo "$1" >&2
	exit ${2:-1}
}

check_arguments () {
	local func=$1
	local expected=$2
	shift ; shift
	if [[ $# != $expected ]] ; then
		print "$func expected $expected arguments but got $#:" >&2
		printf "  %s\n" ${(q+)@} >&2
		exit 1
	fi
}

assert_eq () {
	check_arguments assert_eq 2 "$@"
	if [[ "$1" != "$2" ]] ; then
		fail "Not equal:\n  actual:   ${(q+)1}\n  expected: ${(q+)2}"
	fi
}

assert_prompt_eq () {
	check_arguments assert_prompt_eq 2 "$@"
	assert_eq $1 ${(%%)2}
}

source danielparks-zsh-theme.plugin.zsh
after_test () {
	(
		_danielparks_theme_precmd
		print -P "${PROMPT}your-command here"
	) | sed -e 's/^/  /'
}

assert_git_info_eq () {
	check_arguments assert_git_info_eq 1 "$@"
	assert_eq "$(_danielparks_theme_git_info escape)" "$1"
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
