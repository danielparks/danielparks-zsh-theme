# Disable git configuration
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null

fail () {
  echo "$1" >&2
  exit ${2:-1}
}

source danielparks-zsh-theme.plugin.zsh
print_prompt () {
  (
    _danielparks_theme_precmd
    print -P "${PROMPT}your-command here"
  ) | sed -e 's/^/  /'
}

mkdir_cd () {
  [[ $# > 1 ]] && fail "Expected 1 argument to mkdir_cd, got: $*"
  mkdir -p $1
  cd $1
}

cd_repo () {
  [[ $# > 1 ]] && fail "Expected 1 argument to cd_repo, got: $*"
  cd ~/$1
}

create_cd_repo () {
  [[ $# > 1 ]] && fail "Expected 1 argument to create_cd_repo, got: $*"
  mkdir_cd ~/"$1"
  git init --quiet
}

clone_cd_repo () {
  [[ $# != 2 ]] && fail "Expected 2 arguments to clone_cd_repo, got: $*"
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
