#!/usr/bin/env zsh

setopt err_exit pipe_fail

# Disable git configuration
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

source danielparks-zsh-theme.plugin.zsh
print_prompt () {
  (
    _danielparks_theme_precmd
    print -P "${PROMPT}your-command here"
  ) | sed -e 's/^/  /'
}

local root=$(pwd)/test-repos
rm -rf "$root"

mkdir_cd () {
  mkdir -p ${root}/"$@"
  cd ${root}/"$@"
}

cd_repo () {
  cd ${root}/"$@"
}

create_cd_repo () {
  mkdir_cd "$@"
  git init --quiet
}

clone_cd_repo () {
  mkdir -p ${root}
  git clone --quiet "${root}/$1" "${root}/$2"
  cd "${root}/$2"
}

() (
  create_cd_repo empty
  print_prompt
)

() (
  create_cd_repo empty_dirty
  touch untracked
  print_prompt
)

() (
  create_cd_repo empty_add
  touch added
  git add added
  print_prompt
)

() (
  create_cd_repo empty_dirty_add
  touch added untracked
  git add added
  print_prompt
)

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

() (
  create_cd_repo commit
  change_files_then_commit a b
  print_prompt
)

() (
  create_cd_repo commit_modified
  change_files_then_commit a b
  date >a
  print_prompt
)

() (
  create_cd_repo commit_modified_staged
  change_files_then_commit a b
  date >a
  git add a
  print_prompt
)

() (
  create_cd_repo commit_deleted
  change_files_then_commit a b
  rm a
  print_prompt
)

() (
  create_cd_repo commit_deleted_staged
  change_files_then_commit a b
  git rm --quiet a
  print_prompt
)

() (
  create_cd_repo branch
  change_files_then_commit a b
  git checkout --quiet -b branch
  print_prompt
)

() (
  create_cd_repo ahead_1_upstream
  change_files_then_commit a b
  clone_cd_repo ahead_1_upstream ahead_1
  change_files_then_commit a
  print_prompt
)

() (
  create_cd_repo behind_1_upstream
  change_files_then_commit a b
  clone_cd_repo behind_1_upstream behind_1
  cd_repo behind_1_upstream
  change_files_then_commit a
  cd_repo behind_1
  git fetch --quiet
  print_prompt
)

() (
  create_cd_repo ahead_1_behind_1_upstream
  change_files_then_commit a b
  clone_cd_repo ahead_1_behind_1_upstream ahead_1_behind_1
  cd_repo ahead_1_behind_1_upstream
  change_files_then_commit a
  cd_repo ahead_1_behind_1
  change_files_then_commit a
  git fetch --quiet
  print_prompt
)

() (
  create_cd_repo conflict_upstream
  change_files_then_commit a b
  clone_cd_repo conflict_upstream conflict
  cd_repo conflict_upstream
  change_files_then_commit a
  cd_repo conflict
  change_files_then_commit a
  git fetch --quiet
  git merge origin/master &>/dev/null || true
  print_prompt
)
