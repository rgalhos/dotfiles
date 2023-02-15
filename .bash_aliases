alias cd..="cd .."
alias cd-="cd -"
alias cdt="cd /tmp"


# Shortcuts
alias c=" clear"
alias q=" exit"
alias :q=" exit"
alias k9="kill -9"
alias pk9="pkill -9"
alias icat="kitty +kitten icat"
alias fdiff="kitty +kitten diff"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias priv="opera --private"
alias trash="gio trash"
alias ffind="find . -iname"
alias myip=" ip addr | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias t=" x-terminal-emulator & disown"


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
alias https-server="http-server -S -C /disk/Coisas/cert.pem -K /disk/Coisas/key.pem -r --cors --no-dotfiles"
alias ytmp3="notify-task youtube-dl --extract-audio --audio-format mp3 --prefer-ffmpeg"
alias resplasma=" DISPLAY=:0 pkill -9 plasmashell && sleep 2 && plasmashell --replace &; disown"


# Aliases to my scripts
alias catj="$HOME/.scripts/catj.js"
alias prettyj="catj"
alias yexp="$HOME/.scripts/yexp.js"
alias getj="$HOME/.scripts/getj.js"
alias update-opera-ffmpeg="$HOME/.scripts/update-opera-ffmpeg.sh"
alias rastreio="$HOME/.scripts/rastreio.sh"


# Directory contents
if which exa &> /dev/null; then
    alias ls=" exa --group-directories-first"
    alias l=" exa -lah --group-directories-first --icons"
    alias ll=" exa -lh --group-directories-first --icons"
    alias la=" exa -lh --all --group-directories-first"
    alias lsd=" exa -D"
    alias lldir=" exa -lhD"
    alias ladir=" exa -lhD --all"
fi
alias tree=" tree -a -I 'CVS|*.*.package|.svn|.git|.hg|.next|node_modules|bower_components' --dirsfirst"
alias hls=" /bin/ls --color=tty --hyperlink=auto --group-directories-first"
alias hla=" hls -lAh"


# Copy/paste on X and Wayland
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    alias xcopy="xclip -selection clipboard"
    alias xpaste="xclip -selection clipboad -o"
else
    alias xcopy="wl-copy"
    alias xpaste="wl-paste"
fi


# SSH public key
alias sshpub=" cat $HOME/.ssh/id_rsa.pub"
alias copysshpub=" sshpub | tee $(tty) | xcopy"

httpicat() {
    if [ -n "$1" ]; then
        curl -k -L -s "$1" | icat;
    else
        echo "no url specified"
    fi
}

dlm3u8() {
    local f="file.mp4"
    [ -n "$2" ] && f="$2";
    notify-task ffmpeg -i "$1" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 23 "$f"
}

tomp3() {
    notify-task ffmpeg -i "$1" -vn -ar 44100 -ac 2 -b:a 192k "$2"
}

ffconcat() {
    for f in "${@: 1:-1}"; do
        echo "file '$f'" >> /tmp/ffconcat.txt
    done

    notify-task \
    ffmpeg -safe 0 -f concat -i /tmp/ffconcat.txt -c copy "${@: -1}"
}

unzipto() {
    unzip "$1" -d "$2"
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
    nautilus "$1" &> /dev/null
}
alias showf="shf"

fout() {
    local fname=/tmp/$(openssl rand -hex 8) retval=0
    echo $@ >> $fname
    retval=$?
    [ $retval -eq 0 ] && echo -n $fname
    return retval
}

gt() {
    local base_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    [ -z "$base_dir" ] && return 1;
    cd $base_dir
}

notify() {
    [ "$TERM" != "xterm-kitty" ] && return 0
    if [ -n "$2" ]; then
        printf '\x1b]99;i=1:d=0;%s\x1b\\' "$1"
        printf '\x1b]99;i=1:d=1:p=body;%s\x1b\\' "$2"
    elif [ -n "$1" ]; then
        printf '\x1b]99;;%s\x1b\\' "$1"
    fi
}

notify-task() {
    $@
    local retval=$?
    notify "Task $([ $retval -eq 0 ] && echo 'finished' || echo 'failed')"
    return retval
}

# Colored manpages
man() {
    local width=$(tput cols) 
    [ $width -gt $MANWIDTH ] && width=$MANWIDTH
    env MANWIDTH=$width \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;38;5;74m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[38;5;246m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[04;38;5;146m' \
    man "$@"
}

