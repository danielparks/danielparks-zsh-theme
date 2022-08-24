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

source danielparks-zsh-theme.plugin.zsh
print_prompt () {
	(
		_danielparks_theme_precmd
		print -P "${PROMPT}your-command here"
	) | sed -e 's/^/  /'
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
