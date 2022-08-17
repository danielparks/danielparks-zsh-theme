# Daniel’s ZSH theme

This is a simple two line (well, three if you count the blank) prompt for ZSH.
It is fast allows for plenty of space for commands. Additionally, it is easy to
copy and paste.

For speed, it uses [git-summary][] if available. It will warn you if it is not
present, but that can be disabled with an environment variable.

<img src="screenshot.png" width="525" height="484" alt="" />

See [EXAMPLE.md][] for a uncolored text version of the screenshot.

## What does it show?

  - Success (`✔`) or exit code (`=1`) of last command
  - If connected via SSH, user and host
  - Git status using [git-summary][] (if available)
    - Current branch, or SHA in detached HEAD state
    - Icons and color to indicate various states:
      | Icon | Color  | Meaning                            |
      |------|--------|------------------------------------|
      |      | Green  | clean tree; everything committed   |
      | `●`  | Yellow | only staged changes                |
      | `●`  | Red    | staged changes and untracked files |
      | `⦿`  | Red    | staged and unstaged changes        |
      | `○`  | Red    | only unstaged changes              |
      |      | Red    | only untracked files               |
      | `⚠️`  |        | merge conflict present             |
      | `↑N` |        | N commits ahead of upstream        |
      | `↓N` |        | N commits behind upstream          |
  - Working directory
  - Virtualenv
  - Current time when the prompt was generated
  - Wall time of last command if it took more than 0.1 seconds
  - Root privileges (`root❯`)
  - Level of shell (`$SHLVL`) by repeating `❯`

## Configuration

This warns if [git-summary][] is not installed. To suppress the message, set
`IGNORE_GIT_SUMMARY=1` before loading this plugin.

## Compatibility

To test your terminal and font support, try `echo "⚠️  ● ⦿ ○ ✔ ↑ ↓ ❯"`.

## License

This was originally based on [agnoster-zsh-theme][]. I believe I have replaced
enough of the code that it’s fair to say this is unencumbered by the original
copyright. (I am not a lawyer; consult a lawyer if this matters to you.)

That said, I disclaim all copyright on this work. It is provided without
warranty. As much as it can be said to be licensed, it is licensed under the
[Unlicense][], a copy of which is provided in [UNLICENSE](UNLICENSE).

[git-summary]: https://github.com/danielparks/git-summary
[EXAMPLE.md]: EXAMPLE.md
[agnoster-zsh-theme]: https://github.com/agnoster/agnoster-zsh-theme
[Unlicense]: https://unlicense.org
