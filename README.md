# MINIMAL
A minimal zsh theme.

# Screencast

[![screencast](https://asciinema.org/a/6awagm3y3ylut6vo6fauu3j4c.png)](https://asciinema.org/a/6awagm3y3ylut6vo6fauu3j4c)

# Installation
[Zgen](https://github.com/tarjoilija/zgen):
```
zgen load subnixr/minimal
```

[Antigen](https://github.com/zsh-users/antigen):
```
antigen theme subnixr/minimal
```

Otherwise, you can always clone the repo and source `minimal.zsh`.

# Description
A prompt with all features:
```
minimal_env minimal_ssh_hostname λ ›                Workspace/sample minimal_vcs
```
On the left:

- `minimal_env` output (see *functions* section)
- `minimal_ssh_hostname` output (see *functions* section)
- `λ` is shown if you are a normal user. When root, a classic `#` will be shown
instead.
- `λ` will be `$MINIMAL_OK_COLOR` if the last command exited successfully, 
otherwise will be red.
- `λ` will be underlined if you have jobs in background.
- `›` will be show if you are in insert (default) mode. If using vimode, `·` 
is shown when in normal mode.

On the right:

- The last `$MINIMAL_PWD_LEN` segments of `pwd` are shown. If a segment is 
longer than `$MINIMAL_PWD_CHAR_LEN` chars, it will be elided. If you are near 
the root (eg: `/usr/bin`) the first slash will be shown.
- `minimal_vcs` output (see *functions* section)

# Magic Enter
You may miss some info from your prompt: magic enter to the rescue!
```
λ › [subnixr@lambda-arch:~] [12 (90)] [1&] [1]                                 ~
  | Desktop    Downloads  GBA   Music  Pictures  Videos
  | Documents  Dropbox    MAME  Phone  Public    Workspace
```
If your buffer is empty, pressing enter will print some useful informations:

- Username, hostname and full `pwd`.
- Number of visible files, number of total files.
- Number of background jobs (if any).
- Exit code of last command (if exited with non-zero)
- `minimal_magic_output` output (see *functions* section)

# Configuration
Declarations must be done **before** sourcing `minimal.zsh`, except for 
*parameters*.

## Features
These variables are read when sourcing.

- `MINIMAL_PROMPT`: left prompt (default: active).
- `MINIMAL_RPROMPT`: right prompt (default: active, doesn't apply if 
`MINIMAL_PROMPT` isn't enabled).
- `MINIMAL_SSH_HOSTNAME`: show hostname when connected through ssh (default: active).
- `MINIMAL_MAGIC_ENTER`: magic enter (default: active).

To disable a feature, just set it to something other than `yes` before sourcing.

Example:
```
MINIMAL_MAGIC_ENTER="I Don't want this"
source /path/to/minimal.zsh
```

## Parameters
Changes to these variables take immediate effect.

- `MINIMAL_USER_CHAR`: normal user character (default: `λ`).
- `MINIMAL_INSERT_CHAR`: insert mode character (default: `›`).
- `MINIMAL_NORMAL_CHAR`: normal mode character (default: `·`).
- `MINIMAL_OK_COLOR`: color for successful last command and git clean 
(default: `2`).
- `MINIMAL_PWD_LEN`: number of working directory segments shown (default: `2`).
- `MINIMAL_PWD_CHAR_LEN`: maximum length of pwd's segments before it is elided
(default: `10`, minimum: `4`).
- `MINIMAL_MAGIC_ENTER_MARGIN`: a string printed before each line of 
`minimal_magic_output` only if is *not* wrapped into `$PAGER` (default: `  | `)

## Functions
These are used by *minimal* to display useful informations.

`minimal_env`: 

Displays python's virtualenv name if activated.

`minimal_vcs`:

Displays current branch name, red if dirty, `$MINIMAL_OK_COLOR` if clean.

`minimal_ssh_hostname`:

Displays hostname when connected through ssh.

`minimal_magic_output`:

Displays colored `ls` output followed by a short, colored `git status`.

The output of this functions is piped through `$PAGER` if output is longer 
than `$LINES - 2`. This feature (piping) is not controlled by this function.

To override a function, simply declare it before sourcing. Keep in mind that 
override is total.

Example:
```
# I want to drop some sick ascii art when hitting enter
minimal_magic_output() {
  figlet -f slant "COOLEST KID EVER!!"
}
source /path/to/minimal.zsh
```

If you want to just extend `minimal_magic_output`'s output, you can invoke 
`minimal_magic_output_base`:

```
minimal_magic_output() {
  figlet -f slant "COOLEST KID EVER!!"
  minimal_magic_output_base
}
source /path/to/minimal.zsh
```


# FAQ

## I HATE UTF-8!
No problem:
```
MINIMAL_USER_CHAR="$"
MINIMAL_INSERT_CHAR=">"
MINIMAL_NORMAL_CHAR="-"
source /path/to/minimal.zsh
```

## I don't like that magic enter output is wrapped into `$PAGER`
You have two choices:

1. `unset $PAGER` (I don't know how much is *encouraged* this practice).
2. Fork and roll your own, with blackjack and hookers.

I personally find that is useless to have a long output if I can't scroll it.
Sure, terminal emulators can scroll, but what happens when you can't use your 
favorite one and you're stuck in a tty? `$PAGER`, that's the answer.

## How do I change that info bar when using magic enter?
For now, you can't. It's a feature of the theme.

## Why `MINIMAL_OK_COLOR` but red is hardcoded?
By desing, this theme has only one accent color (`MINIMAL_OK_COLOR`).
Red is just a simple way to attract attention to something that needs it (error 
code, branch dirty, etc.)

## Do I need to set vi keybinding to use this theme?
Absolutely no, and you will always see `$MINIMAL_INSERT_CHAR`.

## I don't like feature X
Change theme or see Bender's quote above.

## Can you please add/change feature X?
If you open an issue, I'll take it in consideration, but more often than not 
you can achieve the same result with overrides.

If you think your override is a better default than the current one, don't be 
shy, but provide a clear and useful explanation about why it's better.

Trivial changes (ex: "default normal user char to `$`") are not taken in 
consideration.

Also keep in mind that this theme wants to be fast and stays out the way of the 
user. For example, checking the weather in the magic enter can be slow and 
depends on connectivity; It will never be a default (you have overrides for 
this kind of things).

## Seriously, *magic enter*?
I couldn't find a better name for it. I you have it, please tell me.
