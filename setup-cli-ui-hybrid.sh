#!/bin/bash
#
# 🔗 Agent Orchestrator + Autocoder UI 統合版
#
# 設計:
#   - CLI (Claude Code) で /task コマンドを実行
#   - Autocoder UI でカンバンボードをモニタリング
#   - feature システムで進捗を同期
#
# 使い方:
#   1. Autocoder をクローン
#   2. このスクリプトを autocoder/ で実行
#   3. UI を起動してモニタリング
#   4. 別ターミナルで Claude Code を起動して /task 実行
#

PROJECT_NAME=${1:-"my-content-book"}
AUTOCODER_DIR=$(pwd)
PROJECT_DIR="$AUTOCODER_DIR/generations/$PROJECT_NAME"

echo "🔗 Agent Orchestrator + Autocoder UI 統合版"
echo "   CLI で制作、UI でモニタリング"
echo "   プロジェクト: $PROJECT_NAME"
echo ""

# プロジェクトフォルダ作成
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# ディレクトリ構造
mkdir -p .claude/commands
mkdir -p .claude/agents/pool/specialized
mkdir -p .claude/agents/pool/integrated
mkdir -p .claude/agents/pool/elite
mkdir -p .claude/agents/manifests
mkdir -p prompts
mkdir -p research
mkdir -p content
mkdir -p outputs
mkdir -p docs

echo "✅ ディレクトリ構造作成完了"

# ===========================================
# /task コマンド（Autocoder feature連携）
# ===========================================

cat << 'EOF' > .claude/commands/task.md
# /task - 統合オーケストレーター（Autocoder連携）

**CLI で実行し、Autocoder UI で進捗を確認できる。**

---

## 実行フロー

```
/task [タスク内容]
    │
    ▼
1. orchestrator.md を読む
    │
    ▼
2. pool/ を走査してカバレッジ計算
    │
    ▼
3. エージェント選択/生成
    │
    ▼
4. タスク実行
    │
    ▼
5. Autocoder feature 更新（UI反映）
    │
    ▼
6. manifests/ メトリクス更新
    │
    ▼
7. elite昇格チェック
```

---

## Autocoder UI 連携

タスク完了時に feature を更新して UI に反映：

### 章登録時
```
feature_create_bulk([
  {"name": "chapter_1", "description": "第1章: ...", "priority": 1},
  {"name": "chapter_2", "description": "第2章: ...", "priority": 2},
  ...
])
```

### 章完了時
```
feature_mark_passing("chapter_1")
→ UI のカンバンで「Done」に移動
```

### 章スキップ時
```
feature_skip("chapter_3")
→ 優先度を下げて後回し
```

---

## タスクタイプ判定

| 入力パターン | タイプ | 動作 |
|-------------|--------|------|
| 作りたい, 企画 | planning | ヒアリング→調査→プラン→**feature登録** |
| 書いて, 執筆 | writing | 執筆→検証→**feature_mark_passing** |
| チェック, 検証 | verify | 品質検証 |
| 出力, PDF | export | 最終出力 |
| 進捗, ステータス | status | **feature_get_stats** でUI同期確認 |

---

## オーケストレーター起動

このコマンドが呼ばれたら：
1. `.claude/agents/orchestrator.md` を読み込む
2. その指示に従って動作する

---

$ARGUMENTS
EOF

echo "✅ /task コマンド作成完了"

# ===========================================
# /status コマンド（UI同期確認）
# ===========================================

cat << 'EOF' > .claude/commands/status.md
# /status - 進捗確認（Autocoder UI同期）

**Autocoder の feature 状態を確認し、UI と同期。**

---

## 実行内容

1. `feature_get_stats` を呼び出し
2. 進捗を表示
3. UI のカンバンと一致していることを確認

---

## 出力例

```
📊 進捗状況

【統計】
- 完了: 5章
- 進行中: 1章
- 未着手: 4章
- 進捗率: 50%

【詳細】
✅ chapter_1: 第1章 - はじめに
✅ chapter_2: 第2章 - 基礎知識
✅ chapter_3: 第3章 - 実践編
✅ chapter_4: 第4章 - 応用編
✅ chapter_5: 第5章 - ケーススタディ
⏳ chapter_6: 第6章 - トラブルシューティング
⬜ chapter_7: 第7章 - 発展編
⬜ chapter_8: 第8章 - まとめ
⬜ chapter_9: 第9章 - 付録A
⬜ chapter_10: 第10章 - 付録B

UI (http://localhost:5173) で視覚的に確認できます。
```

