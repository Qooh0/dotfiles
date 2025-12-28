#!/usr/bin/env bash

set -Eeuo pipefail

# dotfiles があるディレクトリ（環境変数で上書き可能）
: "${DOTFILES_DIR:="$HOME/dotfiles"}"
# dotfiles backup directory
DOTFILES_BK_DIR="$HOME/.dotfiles_bk"

# 直接リンクを作りたいファイル
FILES=(
  ".bash_aliases"
  ".gitconfig"
  ".zshrc"
  ".zshrc.daily"
  ".zshrc.shoot"
  ".zshrc.common"
  ".vimrc"
  ".tmux.conf"
)

timestamp() { date +"%Y%m%d-%H%M%S"; }
log() { printf "[dotfiles] %s\n" "$*"; }
err() { printf "[dotfiles][ERROR] %s\n" "$*" >&2; }

# OS 判定
detect_os() {
  case "$(uname -s)" in
    Darwin)  echo "mac" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "win"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)  echo "win" ;;
    *)  echo "unknown" ;;
  esac
}

# ===== 事前チェック =====
if [[ ! -d "$DOTFILES_DIR" ]]; then
  err "DOTFILES_DIR not found: $DOTFILES_DIR"
  exit 1
fi

mkdir -p "$DOTFILES_BK_DIR"

# ===== リンク作成関数 =====
link_one() {
  local rel="$1"
  local src="$DOTFILES_DIR/$rel"
  local dst="$HOME/$rel"

  # ソースが無いならスキップ（通知）
  if [[ ! -e "$src" ]]; then
    log "skip (missing source): $src"
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  # 既存がある場合の扱い
  if [[ -L "$dst" ]]; then
    # 既存シンボリックリンクのリンク先が同じなら何もしない
    local current_target
    current_target="$(readlink "$dst" || true)"
    if [[ "$current_target" == "$src" ]]; then
      log "ok (already linked): $dst -> $src"
      return 0
    fi
    log "remove existing symlink: $dst"
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    # 通常ファイル/ディレクトリはバックアップ
    local bk="${DOTFILES_BK_DIR}/${rel//\//_}.$(timestamp).bk"
    log "backup existing: $dst -> $bk"
    mv "$dst" "$bk"
  fi

  ln -s "$src" "$dst"
  log "link: $dst -> $src"
}

# ===== ~/.zshrc.d/ 以下の *.zsh をリンク =====
link_zshrc_d() {
  local src_dir="$DOTFILES_DIR/.zshrc.d"

  if [[ ! -d "$src_dir" ]]; then
    log "skip .zshrc.d (not found in dotfiles)"
    return 0
  fi

  mkdir -p "$HOME/.zshrc.d"

  # bash 用の nullglob
  local old_nullglob
  old_nullglob=$(shopt -p nullglob || true)
  shopt -s nullglob

  local f
  for f in "$src_dir"/*.zsh; do
    local base
    base="$(basename "$f")"
    link_one ".zshrc.d/$base"
  done

  # 元の nullglob 設定を戻す
  if [[ -n "$old_nullglob" ]]; then
    eval "$old_nullglob"
  else
    shopt -u nullglob
  fi
}

# ===== 環境別 .gitconfig.local をリンク =====
link_gitconfig_local() {
  local os
  os="$(detect_os)"
  local src="$DOTFILES_DIR/.gitconfig.${os}.local.example"
  local dst="$HOME/.gitconfig.local"

  if [[ ! -f "$src" ]]; then
    log "skip .gitconfig.local (no template for OS: $os)"
    return 0
  fi

  if [[ -L "$dst" ]]; then
    local current_target
    current_target="$(readlink "$dst" || true)"
    if [[ "$current_target" == "$src" ]]; then
      log "ok (already linked): $dst -> $src"
      return 0
    fi
    log "remove existing symlink: $dst"
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    local bk="${DOTFILES_BK_DIR}/.gitconfig.local.$(timestamp).bk"
    log "backup existing: $dst -> $bk"
    mv "$dst" "$bk"
  fi

  ln -s "$src" "$dst"
  log "link: $dst -> $src"
}

echo "Linking dotfiles from $DOTFILES_DIR to $HOME"
for f in "${FILES[@]}"; do
  link_one "$f"
done

# .zshrc.d/*.zsh をリンク
link_zshrc_d

# 環境別 .gitconfig.local をリンク
link_gitconfig_local

# 機密系の権限トリミング（あれば）
if [[ -d "$HOME/.ssh" ]]; then
  chmod 700 "$HOME/.ssh" || true
  find "$HOME/.ssh" -type f -name "id_*" -exec chmod 600 {} \; 2>/dev/null || true
  [[ -f "$HOME/.ssh/config" ]] && chmod 600 "$HOME/.ssh/config" || true
  [[ -f "$HOME/.ssh/known_hosts" ]] && chmod 644 "$HOME/.ssh/known_hosts" || true
fi

# vim のバックアップディレクトリ（エラーなく最後に）
mkdir -p "$HOME/.cache/vim"/{backup,swap,undo}

log "All done."

exec -l "$SHELL"
