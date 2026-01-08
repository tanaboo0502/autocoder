# Autocoder 完全操作マニュアル

## 概要

**Autocoder**は、あらゆる制作物を自律的に生成するAIエージェントシステム。
CLIで指示、UIで進捗確認。並列実行とエージェント進化により高速・高品質な成果物を生成。

---

## クイックスタート

### たった1コマンドで開始

```bash
claude
/task [作りたいもの]
```

これだけ。プロジェクト作成、登録、UI起動まで全自動。

---

## 対応プロジェクト一覧

### コンテンツ制作

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| 電子書籍 | `/task 電子書籍を作りたい` | .md → .epub/.pdf |
| ブログ記事 | `/task ブログ記事を書きたい` | .md |
| LP（ランディングページ） | `/task LPを作りたい` | .html/.css/.js |
| プレゼン資料 | `/task スライドを作りたい` | .pptx/.md |
| 動画台本 | `/task YouTube台本を作りたい` | .md |
| ポッドキャスト台本 | `/task 音声コンテンツの台本` | .md |
| SNS投稿 | `/task SNS投稿を量産したい` | .md/.txt |
| メルマガ | `/task メルマガシリーズを作りたい` | .md |
| 広告コピー | `/task 広告文を作りたい` | .txt |
| プレスリリース | `/task プレスリリースを書きたい` | .md/.docx |

### Webアプリケーション

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| React SPA | `/task Reactアプリを作りたい` | .tsx/.ts/.css |
| Next.js | `/task Next.jsサイトを作りたい` | .tsx/.ts |
| Vue.js | `/task Vueアプリを作りたい` | .vue/.ts |
| 静的サイト | `/task 静的サイトを作りたい` | .html/.css/.js |
| ダッシュボード | `/task 管理画面を作りたい` | .tsx + API |
| ECサイト | `/task ECサイトを作りたい` | フルスタック |
| ポートフォリオ | `/task ポートフォリオサイト` | .html/.css/.js |
| ブログシステム | `/task ブログシステムを作りたい` | CMS構成 |

### モバイルアプリ

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| React Native | `/task モバイルアプリを作りたい` | .tsx |
| Flutter | `/task Flutterアプリを作りたい` | .dart |
| PWA | `/task PWAを作りたい` | .tsx + manifest |

### バックエンド・API

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| REST API | `/task APIサーバーを作りたい` | .py/.ts |
| GraphQL | `/task GraphQL APIを作りたい` | .ts + schema |
| FastAPI | `/task FastAPIサーバーを作りたい` | .py |
| Express | `/task Expressサーバーを作りたい` | .ts |
| データベース設計 | `/task DB設計をしたい` | .sql + ERD |
| 認証システム | `/task 認証機能を作りたい` | Auth実装 |

### CLI・ツール

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| CLIツール | `/task CLIツールを作りたい` | .py/.ts |
| 自動化スクリプト | `/task 自動化したい` | .py/.sh |
| Chrome拡張 | `/task Chrome拡張を作りたい` | manifest + .js |
| VSCode拡張 | `/task VSCode拡張を作りたい` | .ts |
| Slackボット | `/task Slackボットを作りたい` | .py/.ts |
| Discordボット | `/task Discordボットを作りたい` | .py/.ts |

### AI・機械学習

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| MCPサーバー | `/task MCPサーバーを作りたい` | .py/.ts |
| AIエージェント | `/task AIエージェントを作りたい` | .py |
| RAGシステム | `/task RAG検索を作りたい` | .py + vector |
| チャットボット | `/task チャットボットを作りたい` | .py/.ts |
| 画像生成パイプライン | `/task 画像生成ワークフロー` | .py |

### データ・分析

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| データ分析 | `/task データ分析をしたい` | .ipynb/.py |
| 可視化ダッシュボード | `/task 可視化したい` | .py + Streamlit |
| ETLパイプライン | `/task データパイプライン` | .py |
| レポート自動生成 | `/task レポート自動化` | .py → .pdf |

