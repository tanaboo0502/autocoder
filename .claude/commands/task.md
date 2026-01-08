# /task - 統合オーケストレーター（自動プロジェクト管理）

**1コマンドですべて自動化。プロジェクト作成からUI起動まで。**

---

## 実行フロー

```
/task [タスク内容]
    │
    ▼
1. プロジェクト判定
    │
    ├─ 新規 → ディレクトリ作成 + 登録 + UI起動
    └─ 既存 → そのまま継続
    │
    ▼
2. orchestrator.md を読む
    │
    ▼
3. タスクタイプ判定
    │
    ▼
4. エージェント選択/生成
    │
    ▼
5. 並列実行（Task tool）
    │
    ▼
6. feature 更新 → UI反映
    │
    ▼
7. manifests 更新 → elite昇格チェック
```

---

## 自動プロジェクト管理

### Step 1: プロジェクト名抽出

タスク内容からプロジェクト名を抽出：

| 入力 | 抽出名 |
|------|--------|
| `電子書籍を作りたい` | `ebook-[timestamp]` |
| `ToDoアプリを作りたい` | `todo-app` |
| `LPを作りたい` | `landing-page-[timestamp]` |
| `ひろくんの自己紹介` | `hirokun-intro` |

### Step 2: 存在チェック

```bash
# チェック対象
/Users/hiroyuki/autocoder2/autocoder/generations/[project-name]/
```

### Step 3: 新規の場合

以下を **自動実行**：

```bash
# 1. ディレクトリ作成
mkdir -p generations/[project-name]/{prompts,content,src,research,tests,docs,.claude/commands,.claude/agents/pool/{specialized,integrated,elite},.claude/agents/manifests}

# 2. 基本ファイルコピー
cp .claude/templates/*.md generations/[project-name]/.claude/commands/
cp .claude/agents/orchestrator.md generations/[project-name]/.claude/agents/

# 3. レジストリ登録
python -c "from registry import register_project; register_project('[name]', '[path]')"

# 4. features.db 初期化
sqlite3 generations/[project-name]/features.db "CREATE TABLE features (...)"

# 5. UI起動 + ブラウザ表示
./start_ui.sh &
sleep 3
open http://localhost:5173
```

### Step 4: 既存の場合

```
features.db を読み込み
    │
    ▼
未完了タスクがあれば継続
    │
    ▼
なければ新規フェーズへ
```

---

## タスクタイプ判定

| キーワード | タイプ | 動作 |
|-----------|--------|------|
| 作りたい, 企画, 設計 | planning | ヒアリング→調査→プラン→feature登録 |
| 書いて, 執筆, 実装して | writing | 並列実装→feature_mark_passing |
| 続きをやって, 再開 | continue | 未完了feature取得→実装継続 |
| テストして, 検証 | testing | テスト実行→修正 |
| デプロイして | deploy | ビルド→デプロイ |
| コミットして | commit | git add + commit |
| レビューして | review | コードレビュー |

---

## 対応プロジェクトタイプ

### コンテンツ系
- 電子書籍, ブログ, LP, スライド, 動画台本, SNS投稿

### アプリ系
- React, Next.js, Vue, Flutter, React Native, PWA

### バックエンド系
- FastAPI, Express, GraphQL, REST API

### ツール系
- CLI, Chrome拡張, VSCode拡張, Slack/Discordボット

### AI系
- MCPサーバー, AIエージェント, RAG, チャットボット

### その他
- データ分析, ドキュメント, 事業計画, デザイン, ゲーム, インフラ

---

## Autocoder UI 連携

### 自動UI起動条件

```
新規プロジェクト作成完了
    AND
レジストリ登録完了
    AND
UI未起動
    │
    ▼
./start_ui.sh &
open http://localhost:5173
```

### MCP ツール

| ツール | タイミング |
|--------|-----------|
| `feature_create_bulk` | プラン承認後 |
| `feature_get_next` | 実装開始時 |
| `feature_mark_passing` | 検証合格後 |
| `feature_skip` | 3回失敗後 |
| `feature_get_stats` | /status 時 |

---

## Planning タスクの対話フロー

**planningタイプの場合、即実行ではなく対話型フローを起動。**

### フェーズ

```
Phase 1: 基本情報ヒアリング
    ↓ 回答待ち
Phase 2: 詳細要件
    ↓ 回答待ち
Phase 3: 並列調査（自動）
    ↓
Phase 4: プラン提示
    ↓ 承認待ち
Phase 5: feature登録 + UI更新
    ↓
Phase 6: 実装フェーズへ
```

### 開始メッセージ

planningタスクを検出したら：

> 「プロジェクトを始めます！
>
> まず教えてください：
>
> 1. 何を作りたいですか？
> 2. どんな内容ですか？
> 3. 誰に届けたいですか？」

**ここで止まって回答を待つ。**

---

## 並列実装パターン

### 独立タスクの並列実行

```xml
<!-- 3エージェント並列起動 -->
<invoke name="Task">
  <parameter name="subagent_type">general-purpose</parameter>
  <parameter name="prompt">Feature 1 を実装</parameter>
  <parameter name="run_in_background">true</parameter>
</invoke>
<invoke name="Task">
  <parameter name="subagent_type">general-purpose</parameter>
  <parameter name="prompt">Feature 2 を実装</parameter>
  <parameter name="run_in_background">true</parameter>
</invoke>
<invoke name="Task">
  <parameter name="subagent_type">general-purpose</parameter>
  <parameter name="prompt">Feature 3 を実装</parameter>
  <parameter name="run_in_background">true</parameter>
</invoke>

<!-- 結果取得 -->
<invoke name="TaskOutput">
  <parameter name="task_id">agent_1_id</parameter>
</invoke>
...
```

---

## 重要ルール

1. **新規プロジェクトは自動作成**（手動mkdir不要）
2. **レジストリ登録後にUI自動起動**
3. **対話は1問ずつ**（まとめて聞かない）
4. **承認なしにfeature登録しない**
5. **並列実行を最大限活用**
6. **完了後はfeature_mark_passing必須**

---

## オーケストレーター起動

このコマンドが呼ばれたら：
1. まずプロジェクト存在チェック
2. 新規なら自動作成 + 登録 + UI起動
3. `.claude/agents/orchestrator.md` を読み込む
4. その指示に従って動作する

---

$ARGUMENTS
