alias ..='cd ..'
alias d="diff -uprN"
alias du="du -h"
alias df="df -h"
alias duh="du -h ./ --max-depth=1"
alias g='git'
alias gr='grep --color=auto -ERUIn'
alias h='history'
alias l='ls -A -p'
alias ll='ls -l'
alias la='ls -a'
alias tm='tmux new -s kkaieda'
alias tma='tmux attach -t kkaieda'
alias v='vim'

alias eng='LANG=C LANGUAGE=C LC_ALL=C'

# grep 行数, 再帰的, ファイル名表示, 行数表示, バイナリファイルは処理しない
alias grepk='grep -i -r -H -n -I'

# find sample
# find /hoge -name '*.c' -print | xargs grep 'search string'

# http://d.hatena.ne.jp/jeneshicc/20110215/1297778049
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tar.xz)    tar xvJf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *.lzma)      lzma -dv $1    ;;
      *.xz)        xz -dv $1      ;;  
      *)           echo "don't know how to extract '$1'..." ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}
alias ex='extract'