### ドキュメント

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| 技術ドキュメント | `/task ドキュメントを整備したい` | .md |
| API仕様書 | `/task API仕様書を作りたい` | OpenAPI/.md |
| 設計書 | `/task 設計書を作りたい` | .md/.docx |
| マニュアル | `/task マニュアルを作りたい` | .md/.pdf |
| README | `/task READMEを書きたい` | README.md |

### ビジネス

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| 事業計画書 | `/task 事業計画を作りたい` | .md/.pptx |
| 提案書 | `/task 提案書を作りたい` | .md/.pptx |
| 契約書テンプレート | `/task 契約書を作りたい` | .md/.docx |
| 見積書 | `/task 見積書を作りたい` | .xlsx |
| 請求書 | `/task 請求書を作りたい` | .xlsx/.pdf |

### デザイン

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| UIデザイン | `/task UIをデザインしたい` | Figma風/.html |
| ワイヤーフレーム | `/task ワイヤーフレーム` | .html/.svg |
| デザインシステム | `/task デザインシステム` | CSS vars + components |
| アイコンセット | `/task アイコンを作りたい` | .svg |
| ロゴ案 | `/task ロゴ案を作りたい` | .svg + コンセプト |

### ゲーム

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| ブラウザゲーム | `/task ブラウザゲームを作りたい` | .html/.js |
| p5.jsアート | `/task ジェネラティブアート` | .js |
| テキストゲーム | `/task テキストゲームを作りたい` | .py/.js |

### インフラ・DevOps

| タイプ | 例 | 生成物 |
|--------|-----|--------|
| Docker構成 | `/task Docker化したい` | Dockerfile + compose |
| CI/CD | `/task CI/CDを設定したい` | .github/workflows |
| Terraform | `/task インフラをコード化` | .tf |
| Kubernetes | `/task K8s構成を作りたい` | .yaml |

---

## コマンド一覧

### メインコマンド

| コマンド | 説明 |
|---------|------|
| `/task [内容]` | タスク開始（自動でプロジェクト作成/継続判定） |
| `/status` | 進捗確認（UI連携） |

### サブコマンド（/task の後に使用）

| 入力例 | 動作 |
|--------|------|
| `/task 〇〇を作りたい` | 新規企画開始 |
| `/task 続きをやって` | 既存プロジェクト継続 |
| `/task 書いて` / `/task 実装して` | 実装フェーズ開始 |
| `/task テストして` | テスト実行 |
| `/task デプロイして` | デプロイ実行 |
| `/task レビューして` | コードレビュー |
| `/task リファクタして` | リファクタリング |
| `/task ドキュメント書いて` | ドキュメント生成 |

---

## ワークフロー詳細

### 新規プロジェクト自動判定

```
/task 〇〇を作りたい
    │
    ▼
プロジェクト名を抽出
    │
    ▼
┌─────────────────────────────────┐
│ generations/[name]/ が存在する？ │
└─────────────────────────────────┘
    │           │
   YES          NO
    │           │
    ▼           ▼
既存継続     新規作成
    │           │
    │           ├─ mkdir generations/[name]
    │           ├─ 構造生成（prompts/, content/, .claude/）
    │           ├─ レジストリ登録
    │           └─ UI自動起動 + ブラウザ表示
    │           │
    └───────────┘
            │
            ▼
    対話型ヒアリング開始
```

### フェーズ1: 企画（Planning）

```
対話型ヒアリング
    │
    ├─ Q1: 何を作りたい？
    │      ↓ 回答
    ├─ Q2: 誰向け？
    │      ↓ 回答
    ├─ Q3: 詳細要件
    │      ↓ 回答
    ▼
並列調査（Task tool × 複数エージェント）
    ├─ 市場調査エージェント
    ├─ 技術調査エージェント
    └─ 競合調査エージェント
    │
    ▼
プラン提示
    │
    ▼ ユーザー承認
    │
feature_create_bulk → UI表示
```

### フェーズ2: 実装（Implementation）

