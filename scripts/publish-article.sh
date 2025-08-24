#!/bin/bash

# 記事を公開するスクリプト

if [ $# -eq 0 ]; then
    echo "使用法: ./publish-article.sh ドラフトファイル名"
    exit 1
fi

DRAFT_FILE="$1"

if [ ! -f "articles/drafts/$DRAFT_FILE" ]; then
    echo "エラー: ドラフトファイルが見つかりません: articles/drafts/$DRAFT_FILE"
    exit 1
fi

# draftフラグをfalseに変更
sed -i '' 's/draft: true/draft: false/' "articles/drafts/$DRAFT_FILE"

# publishedディレクトリに移動
mv "articles/drafts/$DRAFT_FILE" "articles/published/$DRAFT_FILE"

echo "記事を公開しました: articles/published/$DRAFT_FILE"

# 統計情報を更新
./scripts/update-stats.sh