alias cd..="cd .."
alias cd-="cd -"
alias cdt="cd /tmp"

# Shortcuts
alias c=" clear"
alias q=" exit"
alias :q=" exit"
alias bat=' BAT_THEME="Catppuccin-macchiato" batcat'
alias k9="kill -9"
alias pk9="pkill -9"
alias icat="kitty +kitten icat"
alias fdiff="kitty +kitten diff"
alias transfer="kitty +kitten transfer"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias priv="opera --private"
alias trash="gio trash"
alias ffind="find . -iname"
alias ports=" netstat -tulpn | grep 'LISTEN'"
alias myip=" ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias uncommit="git reset --soft HEAD^"
alias dush="du -sh"
alias du-sh="du -sh"
alias t=" x-terminal-emulator & disown"

alias notes=" cat $HOME/.notes | sed ':a;N;\$!ba;s/\n\{2,\}/\n\n/g'"
alias enotes=" $EDITOR $HOME/.notes"
alias wnotes=" cat - | tee -a $HOME/.notes >/dev/null"
wnote() { echo "$@" >>"$HOME/.notes"; }

# npm aliases
alias npmi="npm i --save"
alias npmid="npm i --save-dev"
alias npmg="npm i -g"

# APT-related aliases
alias apti="apt install"
alias sai="sudo apt install"
alias say="sudo apt install -y"
alias sau="sudo apt update"
alias acs=" apt-cache search"
alias aci=" apt info"
alias alg=" apt list --installed | grep"
alias alu=" apt list --upgradable"

# Misc
alias proton="proton-call -r"
#alias proton="STEAM_COMPAT_CLIENT_INSTALL_PATH=$HOME/.steam/steam STEAM_COMPAT_DATA_PATH=$HOME/.steam/steam/steamapps/common/Proton\ \-\ Experimental/files/share/wine $HOME/.steam/steam/steamapps/common/Proton\ 7.0/proton run "
alias docker-compose="docker compose"
alias https-server="http-server -S -C ~/.localhost.crt -K ~/.localhost.key -r --cors --no-dotfiles"
alias ytmp3="notify-task youtube-dl --extract-audio --audio-format mp3 --prefer-ffmpeg"
alias resplasma=" DISPLAY=:0 pkill -9 plasmashell && sleep 2 && plasmashell --replace & disown"

# Aliases to my scripts
# No, I won't add '.scripts' to $PATH
alias catj="$HOME/.scripts/catj"
alias prettyj="catj"
alias yexp="$HOME/.scripts/yexp"
alias getj="$HOME/.scripts/getj"
alias update-opera-ffmpeg="$HOME/.scripts/update-opera-ffmpeg"
alias rastreio=" $HOME/.scripts/rastreio"
alias garfield=" $HOME/.scripts/garfield"

# Directory contents
if which exa &>/dev/null; then
    alias ls=" exa --group-directories-first"
    alias l=" ls -lah --icons"
    alias la=" ls -lah"
    alias ll=" ls -lh --icons"
    alias lsd=" exa -D"
    alias lldir=" exa -lhD"
    alias ladir=" exa -lhD --all"
else
    alias ls=" command ls --group-directories-first --color=tty"
    alias l=" ls -lah"
    alias la=" ls -lah"
    alias ll=" ls -lh"
    alias lsd=" ls -d */"
    alias lldir=" ls -lh -d */"
    alias ladir=" lldir -d .*/"
fi
alias hls=" command ls --color=tty --hyperlink=auto --group-directories-first"
alias hla=" hls -lAh"

tree() {
    # exa --tree -a -I 'CVS|*.*.package|.svn|.git|.hg|.next|node_modules|bower_components' -L "${1:-3}" --group-directories-first --icons
    command tree "${1:-.}" -aC -I 'CVS|*.*.package|.svn|.git|.hg|.next|node_modules|bower_components' -L "${2:-3}" --dirsfirst
}

# Copy/paste on X and Wayland (or over ssh with kitty)
if [ "$TERM" = "xterm-kitty" ]; then
    alias xcopy="kitty +kitten clipboard"
    alias xpaste="kitty +kitten clipboard --get-clipboard"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    alias xcopy="xclip -selection clipboard"
    alias xpaste="xclip -selection clipboad -o"