```
/task 実装して
    │
    ▼
feature_get_next
    │
    ▼
エージェント選択/生成
    │
    ▼
並列実装（Task tool）
    ├─ Feature 1 → Agent A (background)
    ├─ Feature 2 → Agent B (background)
    └─ Feature 3 → Agent C (background)
    │
    ▼
TaskOutput で結果取得
    │
    ▼
検証（lint/test/build）
    │
    ▼
feature_mark_passing → UI更新
```

### フェーズ3: 検証（Verification）

```
/task テストして
    │
    ▼
テストスイート実行
    ├─ Unit Tests
    ├─ Integration Tests
    └─ E2E Tests（Playwright）
    │
    ▼
カバレッジレポート
    │
    ▼
失敗があれば自動修正
```

### フェーズ4: デプロイ（Deployment）

```
/task デプロイして
    │
    ▼
ビルド
    │
    ▼
デプロイ先判定
    ├─ Vercel
    ├─ Netlify
    ├─ AWS
    ├─ GCP
    └─ 自前サーバー
    │
    ▼
デプロイ実行
    │
    ▼
URL発行・通知
```

---

## 並列実行パターン

### パターン1: 独立タスクの並列実行

```
┌─────────────────────────────────────┐
│ Task tool × 3 (run_in_background)   │
├─────────────────────────────────────┤
│ Agent 1 → chapter_1.md              │
│ Agent 2 → chapter_2.md              │
│ Agent 3 → chapter_3.md              │
└─────────────────────────────────────┘
          │
          ▼
    TaskOutput × 3
          │
          ▼
    結果マージ
```

### パターン2: 調査の並列実行

```
┌─────────────────────────────────────┐
│ Task tool × 3 (subagent_type=Explore)│
├─────────────────────────────────────┤
│ Agent 1 → 市場調査                   │
│ Agent 2 → 技術調査                   │
│ Agent 3 → 競合調査                   │
└─────────────────────────────────────┘
```

### パターン3: ビルド＆テストの並列実行

```
┌─────────────────────────────────────┐
│ Bash × 3 (run_in_background)        │
├─────────────────────────────────────┤
│ Shell 1 → npm run build             │
│ Shell 2 → npm run test              │
│ Shell 3 → npm run lint              │
└─────────────────────────────────────┘
```

---

## エージェント進化システム

### プール構造

```
.claude/agents/pool/
├── specialized/     # 専門エージェント
│   ├── writer.md
│   ├── coder.md
│   ├── designer.md
│   └── analyst.md
├── integrated/      # 統合エージェント
│   ├── fullstack.md
│   └── content-creator.md
└── elite/           # 昇格エージェント（最優先）
    └── senior-dev.md
```

### 自動生成ルール

| カバレッジ | アクション |
|-----------|-----------|
| 90%以上 | 既存エージェント使用 |
| 60-90% | 統合エージェント生成 |
| 60%未満 | 新規専門エージェント生成 |

### 昇格条件

```
IF usage_count >= 5 AND success_rate >= 80%:
    move to elite/
    tier = "elite"
```

### マニフェスト例

```yaml
# manifests/writer.yaml
name: writer
tier: specialized
skills:
  - creative-writing
  - storytelling
  - persona-aware
metrics:
  usage_count: 12
  success_count: 10
  success_rate: 83.3
  last_used: 2025-01-08
```

---

## スキルシステム

### 組み込みスキル

| スキル | 用途 |
|--------|------|
| `frontend-design` | 高品質UI生成 |
| `pdf` | PDF生成・編集 |
| `docx` | Word文書生成 |
| `pptx` | PowerPoint生成 |
| `xlsx` | Excel生成 |
| `mcp-builder` | MCPサーバー構築 |
| `algorithmic-art` | ジェネラティブアート |

### スキル呼び出し

```
/task スライドを作りたい
    │
    ▼
Skill tool → pptx スキル起動
    │
    ▼
専用ワークフロー実行
```

---

## MCP ツール一覧

### Feature管理

