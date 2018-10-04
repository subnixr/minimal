# MINIMAL
A minimal and extensible zsh theme.

# Screencast
[![asciicast](https://asciinema.org/a/RZthpXkg9b7KdKRGjySsC83wx.png)](https://asciinema.org/a/RZthpXkg9b7KdKRGjySsC83wx)

# Installation
[Zgen](https://github.com/tarjoilija/zgen):
```
zgen load subnixr/minimal
```

[Antigen](https://github.com/zsh-users/antigen):
```
antigen bundle subnixr/minimal
```

Otherwise, you can always clone the repo and source `minimal.zsh`.

# Customization and extension
## Architecture
Minimal is mostly a collection of *components* (shell functions) on top of a thin layer to ease customization.

There are 3 areas where a component can be rendered:
- left prompt
- right prompt
- infoline (shown when there is no command and user presses `Enter`)

A component should work in any of the three areas (left, right, info)

## Override default settings
Different components can use these (global) settings:

- `MNML_OK_COLOR`: Color for successful things (default: `2`)
- `MNML_ERR_COLOR`: Color for failures (default: `1`)
- `MNML_USER_CHAR`: Character used for unprivileged users (default: `λ`)
- `MNML_INSERT_CHAR`: Character used for vi insert mode (default: `›`)
- `MNML_NORMAL_CHAR`: Character used for vi normal mode (default: `·`)

Three global arrays handle the definition and rendering position of the components:

```
# Components on the left prompt
MNML_PROMPT=(mnml_ssh mnml_pyenv mnml_status mnml_keymap)

# Components on the right prompt
MNML_RPROMPT=('mnml_cwd 2 0' mnml_git)

# Components shown on info line
MNML_INFOLN=(mnml_err mnml_jobs mnml_uhp mnml_files)
```

An additional array is used to configure magic enter's behavior:

```
MNML_MAGICENTER=(mnml_me_dirs mnml_me_ls mnml_me_git)
```

These values can be changed interactively or in any of the init files.

`PROMPT` and `RPROMPT` should be left untouched, as minimal already takes care of them.

## Available components
### Status

> `λ`

**Syntax**: `mnml_status`

An indicator displaying the following information:
- user privilege: `#` is printed when root, `$MNML_USER_CHAR` otherwise.
- last command success: indicator's color is set to `$MNML_OK_COLOR` when the last command was successful, `$MNML_ERR_COLOR` otherwise.
- background jobs: indicator is underlined if at least one job is in background.

### Keymap

> `›`

**Syntax**: `mnml_keymap`

An indicator displaying the current keymap. `$MNML_INSERT_CHAR` is printed when in insert or default mode, `$MNML_NORMAL_CHAR` when in normal (vi) mode.

It reacts to keymap changes. It should work even if zsh bind mode is not set to `vi`

### Current Working Directrory

> `~`

**Syntax**: `mnml_cwd N LEN`

Displays the last `N` segments of the current working directory, each one trucated if `LEN` is exceded.

If `N` is not specified, it will take a default value of `2`. If is specified but `N <= 0`, it will be set to `1`.

If `LEN` is not specified or `LEN <= 0` no truncation will be performed on the segments. If `0 < LEN < 4` it will be set to `4`.

When a segment length is greater than `LEN`'s value, the first `LEN / 2 - 1` characters are printed, followed by `..`, followed by the last `LEN / 2 - 1` characters.  
For example, with `LEN = 8` and `0123456789` as segment, `012..789` is displayed.

### Git branch status

> `master`

**Syntax**: `mnml_git`

Displays the current git's branch, when inside a git repo. Color is set to `$MNML_OK_COLOR` if the branch is clean, `$MNML_ERR_COLOR` if the branch is dirty.

### User, Hostname & PWD

> `user@host:~`

**Syntax**: `mnml_uhp`

Displays the current username, hostname and working directory.

### SSH hostname

> `host`

**Syntax**: `mnml_ssh`

Displays the hostname only if current session is through a SSH connection.

### Python virtual environment

> `venv`

**Syntax**: `mnml_pyenv`

Displays the current activated python virtualenv.

### Last command error value

> `1`

**Syntax**: `mnml_err`

Displays the last command exit status only if it is not `0`.

### Background jobs counter

> `2&`

**Syntax**: `mnml_jobs`

Displays the number of background jobs only if there is at least one.

### Files

> `[5 (2)]`

**Syntax**: `mnml_files`

Displays the number of visible files, followed by the number of hidden files if any.

## Magic enter functions
### Directory stack

**Syntax**: `mnml_me_dirs`

Prints `dirs` output if there is more than `1` directory in the stack.

### Colored `ls`

**Syntax**: `mnml_me_ls`

Prints colored `ls` output.

### Condensed git status

**Syntax**: `mnml_me_git`

Prints a colored and concise `git status`, only when inside a git repo.


## Custom components

Adding functionality is as easy as writing a shell function and adding it to one of the arrays:

```
function awesome_component {
  echo -n "AWESOME"
}

function awesome_magicenter {
  figlet -f slant "COOL"
}

source minimal.zsh

MNML_PROMPT=(awesome_component $MNML_PROMPT)
MNML_MAGICENTER+=awesome_magicenter
```

Due to minimal's architecture, if you need the value of the last command exit status (`$?`), `$MNML_LAST_ERR` must be used. `$?` can  still be used to check for errors inside the component.

# Congiguration examples:
## no UTF-8

```
MNML_USER_CHAR='$'
MNML_NOMRAL_CHAR='-'
MNML_INSERT_CHAR='>'
source minimal.zsh
```

Result (right omitted): `$ >`

## classic bash's prompt

```
MNML_PROMPT=(mnml_uhp mnml_status mnml_keymap)
MNML_RPROMPT=()
source minimal.zsh
```

Result: `user@host:~ λ ›          `

## good old days

```
MNML_PROMPT=(mnml_status)
MNML_RPROMPT=()
MNML_INFOLN=()
MNML_MAGICENTER=()
source minimal.zsh
```

Result: `λ                        `

# Transition from 0.1.0

Check this [gist](https://gist.github.com/subnixr/ea5a5180ab2c193e6ca1238b4dbbc8bd)
