# This is my variation of the agnoster theme.
# Original theme: https://gist.github.com/3712874

SHOW_RETURN_VALUE=true
PROMPT_SYMBOL=$'\u03bb' # λ

####################################

CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
  SEGMENT_SEPARATOR_RIGHT=$'\ue0b2'
  GIT_NOT_INSTALLED=false
  INSIDE_GIT_FOLDER=false

  ! which git &> /dev/null && \
    GIT_NOT_INSTALLED=true
}

prompt_segment() {
  local bg fg

  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi

  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_dir() {
  if $INSIDE_GIT_FOLDER; then
    local base_dir=$(git rev-parse --show-toplevel)
    echo -n "%{%F{blue}%}${${PWD}/${base_dir%\/*}}"
  else
    echo -n '%{%F{blue}%}%~'
  fi
}

prompt_git() {
  local PL_BRANCH_CHAR repo_path dirty ref

  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
    #PL_BRANCH_CHAR='\U1F988'         # 🦈
  }

  if $INSIDE_GIT_FOLDER; then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats '%u%c'
    zstyle ':vcs_info:*' actionformats '%u%c'
    vcs_info

    if [[ -n $dirty ]]; then
      echo -n " %{%F{yellow}%}$SEGMENT_SEPARATOR_RIGHT"
      prompt_segment yellow black
    else
      echo -n " %{%F{green}%}$SEGMENT_SEPARATOR_RIGHT"
      prompt_segment green $CURRENT_FG
    fi

    echo -n "${vcs_info_msg_0_}${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${mode} "
  fi
}

prompt_status() {
  local -a symbols

  # Ignore ^C
  [[ $RETVAL -ne 0 && $RETVAL -ne 130 ]] && $SHOW_RETURN_VALUE && symbols+="%{%F{red}%}${RETVAL}"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}#"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}\u2699" # ⚙

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_context() {
  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment red $CURRENT_FG "%{%F{white}%}$USER@$HOST"
  else
    prompt_segment blue $CURRENT_FG "%{%F{white}%}$PROMPT_SYMBOL"
  fi
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi

  if [[ $RETVAL -eq 130 ]] ; then
    echo -n "%{%F{yellow}%} ;"
  elif [[ $RETVAL -eq 0 ]] || $SHOW_RETURN_VALUE; then 
    echo -n "%{%F{white}%} ;"
  else
    echo -n "%{%F{red}%} ;"
  fi

  echo -n "%{%f%}"

  CURRENT_BG=''
}

build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_end
}

check_inside_git_folder() {
  if $GIT_NOT_INSTALLED; then
    return
  elif [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  elif [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    INSIDE_GIT_FOLDER=true
  else
    INSIDE_GIT_FOLDER=false
  fi
}

build_rps1() {
  check_inside_git_folder
  prompt_dir
  prompt_git
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPS1='$(printf " %.0s" {1..$(expr $(tput cols) / 4)})$(build_rps1)'
