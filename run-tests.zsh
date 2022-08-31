#!/usr/bin/env zsh

setopt err_exit pipe_fail

main () {
	local -a help keep show_output

	zparseopts -D -K -F -- \
		-show-output=show_output \
		-keep=keep \
		{h,-help}=help

	if [[ $? != 0 || -n $help ]] ; then
		echo "Usage: run-tests.zsh [--show-output] [--keep] [test-files]" >&2
		exit 1
	fi

	# Optionally accept paths to tests to run. Directories will be recursed into.
	local tests=($@)
	if [[ $#tests == 0 ]] ; then
		tests=(tests)
	fi

	local source_root=$(pwd)
	local working_root=$(mktemp -d)

	if [[ $keep ]] ; then
		echo "Running tests in $working_root"
	fi

	IFS=$'\n'
	for f in $(find $tests -type f) ; do
		run_test "$show_output" "$source_root" "$working_root" "$f"
	done

	if [[ ! $keep ]] ; then
		rm -rf $working_root
	fi
}

run_test () {
	local show_output=$1
	local source_root=${2:A}
	local working_root=${3:A}
	local test_file=$4

	mkdir -p $working_root/$test_file

	setopt local_options no_err_exit
	SHLVL=0 HOME=$working_root/$test_file SOURCE=$source_root TEST=$test_file \
	zsh -l <<-'EOF' &>$working_root/$test_file.out
		setopt err_exit
		cd $SOURCE
		source tests-utils.zsh
		local test_abs=${TEST:A}
		cd
		source "$test_abs"
		after_test
	EOF

	local code=$?
	if [[ $code != 0 ]] ; then
		echo Test $test_file failed with code $code:
		cat $working_root/$test_file.out | sed -e 's/^/  /'
		echo
	elif [[ $show_output ]] ; then
		echo Test $test_file succeeded:
		cat $working_root/$test_file.out
		echo
	fi
}

main "$@"
