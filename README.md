# Dotfiles Repository

## Dotfiles Manage

1. dotfiles レポジトリをクローンする

```sh
cd ~
git clone <リポジトリURL> dotfiles
```

2. スクリプトに実行権限をつける

```sh
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## bash/zsh は、これも良さそう

https://starship.rs/

## bash/zsh の .bashrc,.bash_profile での内容を再読み込みする。

`exec $SHELL -l`

## Vim Plugins

今回は採用していない
Vim Plugin を考えるなら、VS Code を考えるべき。

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

vimrc の銭湯あたりにプラグインの管理ブロックを入れる

```vimrc
call plug#begin('~/.vim/plugged')

" ここにプラグイン記載例
Plug 'scrooloose/nerdtree'     " ファイルツリー
Plug 'tpope/vim-commentary'    " コメントアウト補助
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'        " Fuzzy Finder

call plug#end()
```

Vim を起動して `:PlugInstall` でインストール
