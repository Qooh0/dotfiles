# Dotfiles Repository

## Dotfiles Manage

```sh
git init --bare $HOME/.myconf
alias config='git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
config config status.showUntrackedFiles no
```

Home Folder で下記のように実行する

```sh
config status
config add .vimrc
config commit -m "Add vimrc"
config add .config/redshift.conf
config commit -m "Add redshift config"
config push
```

## Install my dotfiles onto a new system

### .bashrc or .zshrc に下記を設定(config の作成)

`alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

### 再起しないように、下記を実行

`echo ".dotfiles" >> .gitignore`

### ファイルを $HOME に展開

すでにあるファイルをコピーしようとすると、エラーが発生するので気をつけること

```sh
git clone --bare <git-repo-url> $HOME/.dotfiles
config checkout
```

## 参考

https://news.ycombinator.com/item?id=11071754
https://www.atlassian.com/git/tutorials/dotfiles
