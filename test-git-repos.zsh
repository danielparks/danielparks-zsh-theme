#!/usr/bin/env zsh

setopt err_exit pipe_fail

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

() (
  mkdir_cd empty
  git init --quiet
  print_prompt
)

() (
  mkdir_cd empty_dirty
  git init --quiet
  touch untracked
  print_prompt
)

() (
  mkdir_cd empty_add
  git init --quiet
  touch added
  git add added
  print_prompt
)

() (
  mkdir_cd empty_dirty_add
  git init --quiet
  touch added untracked
  git add added
  print_prompt
)