---

$ARGUMENTS
EOF

echo "✅ /status コマンド作成完了"

# ===========================================
# orchestrator.md（Autocoder連携版）
# ===========================================

cat << 'EOF' > .claude/agents/orchestrator.md
# Orchestrator - 自己進化オーケストレーター（Autocoder連携）

## コア原則

**事前定義された抽象エージェントを使わない。**
代わりに:
1. 実際のタスク要件から専門エージェントを生成
2. シナジーがあれば既存エージェントを統合
3. エージェントプールを継続的に進化させる

---

## Autocoder UI 連携

### 進捗の同期

```
CLI で /task 実行
    ↓
feature を更新
    ↓
Autocoder UI に自動反映（WebSocket）
    ↓
カンバンボードで視覚的に確認
```

### MCP ツール

| ツール | 用途 | タイミング |
|--------|------|-----------|
| `feature_create_bulk` | 章を登録 | プラン承認後 |
| `feature_get_next` | 次の未完了章を取得 | 執筆開始時 |
| `feature_mark_passing` | 章を完了マーク | 検証合格後 |
| `feature_skip` | 章をスキップ | 3回失敗後 |
| `feature_get_stats` | 進捗統計 | /status 時 |

---

## オーケストレーションフロー

### Step 1: エージェントプール走査

```
pool/ 内の全エージェントを取得:
  - pool/specialized/*.md
  - pool/integrated/*.md
  - pool/elite/*.md（優先）

manifests/*.yaml からスキルを読み込む
```

### Step 2: カバレッジ計算

```
タスクから必要スキルを抽出
各エージェントのスキルとマッチング:
  coverage = (マッチするスキル数 / 必要スキル数) * 100
```

### Step 3: 判定マトリクス

| カバレッジ | アクション |
|-----------|-----------|
| **90%以上** | 既存エージェントを使用 |
| **60-90%** | 統合エージェントを生成 |
| **60%未満** | 新規専門エージェントを生成 |

### Step 4: タスク実行

選択/生成したエージェントでタスク実行。

### Step 5: Autocoder連携（重要）

**タスクタイプに応じて feature を更新：**

#### planning タスク完了時
```
# 章を feature として登録
feature_create_bulk([
  {"name": "chapter_1", "description": "第1章: ...", "priority": 1},
  ...
])

→ UI にカンバンカードが表示される
```

#### writing タスク完了時
```
# 検証合格後
feature_mark_passing("chapter_N")

→ UI で「Done」列に移動
```

#### 3回失敗時
```
feature_skip("chapter_N")

→ UI で優先度が下がる
```

### Step 6: メトリクス更新

```yaml
# manifests/{agent}.yaml を更新
metrics:
  usage_count: +1
  success_count: +1（成功時）
  success_rate: 再計算
  last_used: 現在日時
```

### Step 7: Elite昇格チェック

```
IF usage_count >= 5 AND success_rate >= 80%:
    pool/elite/ に移動
    manifests の tier を "elite" に更新
```

---

## タスクタイプ判定

| キーワード | タイプ | 必要スキル | feature連携 |
|-----------|--------|-----------|------------|
| 作りたい, 企画 | planning | planning, interviewing | feature_create_bulk |
| 書いて, 執筆 | writing | writing, persona-aware | feature_mark_passing |
| 調べて, 分析 | research | market-analysis | なし |
| チェック, 検証 | verify | quality-check | なし |
| 出力, PDF | export | docx-export, pdf-export | なし |
| 進捗, ステータス | status | なし | feature_get_stats |

---

## 重要ルール

1. **必ず pool/ を走査してから判断**
2. **カバレッジ計算を省略しない**
3. **タスク完了後は feature を更新**（UI反映）
4. **manifests/ のメトリクスを更新**
5. **昇格条件を毎回チェック**
EOF

echo "✅ orchestrator.md 作成完了"

# ===========================================
# 初期エージェント（Autocoder連携版）
# ===========================================

# plan-agent
cat << 'EOF' > .claude/agents/pool/specialized/plan-agent.md
# Plan Agent

## 概要
コンテンツ企画のヒアリングとプラン策定を担当。
プラン承認後、Autocoder に章を登録してカンバンに反映。

