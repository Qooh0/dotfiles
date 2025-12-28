# dotfiles 改善提案

実用性重視で、すぐに導入できる改善案をまとめる。

---

## 1. 即効性のある改善

### 1.1 CLAUDE.md テンプレートを作成

プロジェクトごとに `CLAUDE.md` を置くと、Claude Code がプロジェクト固有のルールを理解する。

```bash
# グローバル設定
~/.claude/CLAUDE.md

# プロジェクトルート
./CLAUDE.md
```

**テンプレート例（コピペ用）:**

```markdown
# プロジェクト: [プロジェクト名]

## コーディング規約
- インデント: スペース2つ
- 言語: TypeScript
- テストフレームワーク: Vitest

## ディレクトリ構造
- src/: ソースコード
- tests/: テストファイル
- docs/: ドキュメント

## 重要なファイル
- src/index.ts: エントリーポイント
- src/config.ts: 設定

## コマンド
- `npm run dev`: 開発サーバー
- `npm test`: テスト実行
- `npm run build`: ビルド

## 注意事項
- [プロジェクト固有の注意点]
```

### 1.2 カスタムスラッシュコマンドの追加

`~/.claude/commands/` にファイルを置くと、Claude Code で `/command` として使える。

```bash
mkdir -p ~/.claude/commands
```

**推奨コマンド:**

`~/.claude/commands/review.md`:
```markdown
# コードレビュー

以下の観点でコードをレビューしてください:

1. **バグ・エラー**: 明らかなバグや例外処理漏れ
2. **セキュリティ**: 脆弱性や危険なパターン
3. **パフォーマンス**: 非効率な処理
4. **可読性**: 改善できる命名やコメント
5. **テスト**: テストカバレッジの不足

対象: $ARGUMENTS
```

`~/.claude/commands/explain.md`:
```markdown
# コード解説

以下のコードについて、初心者にもわかるように解説してください:

- 何をしているか
- なぜそうしているか
- 使われているパターンや技術

対象: $ARGUMENTS
```

`~/.claude/commands/test.md`:
```markdown
# テスト作成

以下のコードに対するユニットテストを作成してください:

- 正常系
- 異常系・エッジケース
- モックが必要な場合は適切に設定

対象: $ARGUMENTS
```

---

## 2. ワークフロー改善

### 2.1 3ステップワークフローの習慣化

毎回このフローを意識する:

```
Research → Plan → Implement
```

**.zshrc.common に追加するリマインダー関数:**

```bash
# AI開発セッション開始時のリマインダー
ai_workflow() {
  echo "=== AI Development Workflow ==="
  echo "1. Research: 問題を理解する（コードは書かせない）"
  echo "2. Plan: 計画を立てる（ステップバイステップ）"
  echo "3. Implement: 段階的に実装する"
  echo ""
  echo "Tip: 'コードは書かなくていい' で調査モードに"
  echo "================================"
}

# cc を拡張してリマインダー表示
alias cc='ai_workflow && claude'
```

### 2.2 tmux + worktree の組み合わせパターン

**新しい tmux コマンドを .tmux.conf に追加:**

```bash
# Worktree 用のセッション作成 (prefix + W)
# 新しい worktree を作成し、そこでセッションを開始
bind W command-prompt -p "Branch name:" "run-shell 'cd #{pane_current_path} && git worktree add -b %1 ../$(basename $(pwd))-%1 HEAD && tmux new-session -d -s %1 -c ../$(basename $(pwd))-%1 && tmux switch-client -t %1'"
```

### 2.3 AI セッション履歴の保存

Claude Code のセッションログを自動保存:

```bash
# .zshrc.common に追加
export CLAUDE_LOG_DIR="$HOME/.claude/logs"
mkdir -p "$CLAUDE_LOG_DIR"

# ログ付きで Claude を起動
cclog() {
  local logfile="$CLAUDE_LOG_DIR/$(date +%Y%m%d-%H%M%S).log"
  claude "$@" 2>&1 | tee "$logfile"
  echo "Log saved: $logfile"
}
```

---

## 3. 設定ファイルの小改善

### 3.1 .zshrc.common への追加

```bash
# ===== AI 開発支援（追加） =====

# プロジェクトのファイルツリーを AI に渡しやすい形式で出力
tree_ai() {
  local depth="${1:-3}"
  tree -L "$depth" -I 'node_modules|.git|dist|build|coverage|__pycache__|.venv' --dirsfirst
}

# 指定ファイルの内容を AI に渡しやすい形式で出力
cat_ai() {
  for f in "$@"; do
    echo "=== $f ==="
    cat "$f"
    echo ""
  done
}

# Git の変更サマリーを AI 向けに出力
git_summary_ai() {
  echo "=== Git Status ==="
  git status -s
  echo ""
  echo "=== Recent Commits ==="
  git log --oneline -5
  echo ""
  echo "=== Staged Changes ==="
  git diff --cached --stat
}

# CLAUDE.md のクイック編集
alias claude-md='${EDITOR:-vim} ./CLAUDE.md'
```

### 3.2 .gitconfig への追加

```ini
[alias]
    # AI 向け diff（行コンテキストを多めに）
    diff-ai = diff --no-color -U10

    # 変更ファイル一覧（AI に渡しやすい）
    changed-files = diff --name-only

    # 最新コミットの変更をAI向けに出力
    show-ai = show --no-color -U10
```

### 3.3 .tmux.conf への追加

```bash
# ===== AI 開発支援（追加） =====

# pane を録画開始/停止 (prefix + R)
# AI との対話を後で振り返る用
bind R if-shell '[ -f /tmp/tmux-recording-#{session_id} ]' \
  'run-shell "rm /tmp/tmux-recording-#{session_id}" ; pipe-pane ; display-message "Recording stopped"' \
  'run-shell "touch /tmp/tmux-recording-#{session_id}" ; pipe-pane -o "cat >> ~/.tmux/recordings/#{session_name}-#{window_index}-#{pane_index}-$(date +%Y%m%d-%H%M%S).log" ; display-message "Recording started"'

# AI 用ディレクトリ作成
# mkdir -p ~/.tmux/recordings
```

---

## 4. 優先度順の導入リスト

### すぐやる（5分）

1. `~/.claude/commands/` ディレクトリを作成
2. `/review` コマンドを追加
3. `tree_ai` 関数を .zshrc.common に追加

### 今週中（30分）

1. CLAUDE.md テンプレートを作成
2. `.gitconfig` に `diff-ai` エイリアス追加
3. `ai_workflow` リマインダー関数を追加

### 時間があるとき（1時間）

1. カスタムスラッシュコマンドを充実
2. tmux の録画機能を設定
3. worktree セッション自動作成を設定

---

## 5. 参考リンク

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Using CLAUDE.md files](https://claude.com/blog/using-claude-md-files)
- [Git Worktrees for AI Development](https://stevekinney.com/courses/ai-development/git-worktrees)
- [Aider Documentation](https://aider.chat/docs/)
