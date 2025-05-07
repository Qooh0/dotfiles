#!/usr/bin/env bash

# dotfiles があるディレクトリ
DOTFILES_DIR="$HOME/dotfiles"
# dotfiles backup directory
DOTFILES_BK_DIR="$HOME/.dotfiles_bk"

# リンクを作りたいファイル (必要に応じて増減してください)
FILES=(
  ".bash_aliases"
  ".gitconfig"
  ".zshrc"
  ".vimrc"
  ".tmux.conf"
  # ".gitconfig" など必要に応じて追加
)

echo "Linking dotfiles from $DOTFILES_DIR to $HOME"
mkdir -p $DOTFILES_BK_DIR

for file in "${FILES[@]}"; do
  # もしホームディレクトリにファイル/リンクが既に存在する場合はバックアップしておく
  if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    echo "Found existing file $HOME/$file. Moving it to $DOTFILES_BK_DIR/$file.bk"
    mv "$HOME/$file" "$DOTFILES_BK_DIR/$file.bk"
  elif [ -L "$HOME/$file" ]; then
    echo "Removing existing symlink $HOME/$file"
    rm "$HOME/$file"
  fi

  # シンボリックリンク作成
  ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
  echo "Created symlink: $HOME/$file -> $DOTFILES_DIR/$file"
done

exec -l $SHELL

echo "All done!"
