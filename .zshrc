# ───────────────────────────────────────
# 1) zsh の初期読み込み
autoload -Uz compinit && compinit         # 補完機能を有効化
autoload -Uz colors && colors             # 色を使えるように
export LSCOLORS="GxBxhxDxfxhxhxhxhxhxx"   # カラーを設定
setopt prompt_subst                       # プロンプト内の変数展開を有効に

# ==== Platform detection ====
_is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
_is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

# 2) 履歴関連・入力関連の設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory     # 終了時にヒストリを追記
setopt sharehistory      # 複数セッションで履歴を共有
setopt incappendhistory  # コマンド実行ごとに即ヒストリ保存
setopt histignoredups    # 直前と同じコマンドを重複しない
setopt histignorespace   # 先頭にスペースで始まるコマンドはヒストリに残さない
bindkey -e	         # Emacs ライクなキーバインド

# 3) パス・ユーザディレクトリの補助
if [ -d "$HOME/.local/bin" ]; then
  path+=("$HOME/.local/bin")
fi
if [ -d "$HOME/bin" ]; then
  path+=("$HOME/bin")
fi

# 4) エイリアス
# ==== ls color (subtle) ====
if _is_macos; then
  # macOS/BSD ls は --color ではなく -G、配色は LSCOLORS
  export CLICOLOR=1
  alias ls='ls -G'
else
  # GNU ls
  alias ls='ls --color=auto'
fi
if [ -f "$HOME/.bash_aliases" ]; then
  source $HOME/.bash_aliases
fi

# 5) プロンプト（シンプル版）
# --- Git 情報関数（軽量版）---
git_info() {
  local b dirty ab stat ahead behind
  b=$(git symbolic-ref --short HEAD 2>/dev/null) || return 0
  git diff --quiet --ignore-submodules HEAD 2>/dev/null || dirty="*"
  stat=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
  if [[ -n $stat ]]; then
    ahead=${stat#*	}; behind=${stat%%	*}
    (( ahead > 0 ))  && ab+="↑${ahead}"
    (( behind > 0 )) && ab+="↓${behind}"
  fi
  echo "${b}${dirty}${ab:+ ${ab}}"
}

# --- 2行Powerlineプロンプト（Gitディレクトリのみブロック追加）---
PROMPT='
%F{white}%K{blue} %~ %k%F{blue}%f\
$(git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
  print -n "%F{black}%K{magenta}  $(git_info) %k%F{magenta}%f")\
%F{blue}
%F{green}%n@%m%f %# '

# --- 右側に日付＋時刻 ---
RPROMPT='%F{yellow}%D{%Y-%m-%d %H:%M:%S}%f'

# 6) 区切り文字変更
# デフォルトから安全に削除したい記号を除外
WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

# 7) ssh-agent
if _is_linux; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
fi

# ───────────────────────────────────────

# ───────────────────────────────────────
# 日本語フォント・端末設定への配慮
# （端末エミュレータ側でフォントに日本語・Nerdフォント等確保を推奨） :contentReference[oaicite:4]{index=4}

# 端末のタイトルに現在ディレクトリを表示
case $TERM in
  xterm*|rxvt*)
    precmd() { print -Pn "\e]0;%n@%m: %~\a" }
    ;;
esac
# ───────────────────────────────────────

# ───────────────────────────────────────
# SSH agent 自動起動
if [ -z "$SSH_AUTH_SOCK" ]; then
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
fi

# すでにエージェントが動いているか確認
if ! [ -S "$SSH_AUTH_SOCK" ]; then
  echo "Starting ssh-agent..."
  eval "$(ssh-agent -s)" >/dev/null
  # ソケットの場所を明示
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/agent.sock
  # 鍵を自動登録（ファイルが存在すれば）
  if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
  fi
fi
# ───────────────────────────────────────

