# 技術ブログ執筆プラットフォーム

記事を効率的に大量生産するためのシンプルな執筆環境

## ディレクトリ構造

```
├── articles/
│   ├── drafts/          # ドラフト記事
│   └── published/       # 公開済み記事
├── assets/
│   ├── images/          # 画像ファイル
│   └── videos/          # 動画ファイル
├── templates/           # 記事テンプレート
├── scripts/             # 自動化スクリプト
└── STATS.md            # 執筆統計
```

## 使用方法

### 新しい記事を作成
```bash
./scripts/new-article.sh "記事タイトル"
```

### クイックノートを作成
```bash
./scripts/new-article.sh "ノートタイトル" quick-note
```

### 記事を公開
```bash
./scripts/publish-article.sh ファイル名.md
```

### 統計更新
```bash
./scripts/update-stats.sh
```

### 文章校正
```bash
npm run lint          # textlintチェック（AI文体検出含む）
npm run lint:fix      # 自動修正
```

## テンプレート

- `article-template.md`: 通常の記事用
- `quick-note-template.md`: 短い技術メモ用

## ワークフロー

1. `new-article.sh`で新記事作成
2. `articles/drafts/`で執筆
3. `publish-article.sh`で公開
4. 自動で統計更新