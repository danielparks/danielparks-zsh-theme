# Daniel’s ZSH theme

This is a simple two line (well, three if you count the blank) prompt for ZSH.
It is fast, allows for plenty of space to type commands, and looks good when
copied and pasted.

If [git-status-vars][] is available, it will use it to get better information
about git repos, as well as a slight edge in speed. It will warn you if it is
not present, but that can be disabled by setting `IGNORE_GIT_STATUS_VARS=1`
before loading this plugin.

<img src="screenshot.png" width="525" height="484" alt="" />

See [EXAMPLE.md][] for a uncolored text version of the screenshot.

## What does it show?

  - Success (`✔`) or exit code (`=1`) of last command
  - If connected via SSH, user and host
  - Git status using [git-status-vars][] if available, or straight `git` (some
    features will be disabled, e.g. no commits ahead/behind).
    - Current branch, or SHA in detached HEAD state
    - If an operation such as a merge, rebase, or cherry pick is in progress
    - How many stashed changes there are
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

### `git-status-vars` check

You can set `IGNORE_GIT_STATUS_VARS=1` to disable the check for
[git-status-vars][] on start up. Note that this will still use `git-status-vars`
if it is present in `$PATH`.

### Theme variants: `full`, `compact`, and `minimal`

You can set `danielparks_theme=compact` to get a compact version of the theme.
This is useful for situations where you want to copy and paste your shell.
It may be set and unset during the shell session. Set `danielparks_theme=full`
or just `unset` the variable to restore the full theme.

You can set `danielparks_theme=minimal` to get an even more minimal version of
the theme that just shows `✔` or `✘` as the prompt depending on whether the last
command succeeded or failed.

### Custom prefix and suffix for prompt

There are three variables you can use to customize the prompt:

  - `$danielparks_full_prefix`: Printed at the start the first non-blank line
    of the prompt. For `minimal` and `compact` this is immediately before
    `$danielparks_prompt_prefix`.
  - `$danielparks_prompt_prefix`: Printed at the start of the line that accepts
    user input.
  - `$danielparks_prompt_suffix`: Printed at the end of the prompt, right before
    user input.

A visualization:

    FULL_PREFIX✔ ~ 11:13:47 AM
    PROMPT_PREFIX❯ PROMPT_SUFFIXyour-command here

## Compatibility

To test your terminal and font support, try `echo "⚠️  ● ⦿ ○ ✔ ↑ ↓ ❯"`.

### iTerm2 shell integration

If [iTerm2 shell integration][] is detected the custom prefix variables will be
automatically set to record marks and the end of the prompt.

This will not overwrite existing variables, so if they have some other value you
may need to modify them:

		danielparks_full_prefix="$(iterm2_prompt_mark)FULL_PREFIX"
		danielparks_prompt_suffix="PROMPT_SUFFIX$(iterm2_prompt_end)"

## Testing

This can be used with my [simple Zsh test harness][zsh-test-harness]. You can
run tests with `run-tests.zsh`, and if you want to see what prompts looks like
in various situations, you can run `run-tests.zsh --show-output`.

## Development status

I’ll update this as I come up with new ideas or run into problems. I use this
theme daily, so it’s unlikely to  bit rot. I’m open to [suggestions][issues]
and [pull requests][prs] if other people find this useful.

## License

This was originally based on [agnoster-zsh-theme][]. I believe I have replaced
enough of the code that it’s fair to say this is unencumbered by the original
copyright. (I am not a lawyer; consult a lawyer if this matters to you.)

That said, I disclaim all copyright on this work. It is provided without
warranty. As much as it can be said to be licensed, it is licensed under the
[Unlicense][], a copy of which is provided in [UNLICENSE](UNLICENSE).

[git-status-vars]: https://github.com/danielparks/git-status-vars
[EXAMPLE.md]: EXAMPLE.md
[[iTerm2 shell integration]: https://iterm2.com/documentation-shell-integration.html
[zsh-test-harness]: https://github.com/danielparks/zsh-test-harness
[issues]: https://github.com/danielparks/danielparks-zsh-theme/issues
[prs]: https://github.com/danielparks/danielparks-zsh-theme/pulls
[agnoster-zsh-theme]: https://github.com/agnoster/agnoster-zsh-theme
[Unlicense]: https://unlicense.org
