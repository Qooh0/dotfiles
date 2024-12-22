#!/usr/bin/env bash

# dotfiles があるディレクトリ
DOTFILES_DIR="$HOME/dotfiles"

# リンクを作りたいファイル (必要に応じて増減してください)
FILES=(
  ".zshrc"
  ".vimrc"
  ".tmux.conf"
  # ".gitconfig" など必要に応じて追加
)

echo "Linking dotfiles from $DOTFILES_DIR to $HOME"

for file in "${FILES[@]}"; do
  # もしホームディレクトリにファイル/リンクが既に存在する場合はバックアップしておく
  if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    echo "Found existing file $HOME/$file. Moving it to $HOME/$file.bk"
    mv "$HOME/$file" "$HOME/$file.bk"
  elif [ -L "$HOME/$file" ]; then
    echo "Removing existing symlink $HOME/$file"
    rm "$HOME/$file"
  fi

  # シンボリックリンク作成
  ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
  echo "Created symlink: $HOME/$file -> $DOTFILES_DIR/$file"
done

echo "All done!"