## スキル
- planning
- interviewing
- market-analysis
- persona-design
- content-structure
- voice-design

## 得意なタスク
- 新規コンテンツの企画
- ターゲットヒアリング
- 競合分析
- 構成設計

## 実行ルール
1. 質問は1つずつ丁寧に行う
2. 回答は research/notes.md に記録
3. 調査は並列で実行可能
4. プラン策定時は extended thinking を使用
5. 承認を得るまで制作に進まない
6. **承認後、feature_create_bulk で章を登録**

## Autocoder連携

プラン承認後：
```
feature_create_bulk([
  {"name": "chapter_1", "description": "第1章: ...", "priority": 1},
  {"name": "chapter_2", "description": "第2章: ...", "priority": 2},
  ...
])
```

→ Autocoder UI のカンバンに章が表示される

## 出力先
- research/notes.md
- research/persona.md
- research/brand-voice.md
- research/structure.md
- docs/PROJECT-PLAN.md
EOF

cat << 'EOF' > .claude/agents/manifests/plan-agent.yaml
name: "plan-agent"
version: "1.0"
tier: "specialized"
description: "コンテンツ企画・ヒアリング・プラン策定"
skills:
  - planning
  - interviewing
  - market-analysis
  - persona-design
  - content-structure
  - voice-design
metrics:
  usage_count: 0
  success_count: 0
  success_rate: 0.0
  last_used: null
  created_at: "2026-01-07"
parent_agents: []
evolution_history:
  - date: "2026-01-07"
    event: "created"
    note: "Initial plan agent with Autocoder integration"
EOF

# write-agent
cat << 'EOF' > .claude/agents/pool/specialized/write-agent.md
# Write Agent

## 概要
コンテンツの執筆を担当。
完了時、Autocoder feature を更新してカンバンに反映。

## スキル
- writing
- persona-aware
- tone-consistent
- structure-following

## 得意なタスク
- 章・セクションの執筆
- ブログ記事作成
- 本文執筆

## 実行ルール
1. 執筆前に research/persona.md を確認
2. research/brand-voice.md のトーンで書く
3. research/structure.md の構成に従う
4. 各章 3000-5000字を目安に
5. 完了後は自動検証
6. **検証合格後、feature_mark_passing で完了マーク**

## Autocoder連携

執筆→検証→合格後：
```
feature_mark_passing("chapter_N")
```

→ Autocoder UI で「Done」列に移動

3回失敗時：
```
feature_skip("chapter_N")
```

→ 次の章に進む

## 参照ファイル
- research/persona.md
- research/brand-voice.md
- research/structure.md

## 出力先
- content/chapter_{n}.md
EOF

cat << 'EOF' > .claude/agents/manifests/write-agent.yaml
name: "write-agent"
version: "1.0"
tier: "specialized"
description: "コンテンツ執筆"
skills:
  - writing
  - persona-aware
  - tone-consistent
  - structure-following
metrics:
  usage_count: 0
  success_count: 0
  success_rate: 0.0
  last_used: null
  created_at: "2026-01-07"
parent_agents: []
evolution_history:
  - date: "2026-01-07"
    event: "created"
    note: "Initial write agent with Autocoder integration"
EOF

# verify-agent
cat << 'EOF' > .claude/agents/pool/specialized/verify-agent.md
# Verify Agent

## 概要
コンテンツの品質検証を担当。

## スキル
- quality-check
- persona-matching
- tone-checking
- rule-enforcement

## 実行ルール
1. research/persona.md と照合
2. research/brand-voice.md と照合
3. 禁止事項をチェック
4. 問題があれば修正案を提示

## 出力
検証結果（合格/要修正 + 修正案）
EOF

cat << 'EOF' > .claude/agents/manifests/verify-agent.yaml
name: "verify-agent"
version: "1.0"
tier: "specialized"
description: "品質検証"
skills:
  - quality-check
  - persona-matching
  - tone-checking
  - rule-enforcement
metrics:
  usage_count: 0
  success_count: 0
  success_rate: 0.0
  last_used: null
  created_at: "2026-01-07"
parent_agents: []
evolution_history:
  - date: "2026-01-07"
    event: "created"
    note: "Initial verify agent"
EOF

# export-agent
cat << 'EOF' > .claude/agents/pool/specialized/export-agent.md
# Export Agent

