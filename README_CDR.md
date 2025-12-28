# `cdr` - プロジェクトルートへ素早く移動

## 概要

```zsh
alias cdr='cd $(git rev-parse --show-toplevel 2>/dev/null || echo .)'
```

Git リポジトリ内のどこにいても、一発でプロジェクトルート（`.git` があるディレクトリ）へ移動できるエイリアス。

## 使用例

```bash
# 深いディレクトリにいる場合
~/projects/my-app/src/components/ui/buttons $ cdr
~/projects/my-app $   # プロジェクトルートへ移動

# Git リポジトリ外では何も起きない（安全）
~/Downloads $ cdr
~/Downloads $
```

## 動作の仕組み

### 1. `git rev-parse --show-toplevel`

Git の内部コマンドで、**現在のリポジトリのルートディレクトリの絶対パス**を返す。

```bash
# 例: src/components にいる場合
$ pwd
/Users/qooh0/projects/my-app/src/components

$ git rev-parse --show-toplevel
/Users/qooh0/projects/my-app
```

### 2. `2>/dev/null`

標準エラー出力（ファイルディスクリプタ 2）を `/dev/null` に捨てる。

Git リポジトリ外で実行すると以下のエラーが出るが、これを抑制：
```
fatal: not a git repository (or any of the parent directories): .git
```

### 3. `|| echo .`

`||` は「左のコマンドが失敗したら右を実行」という意味。

- Git リポジトリ内: `git rev-parse` が成功 → ルートパスを返す
- Git リポジトリ外: `git rev-parse` が失敗 → `.` を返す

`.` は現在のディレクトリなので、`cd .` は実質何もしない（安全なフォールバック）。

### 4. `$(...)`

コマンド置換。`$(...)` 内のコマンドの出力結果を、その場所に展開する。

```bash
cd $(git rev-parse --show-toplevel 2>/dev/null || echo .)
# ↓ 展開されると
cd /Users/qooh0/projects/my-app
```

## 判断フロー

```
cdr 実行
    │
    ▼
git rev-parse --show-toplevel を実行
    │
    ├─── 成功（Git リポジトリ内）
    │       │
    │       ▼
    │    ルートパスを返す
    │    例: /Users/qooh0/projects/my-app
    │
    └─── 失敗（Git リポジトリ外）
            │
            ▼
         エラーは /dev/null へ
         || により echo . を実行
         "." を返す
    │
    ▼
cd [パス] で移動
```

## AI 開発での活用

| シーン | 操作 |
|--------|------|
| `package.json` を確認したい | `cdr && cat package.json` |
| プロジェクト全体を検索 | `cdr && grep -r "keyword" .` |
| Git 操作をルートで行いたい | `cdr && git status` |
| Claude に渡す diff を取得 | `cdr && gdai` |

## 関連エイリアス

```zsh
# AI 開発支援（.zshrc.common で定義）
alias cc='claude'              # Claude Code 起動
alias ccc='claude --continue'  # 前回の会話を継続
alias ccr='claude --resume'    # セッションを再開
alias gdai='git diff --no-color'         # diff を色なしで出力
alias gdsai='git diff --staged --no-color'  # staged の diff
```

## 補足: なぜ関数ではなくエイリアスか

```zsh
# エイリアス版（採用）
alias cdr='cd $(git rev-parse --show-toplevel 2>/dev/null || echo .)'

# 関数版
cdr() {
  cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
}
```

どちらでも動作するが、この程度の単純なコマンドならエイリアスの方が：
- 定義が短い
- オーバーヘッドが若干少ない
- 可読性が良い
