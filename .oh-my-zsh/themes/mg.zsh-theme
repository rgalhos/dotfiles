# This is my variation of the agnoster theme.
# It uses Poweline Symbold and Nerd Fonts
# Original theme: https://gist.github.com/3712874

CONTEXT_ONLY_ON_SSH=true
PROMPT_SYMBOL=';'
#PROMPT_SYMBOL='\ue7a2 '
COLORED_PROMPT=true
SHOW_RETVAL=true

setopt promptsubst
autoload -Uz vcs_info

SEGMENT_SEPARATOR=$'\ue0b2'
ICON_BRANCH=$'\ue0a0' # pl-branch
ICON_AS_ROOT=$'\Uf01e5' # nf-md-duck
ICON_BG_JOBS=$'\Uf1323' # nf-md-hammer_wrench
ICON_BISECT=$'\ueaaf' # nf-cod-bug
ICON_MERGE_HEAD=$'\uebab' # nf-cod-merge
ICON_REBASE=$'\ue726'  # nf-dev-git_pull_request
ICON_STAGED='✚'
ICON_UNSTAGED='±'
ICON_DETACHED_HEAD=$'\u27a6'

PREVBG=
BG=
FG=

prompt_segment() {
    PREVBG=$BG
    BG="$1"
    FG="$2"

    if [ -z "${PREVBG+}" ]; then
        echo -n "%{%F{$BG}%}$SEGMENT_SEPARATOR"
    fi

    echo -n "%{%K{$BG}%}"

    [[ -n "$FG" ]] && echo -n "%{%F{$FG}%} "

    [[ -n "$3" ]] && echo -n "$3 "
}

prompt_git() {
    (( $+commands[git] )) || return;

    REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    [ ! $REPO_PATH ] && return;

    IS_DIRTY=$(parse_git_dirty)
    REF=$(git symbolic-ref HEAD 2>/dev/null) || \
        REF="$ICON_DETACHED_HEAD $(git rev-parse --short HEAD 2>/dev/null)"

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      MODE=" $ICON_BISECT"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      MODE=" $ICON_MERGE_HEAD"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      MODE=" $ICON_REBASE"
    fi

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr "$ICON_STAGED"
    zstyle ':vcs_info:*' unstagedstr "$ICON_UNSTAGED"
    zstyle ':vcs_info:*' formats '%u%c'
    zstyle ':vcs_info:*' actionformats '%u%c'
    vcs_info

    if [[ -n $IS_DIRTY ]]; then
        prompt_segment yellow black
    else
        prompt_segment green black
    fi

    echo -n "${vcs_info_msg_0_}${${REF:gs/%/%%}/refs\/heads\//$ICON_BRANCH }${MODE} "
}

prompt_context() {
    if [[ -n "$SSH_CLIENT" ]]; then
        prompt_segment red white "%n@%m"
    elif ! $CONTEXT_ONLY_ON_SSH; then
        prompt_segment blue white "%n@%m"
    fi
}

prompt_dir() {
    PREVBG=
    color_reset

    if BASE_DIR=$(git rev-parse --show-toplevel 2>/dev/null) then
        echo -n "%{%F{blue}%}${${PWD}/${BASE_DIR%\/*}} "
    else
        echo -n '%{%F{blue}%}%~ '
    fi
}

prompt_status() {
    local -a symbols

    [ $UID = 0 ] && symbols+="%{%F{yellow}%}$ICON_AS_ROOT"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{green}%}$ICON_BG_JOBS"

    [[ -n "$symbols" ]] && echo -n "${symbols[*]} "
}

prompt_retval() {
    if [[ $SHOW_RETVAL && $RETVAL -ne 0 && $RETVAL -ne 130 ]]; then
        prompt_segment black red "$RETVAL"
    fi
}

color_reset() {
    echo -n "%{%f%b%k%}"
}

build_prompt() {
    RETVAL=$?

    if [[ ! $COLORED_PROMPT || $RETVAL = 0 ]]; then
        echo -n '%{%F{white}%}'
    elif [[ $RETVAL -eq 130 ]]; then
        echo -n '%{%F{yellow}%}'
    else
        echo -n '%{%F{red}%}'
    fi

    echo -n " $PROMPT_SYMBOL"

    color_reset
}

build_rps1() {
    RETVAL=$?

    # Print some whitespaces
    printf " %.0s" {1..$(expr $(tput cols) / 4)}

    prompt_status
    prompt_dir
    prompt_git
    prompt_context
    prompt_retval
    color_reset
}

PROMPT='$(build_prompt) '
RPS1='$(build_rps1)'
