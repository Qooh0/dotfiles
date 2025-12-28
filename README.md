# Dotfiles Repository

AI 開発ワークフローに最適化された dotfiles。

## Quick Start

### 1. 公開 dotfiles をインストール

```sh
cd ~
git clone <リポジトリURL> dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### 2. プライベート dotfiles をインストール（別リポジトリ）

個人情報（名前、メールアドレス、署名キーなど）は [private_dotfiles](https://github.com/YOUR_USERNAME/private_dotfiles) で管理。

```sh
cd ~
git clone git@github.com:YOUR_USERNAME/private_dotfiles.git
cd ~/private_dotfiles
./install.sh
```

## 構成

```
dotfiles/              # 公開リポジトリ
├── .gitconfig         # Git 共通設定（個人情報なし）
├── .zshrc             # Zsh 設定
├── .zshrc.common      # 共通設定（AI開発支援含む）
├── .vimrc             # Vim 設定
├── .tmux.conf         # tmux 設定（AI開発レイアウト含む）
├── .bash_aliases      # エイリアス定義
└── install.sh         # インストールスクリプト

private_dotfiles/      # プライベートリポジトリ（別管理）
├── .gitconfig.local   # Git 個人設定（名前、メール、署名キー）
├── .claude/
│   ├── CLAUDE.md      # Claude Code 個人設定
│   └── commands/      # カスタムスラッシュコマンド
│       ├── review.md  # /review - コードレビュー
│       ├── explain.md # /explain - コード解説
│       └── test.md    # /test - テスト作成
└── install.sh
```

## 設計方針

- **公開設定** (`dotfiles`): 汎用的な設定。誰でも使える状態
- **個人設定** (`private_dotfiles`): 名前、メール、APIキーなど機密情報を分離

## 主な機能

### AI 開発支援

| コマンド | 説明 |
|----------|------|
| `cc` / `ccc` / `ccr` | Claude Code 起動 / 継続 / 再開 |
| `ai` / `aio` / `aia` | Aider (Sonnet/Opus/質問モード) |
| `ais` | fzf でAIツール選択メニュー |
| `ai_workflow` | 3ステップワークフローのリマインダー |
| `tree_ai` | AIに渡しやすいファイルツリー出力 |
| `cat_ai` | 複数ファイルをAI向けに出力 |
| `git_summary_ai` | Git状態サマリー |
| `cclog` | ログ付きClaude起動 |

### tmux レイアウト (prefix = C-t)

| キー | 説明 |
|------|------|
| `C-t A` | AI開発レイアウト（エディタ + Claude + ターミナル） |
| `C-t D` | デュアルAI（Claude vs Aider 比較） |
| `C-t V` | レビューレイアウト（コード70% + AI 30%） |
| `C-t C` | ペイン内容をクリップボードへ |
| `C-t W` | Worktree + tmuxセッション作成 |
| `C-t R` | ペイン録画開始/停止 |

### Git AI エイリアス

| コマンド | 説明 |
|----------|------|
| `git diff-ai` | コンテキスト多めのdiff（色なし） |
| `git changed-files` | 変更ファイル一覧 |
| `git show-ai` | 最新コミットをAI向けに表示 |

詳細は [HOWTOUSE.md](HOWTOUSE.md) を参照。

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
