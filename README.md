# My fork of agnoster.zsh-theme

~~~
✔ master ⚙ ~/work/simplepup 10:25:31 PM (simplepup)
❯ ssh vm1.oxidized.org

✔ daniel@vm1 master ~ 10:25:40 PM
❯
~~~

## What does it show?

- Success (✔) or failure (✘) of previous command
- If connected via SSH, user and host
- Git status
  - Current branch, or sha in detached HEAD state
  - Dirty working directory (⚙, color change)
- Working directory
- Wall time
- Virtualenv
- Wall time of last command if it took more than 5 seconds
- Root privileges (root❯)

## Compatibility

To test if your terminal and font support, try `echo "⚙ ✔ ✘ ⚡"`.