## 概要
最終出力を担当。Skills を活用して各形式で出力。

## スキル
- markdown-export
- docx-export
- pdf-export

## 実行ルール
1. content/ 内の全章を読み込む
2. 順番に統合
3. 表紙・目次を追加
4. Skills を活用して各形式で出力
   - /mnt/skills/public/docx/SKILL.md
   - /mnt/skills/public/pdf/SKILL.md

## 出力先
- outputs/{name}.md
- outputs/{name}.docx
- outputs/{name}.pdf
EOF

cat << 'EOF' > .claude/agents/manifests/export-agent.yaml
name: "export-agent"
version: "1.0"
tier: "specialized"
description: "最終出力"
skills:
  - markdown-export
  - docx-export
  - pdf-export
metrics:
  usage_count: 0
  success_count: 0
  success_rate: 0.0
  last_used: null
  created_at: "2026-01-07"
parent_agents: []
evolution_history:
  - date: "2026-01-07"
    event: "created"
    note: "Initial export agent"
EOF

echo "✅ 初期エージェント作成完了"

# ===========================================
# _template.md
# ===========================================

cat << 'EOF' > .claude/agents/_template.md
# {AGENT_NAME}

## 概要
{役割を1-2文で}

## スキル
- {skill_1}
- {skill_2}

## 得意なタスク
- {タスク1}
- {タスク2}

## 実行ルール
1. {ルール1}
2. {ルール2}

## Autocoder連携
{feature更新のタイミングと方法}

## 参照ファイル
- {ファイル}

## 出力先
- {フォルダ/ファイル}

## 親エージェント
- {統合時のみ}
EOF

# ===========================================
# Autocoder用プロンプト（UIモニタリング用）
# ===========================================

cat << 'EOF' > prompts/app_spec.txt
# コンテンツ制作プロジェクト

## 運用方法

このプロジェクトは「CLI + UI 併用」で運用します。

### CLI (Claude Code)
- /task コマンドで制作を実行
- オーケストレーターがエージェントを管理
- feature を更新して UI に反映

### UI (Autocoder)
- カンバンボードで進捗をモニタリング
- 視覚的に状態を確認
- 操作は不要（見るだけ）

## 使い方

1. ターミナル1: Autocoder UI 起動
   ./start_ui.sh
   → http://localhost:5173 でモニタリング

2. ターミナル2: Claude Code で制作
   cd generations/[プロジェクト名]
   claude
   /task 電子書籍を作りたい

3. UI でカンバン確認
   - Pending: 未着手
   - In Progress: 進行中
   - Done: 完了
EOF

cat << 'EOF' > prompts/initializer_prompt.md
# UI モニタリング専用

このプロジェクトは CLI (Claude Code) で制作します。
Autocoder UI は進捗モニタリング専用です。

## CLI での操作

別ターミナルで以下を実行：

```
cd generations/[プロジェクト名]
claude
/task 電子書籍を作りたい
```

## UI の役割

- カンバンボードで進捗を確認
- feature の状態をリアルタイム表示
- 操作は不要
EOF

cat << 'EOF' > prompts/coding_prompt.md
# UI モニタリング専用

このプロジェクトは CLI (Claude Code) で制作します。
Autocoder UI は進捗モニタリング専用です。

CLI で /task コマンドを実行すると、
feature が更新されてこの UI に反映されます。
EOF

echo "✅ Autocoder プロンプト作成完了"

# ===========================================
# settings.json
# ===========================================

cat << 'EOF' > .claude/settings.json
{
  "permissions": {
    "allow": [
      "Read(*)",
      "Write(.claude/agents/*)",
      "Write(research/*)",
      "Write(content/*)",
      "Write(outputs/*)",
      "Write(docs/*)",
      "Bash(cat:*)",
      "Bash(ls:*)",
      "Bash(wc:*)",
      "Bash(grep:*)",
      "Bash(mkdir:*)",
      "Bash(mv:*)"
    ],
    "deny": []
  },
  "hooks": {
    "Stop": [
      {
        "type": "command",
        "command": "afplay /System/Library/Sounds/Glass.aiff 2>/dev/null || echo '✅ 完了'"
      }
    ]
  }
}
EOF

echo "✅ settings.json 作成完了"

# ===========================================
# CLAUDE.md
# ===========================================

cat << 'EOF' > CLAUDE.md
# Agent Orchestrator + Autocoder UI 統合版

