# enable/disable switches
MINIMAL_PROMPT="${MINIMAL_PROMPT:-yes}"
MINIMAL_RPROMPT="${MINIMAL_RPROMPT:-yes}"
MINIMAL_MAGIC_ENTER="${MINIMAL_MAGIC_ENTER:-yes}"

# customization parameters
MINIMAL_OK_COLOR="${MINIMAL_OK_COLOR:-2}"
MINIMAL_USER_CHAR="${MINIMAL_USER_CHAR:-λ}"
MINIMAL_INSERT_CHAR="${MINIMAL_INSERT_CHAR:-›}"
MINIMAL_NORMAL_CHAR="${MINIMAL_NORMAL_CHAR:-·}"

# necessary
autoload -U colors && colors
setopt prompt_subst

_grey="\e[38;5;244m"
_greyp="%{$_grey%}"

# os detection, linux as default
function minimal_ls {
    ls -C --color="always" -w $COLUMNS
}

if [[ "$(uname)" = "Darwin" ]] && ! ls --version &> /dev/null; then
    function minimal_ls {
        ls -C -G
    }
fi

function minimal_git {
  local statc="%{\e[0;3${MINIMAL_OK_COLOR}m%}" # assumes is clean
  local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

  if [ -n "$bname" ]; then
    [ -n "$(git status --porcelain 2> /dev/null)" ] && statc="%{\e[0;31m%}"
    echo " $statc$bname%{\e[0m%}"
  fi
}

function minimal_path {
  local w="%{\e[0m%}"
  local cwd="%2~"
  local pi=""
  cwd="${(%)cwd}"
  cwd=("${(@s:/:)cwd}")

  for i in {1..${#cwd}}; do
    pi="$cwd[$i]"
    [ "${#pi}" -gt 10 ] && cwd[$i]="${pi:0:4}$w..$_greyp${pi: -4}"
  done

  echo "$_greyp${(j:/:)cwd//\//$w/$_greyp}$w"
}

function minimal_lprompt {
  local _venv=""
  if [ -n "$VIRTUAL_ENV" ]; then
    _venv="$(basename $VIRTUAL_ENV)"
    _venv="${_venv%%.*} "
  fi
  local user_status="%{\e[%(1j.4.0);3%(0?.$MINIMAL_OK_COLOR.1)m%}\
%(!.#.$MINIMAL_USER_CHAR)"
  local viins="$MINIMAL_INSERT_CHAR"
  [ "$KEYMAP" = 'vicmd' ] && viins="$MINIMAL_NORMAL_CHAR"

  echo "$_venv$user_status%{\e[0m%} $viins"
}

function minimal_ps2 {
  local _venv=""
  if [ -n "$VIRTUAL_ENV" ]; then
    _venv="$(basename $VIRTUAL_ENV)"
    _venv="${_venv%%.*} "
  fi
  local viins="$MINIMAL_INSERT_CHAR"
  local offset="$((${#_venv} + 2))"
  [ "$KEYMAP" = 'vicmd' ] && viins="$MINIMAL_NORMAL_CHAR"

  printf " %.0s" {1..$offset}
  echo "$viins"
}

if [ "$MINIMAL_PROMPT" = "yes" ]; then
    # prompt redraw on vimode change
    function zle-line-init zle-keymap-select {
        zle reset-prompt
    }

    zle -N zle-line-init
    zle -N zle-keymap-select

    # prompts are set if not already set
    PROMPT='$(minimal_lprompt) '
    PS2='$(minimal_ps2) '
    if [ "$MINIMAL_RPROMPT" = "yes" ]; then
        RPROMPT='$(minimal_path)$(minimal_git)'
    fi
fi


# MAGIC ENTER
# magic enter: if no command is written,
# hitting enter will display some info
function minimal_magic_enter {
  local last_err="$?"

  if [ -z "$BUFFER" ]; then
    local w="\e[0m"
    local rn="\e[0;31m"
    local rb="\e[1;31m"

    local user_host_pwd="$_grey%n$w@$_grey%m$w:$_grey%~$w"
    user_host_pwd="${${(%)user_host_pwd}//\//$w/$_grey}"

    local v_files="$(ls -1 | wc -l)"
    local h_files="$(ls -1A | wc -l)"

    local job_n="$(jobs | wc -l)"

    local iline="[$user_host_pwd] [$_grey$v_files$w ($_grey$h_files$w)]"
    [ "$job_n" -gt 0 ] && iline="$iline [$_grey$job_n$w&]"

    if [ "$last_err" != "0" ]; then
        iline="$iline \e[1;31m[\e[0;31m$last_err\e[1;31m]$w"
    fi

    printf "$iline\n"

    # listing
    local output="$(minimal_ls)"

    # git status
    local git_status="$(git -c color.status=always status -s 2> /dev/null)"
    if [ -n "$git_status" ]; then
      output="$output\n$git_status"
    fi

    local output_len="$(echo "$output" | wc -l)"
    if [ -n "$output" ]; then
      if [ "$output_len" -gt "$((LINES - 2))" ]; then
        printf "$output\n" | "$PAGER" -R
      else
        printf "$output\n"
      fi
    fi
    zle redisplay
  else
    zle accept-line
  fi
}

if [ "$MINIMAL_MAGIC_ENTER" = "yes" ]; then
    zle -N minimal_magic_enter
    bindkey "^M" minimal_magic_enter
fi