else
    alias xcopy="wl-copy"
    alias xpaste="wl-paste"
fi

alias ttycopy="tee $(tty) | xcopy"
alias ttypaste="xpaste | tee $(tty)"

# SSH public key
alias sshpub=" cat $HOME/.ssh/id_rsa.pub"
alias copysshpub=" sshpub | ttycopy"

httpicat() {
    if [ -n "$1" ]; then
        curl -k -L -s "$1" | icat
    else
        echo "no url specified"
    fi
}

dlm3u8() {
    notify-task ffmpeg -i "$1" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 23 "${2:-file.mp4}"
}

tomp3() {
    notify-task ffmpeg -i "$1" -vn -ar 44100 -ac 2 -b:a 192k "${2:-$1.mp3}"
}

ffconcat() {
    for f in "${@:1:-1}"; do
        echo "file '$f'" >>/tmp/ffconcat.txt
    done

    notify-task \
        ffmpeg -safe 0 -f concat -i /tmp/ffconcat.txt -c copy "${@: -1}"
}

ex() {
    if [ -f "$1" ]; then
        case $1 in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.deb) ar x "$1" ;;
        *.tar.xz) tar xf "$1" ;;
        *.tar.zst) unzstd "$1" ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

tt() {
    if [ -n "$1" ]; then
        local fname="/tmp/$1" retval
        touch "$fname"
        retval=$?
        [ $retval -ne 0 ] && return $retval
        echo -n "$fname"
        return 0
    fi
    return 1
}

shf() {
    nautilus "$1" &>/dev/null
}
alias showf="shf"

fout() {
    local fname=
    fname=/tmp/$(openssl rand -hex 8) retval=0
    echo $@ | tee -a "$fname" &>/dev/null
    retval=$?
    [ $retval -eq 0 ] && echo -n "$fname"
    return retval
}

gt() {
    local base_dir=
    base_dir=$(git rev-parse --show-toplevel 2>/dev/null)
    [ -z "$base_dir" ] && return 1
    cd "$base_dir" || return 1
}

notify() {
    if which notify-send &>/dev/null; then
        notify-send "$1" "$2"
    elif [ "$TERM" = "xterm-kitty" ]; then
        printf '\x1b]99;i=1:d=0;%s\x1b\\' "$1"
        printf '\x1b]99;i=1:d=1:p=body;%s\x1b\\' "$2"
    fi
}

notify-task() {
    $@
    local retval=$?
    notify "Task $([ $retval -eq 0 ] && echo 'finished' || echo 'failed')"
    return retval
}

norc() {
    local SH=
    SH=$(basename "$(ps -hp $$ | awk '{ print $5 }')")
    if [ "$SH" = "zsh" ]; then
        zsh -f
    elif [ "$SH" = "bash" ]; then
        bash --norc
    fi
}

pvi() {
    local COLS LINES
    COLS=$(($(tput cols) / 2))
    LINES=$(tput lines)

    find . -type f -exec file {} + |
        grep -oP '^.+:\s*\w+\s*image' |
        cut -d':' -f1 |
        fzf --preview "kitty +kitten icat --place ${COLS}x${LINES}@${COLS}x0 --transfer-mode file {}" --preview-window '~3'
}

kdshare() {
    local devices device_id files
    files=()

    if [ $# -ge 1 ]; then
        files=("$@")
    else
        files=("$(find . -maxdepth 3 -type f | fzf)")
    fi

    [ -z "${files[*]}" ] && return 1

    kdeconnect-cli --refresh
    devices=$(kdeconnect-cli --list-available --id-name-only)

    select device in "${devices[@]}"; do
        device_id="$(echo "$device" | cut -d' ' -f1)"
        notify-task kdeconnect-cli --share "${files[@]}" -d "$device_id"
        break
    done
}

glog() {
    git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
        fzf --ansi --no-sort --reverse --tiebreak=index \
            --preview "git show \$(echo '{}' | cut -d' ' -f1) | batcat -n --color=always" \
            --preview-window '~3'
}

# Colored manpages
man() {
    LESS='-Rij.5' \
        LESS_TERMCAP_mb=$'\e[01;31m' \
        LESS_TERMCAP_md=$'\e[01;38;5;74m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[31m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[04;38;5;146m' \
        command man "$@"
}
