alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias d="diff -uprN"
alias dev="devcontainer exec --workspace-folder . -- zsh"
alias devup="devcontainer up --workspace-folder ."
alias df="df -h"
alias du="du -h"
alias duh="du -h ./ --max-depth=1"
alias dush='du -sh * 2>/dev/null | sort -h'
alias g='git'
alias gr='grep --color=auto -ERUIn'
if command -v colordiff >/dev/null 2>&1; then
  alias diff='colordiff'
fi
alias gitlessSync='function _gitless_sync() { if [ -f "$1/.gitignore" ]; then rsync -a --exclude=".git" --exclude-from="$1/.gitignore" "$1/" "$2"; else rsync -a --exclude=".git" "$1/" "$2"; fi; }; _gitless_sync'
alias h='history 1'
export LESS='-R'               # ANSI color を通す
export LESSHISTFILE=-
alias l='ls -A -p'
alias ll='ls -lah'
alias la='ls -A'
alias lS='ls -lahS'       # サイズ順
alias lt='ls -laht'       # 更新時刻降順（直近の更新を先頭に）
alias l1='ls -1A'         # 1列表示
mkcd() { mkdir -p -- "$1" && cd "$1"; }	# ディレクトリ作成して移動
alias tm='tmux new -s kkaieda'
alias tma='tmux attach -t kkaieda'
alias v='vim'

alias eng='LANG=C LANGUAGE=C LC_ALL=C'

# grep 行数, 再帰的, ファイル名表示, 行数表示, バイナリファイルは処理しない
alias grepk='grep -i -r -H -n -I'

# find sample
# find /hoge -name '*.c' -print | xargs grep 'search string'

# Archive extraction (with zstd support)
extract() {
  [[ -f "$1" ]] || { echo "'$1' is not a valid file!"; return 1; }

  case "$1" in
    *.tar.bz2)   tar xvjf "$1"    ;;
    *.tar.gz)    tar xvzf "$1"    ;;
    *.tar.xz)    tar xvJf "$1"    ;;
    *.tar.zst)   tar --zstd -xvf "$1" ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xvf "$1"     ;;
    *.tbz2)      tar xvjf "$1"    ;;
    *.tgz)       tar xvzf "$1"    ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *.lzma)      lzma -dv "$1"    ;;
    *.xz)        xz -dv "$1"      ;;
    *.zst)       zstd -d "$1"     ;;
    *)           echo "don't know how to extract '$1'..." ;;
  esac
}
alias ex='extract'