| ツール | 用途 |
|--------|------|
| `feature_create_bulk` | 一括登録 |
| `feature_get_next` | 次タスク取得 |
| `feature_get_for_regression` | 回帰テスト用取得 |
| `feature_mark_passing` | 完了マーク |
| `feature_skip` | スキップ |
| `feature_get_stats` | 統計取得 |

### Context7（ドキュメント検索）

| ツール | 用途 |
|--------|------|
| `resolve-library-id` | ライブラリID解決 |
| `query-docs` | ドキュメント検索 |

### IDE連携

| ツール | 用途 |
|--------|------|
| `getDiagnostics` | エラー診断取得 |
| `executeCode` | Jupyter実行 |

### Codex

| ツール | 用途 |
|--------|------|
| `codex` | Codexセッション開始 |
| `codex-reply` | Codex会話継続 |

---

## UI機能

### カンバンボード

| 列 | 状態 | 色 |
|----|------|-----|
| Pending | 未着手 | 黄色 |
| In Progress | 実装中 | シアン |
| Done | 完了 | 緑 |

### リアルタイム更新

```
CLI で feature 更新
    ↓ WebSocket
UI カンバン自動更新
```

### プロジェクト切り替え

左サイドバーで登録済みプロジェクトを選択

### エージェントログ

実行中のエージェント出力をリアルタイム表示

---

## ディレクトリ構成

### 標準構成（自動生成）

```
generations/
└── [project-name]/
    ├── prompts/
    │   ├── app_spec.txt        # 仕様書
    │   ├── initializer_prompt.md
    │   └── coding_prompt.md
    ├── src/                    # ソースコード
    │   ├── components/
    │   ├── pages/
    │   └── ...
    ├── content/                # コンテンツ
    │   ├── chapter_1.md
    │   └── ...
    ├── research/               # 調査結果
    │   ├── persona.md
    │   ├── brand-voice.md
    │   └── market-analysis.md
    ├── tests/                  # テスト
    ├── docs/                   # ドキュメント
    ├── features.db             # 進捗DB
    ├── package.json            # 依存関係
    ├── .agent.lock             # ロックファイル
    └── .claude/
        ├── commands/
        │   └── task.md
        └── agents/
            ├── orchestrator.md
            └── pool/
```

---

## 環境変数

```bash
# .env または環境変数
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...        # 必要に応じて
```

---

## トラブルシューティング

### プロジェクトが表示されない

```bash
# レジストリ確認
sqlite3 ~/.autocoder/registry.db "SELECT * FROM projects;"

# 手動登録
python -c "
from registry import register_project
register_project('name', '/path/to/project')
"
```

### feature が更新されない

```bash
sqlite3 features.db "
UPDATE features SET passes = 1 WHERE name = 'feature_name';
"
```

### エージェントがスタックした

```bash
# ロックファイル削除
rm .agent.lock

# 再開
/task 続きをやって
```

### UI が起動しない

```bash
# 手動起動
cd /Users/hiroyuki/autocoder2/autocoder
./start_ui.sh

# または
cd ui && npm run dev
```

### 並列エージェントがタイムアウト

```bash
# タイムアウト延長
TaskOutput(task_id="xxx", timeout=120000)  # 2分に延長
```

---

## ベストプラクティス

### 1. 明確な指示を出す

```
❌ /task アプリ作って
✅ /task ToDoアプリを作りたい。React + TypeScript で、ローカルストレージに保存
```

### 2. 対話には具体的に答える

```
Q: 誰向けですか？
❌ みんな
✅ プログラミング初心者、20-30代、副業に興味がある人
```

### 3. 並列実行を活用

独立したタスクは同時実行で高速化

### 4. UIで進捗監視

ターミナルとブラウザを並べて作業

### 5. こまめにコミット

```
/task コミットして
```

### 6. YOLOモードを使い分け

```bash
# 高速プロトタイプ（テストスキップ）
--yolo

# 本番品質（テストあり）
通常モード
```

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2026-01-08 | 完全版マニュアル作成 |
| - | 対応プロジェクト一覧追加 |
| - | 自動プロジェクト作成対応 |
| - | UI自動起動対応 |

---

*Autocoder - Build Anything, Autonomously*