## 🔗 運用方法

```
CLI (Claude Code)          UI (Autocoder)
┌─────────────────┐       ┌─────────────────┐
│ /task 実行      │──────→│ カンバン更新     │
│ オーケストレーター│ feature│ 進捗モニタリング  │
│ エージェント進化  │ update │ リアルタイム表示  │
└─────────────────┘       └─────────────────┘
```

---

## 🚨 最重要ルール

**タスク実行は `/task` コマンドを使用**

```
/task [やりたいこと]
```

**進捗確認は `/status` コマンドまたは UI**

```
/status
```

---

## オーケストレーションフロー

```
/task [タスク]
    │
    ▼
orchestrator.md を読む
    │
    ▼
pool/ 走査 → カバレッジ計算
    │
    ▼
エージェント選択/生成
    │
    ▼
タスク実行
    │
    ▼
feature 更新 → UI反映
    │
    ▼
manifests 更新 → elite昇格チェック
```

---

## Autocoder 連携

| タイミング | ツール | UI反映 |
|-----------|--------|--------|
| プラン承認後 | feature_create_bulk | カードが表示 |
| 章完了時 | feature_mark_passing | Done列に移動 |
| 3回失敗時 | feature_skip | 優先度下げ |
| 進捗確認 | feature_get_stats | 統計表示 |

---

## ディレクトリ構造

```
.claude/
├── commands/
│   ├── task.md     ← /task（メイン）
│   └── status.md   ← /status（進捗確認）
└── agents/
    ├── orchestrator.md
    ├── _template.md
    ├── manifests/
    └── pool/
        ├── specialized/
        ├── integrated/
        └── elite/
```

---

## 使い方

### ターミナル1: UI起動
```
cd [autocoder_dir]
./start_ui.sh
→ http://localhost:5173 でモニタリング
```

### ターミナル2: CLI制作
```
cd generations/[プロジェクト名]
claude
/task 電子書籍を作りたい
```

### 進捗確認
- CLI: `/status`
- UI: カンバンボード
EOF

echo "✅ CLAUDE.md 作成完了"

# ===========================================
# 補助ファイル
# ===========================================

cat << 'EOF' > research/notes.md
# ヒアリングノート
（/task 実行時に自動記録）
EOF

cat << 'EOF' > quality-checklist.md
# 品質チェックリスト

- [ ] ペルソナの悩みに響くか
- [ ] ブランドトーンが一貫しているか
- [ ] 文字数が適切か
- [ ] 禁止事項に違反していないか
EOF

cat << 'EOF' > START_HERE.md
# 🔗 Agent Orchestrator + Autocoder UI 統合版

## 使い方（2つのターミナル）

### ターミナル1: UI起動（モニタリング）
```bash
cd [autocoder_dir]
./start_ui.sh

# ブラウザで開く
open http://localhost:5173
```

### ターミナル2: CLI制作
```bash
cd generations/[プロジェクト名]
claude

# Plan Mode ON
Shift+Tab × 2

# タスク実行
/task 電子書籍を作りたい
```

## 画面構成

```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│   ターミナル         │   ブラウザ           │
│   (Claude Code)     │   (Autocoder UI)    │
│                     │                     │
│   /task で制作       │   カンバンで確認      │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

## フロー

| CLI操作 | UI反映 |
|---------|--------|
| /task 本を作りたい → プラン承認 | カンバンに章が表示 |
| /task 第1章を書いて → 完了 | 第1章がDoneに移動 |
| /task 第2章を書いて → 完了 | 第2章がDoneに移動 |
| /status | UIと同じ進捗を表示 |
EOF

echo "✅ 補助ファイル作成完了"

echo ""
echo "=========================================="
echo "🎉 CLI + UI 統合版セットアップ完了！"
echo "=========================================="
echo ""
echo "📁 プロジェクト: $PROJECT_DIR"
echo ""
echo "🚀 使い方:"
echo ""
echo "   【ターミナル1: UI起動】"
echo "   cd $AUTOCODER_DIR"
echo "   ./start_ui.sh"
echo "   → http://localhost:5173 でモニタリング"
echo ""
echo "   【ターミナル2: CLI制作】"
echo "   cd $PROJECT_DIR"
echo "   claude"
echo "   /task 電子書籍を作りたい"
echo ""
echo "=========================================="
