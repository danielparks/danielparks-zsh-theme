#!/usr/bin/env zsh

main () {
	# Optionally accept paths to tests to run. Directories will be recursed into.
	local tests=($@)
	if [[ $#tests == 0 ]] ; then
		tests=(tests)
	fi

	local source_root=$(pwd)
	local working_root=$(mktemp -d)

	IFS=$'\n'
	for f in $(find $tests -type f) ; do
		run_test $source_root $working_root $f
	done
}

run_test () {
	local source_root=${1:A}
	local working_root=${2:A}
	local test_file=$3

	mkdir -p $working_root/$test_file
	SHLVL=0 HOME=$working_root/$test_file SOURCE=$source_root TEST=$test_file \
zsh -l <<'EOF'
	setopt extended_glob err_exit pipe_fail
	cd $SOURCE
	source tests-utils.zsh
	local test_abs=${TEST:A}
	cd
	source "$test_abs"
EOF
	local code=$?
	if [[ $code != 0 ]] ; then
		echo Error exit: $code
	fi
}

main "$@"
