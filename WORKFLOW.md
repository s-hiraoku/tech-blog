# 執筆ワークフロー

## 🚀 クイックスタート

```bash
# セットアップ
npm run setup

# 新記事作成
npm run new "記事タイトル"

# 記事分析
npm run analyze

# 公開
npm run publish ファイル名.md

# 統計更新
npm run stats
```

## 📝 日常の執筆フロー

### 1. アイデア管理
```bash
# アイデア追加
./scripts/content-ideas.sh add "新しいアイデア"

# ランダムアイデア取得
./scripts/content-ideas.sh random

# トレンドアイデア生成
./scripts/content-ideas.sh trending
```

### 2. 記事作成
```bash
# 通常記事
./scripts/new-article.sh "記事タイトル"

# クイックノート
./scripts/new-article.sh "メモタイトル" quick-note
```

### 3. 品質チェック
```bash
# コンテンツ最適化
./scripts/content-optimizer.sh articles/drafts/記事.md

# 全記事分析
./scripts/batch-process.sh analyze
```

### 4. バッチ処理
```bash
# バックアップ作成
./scripts/batch-process.sh backup

# 画像最適化
./scripts/batch-process.sh optimize

# 一時ファイル削除
./scripts/batch-process.sh clean

# タグ統計
./scripts/batch-process.sh count-tags
```

## 🎯 生産性向上のコツ

### テンプレート活用
- `article-template.md`: 詳細記事用
- `quick-note-template.md`: 短いメモ用

### 自動化機能
- SEO分析 (`content-optimizer.sh`)
- バッチ処理 (`batch-process.sh`)
- アイデア管理 (`content-ideas.sh`)
- 統計レポート (`update-stats.sh`)

### 推奨エディタ設定

#### VS Code
```json
{
  "markdown.preview.breaks": true,
  "markdown.preview.linkify": true,
  "files.associations": {
    "*.md": "markdown"
  }
}
```

#### Obsidian設定
- Daily Notesプラグイン有効化
- Templatesプラグインでテンプレート連携
- Graph Viewで記事間の関連性可視化

## 📊 品質管理

### チェックリスト
- [ ] タイトルは明確で魅力的か
- [ ] メタデータ（description, tags）は設定済みか
- [ ] 1000文字以上の内容か
- [ ] 外部リンクを含むか
- [ ] 画像やコードサンプルがあるか
- [ ] 文章校正は完了したか

### SEO最適化
- 適切な見出し構造（H1-H6）
- メタディスクリプション記述
- 内部リンクの設置
- alt属性付き画像使用