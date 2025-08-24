#!/bin/bash

# 新しい記事を作成するスクリプト

if [ $# -eq 0 ]; then
    echo "使用法: ./new-article.sh \"記事タイトル\" [quick-note]"
    exit 1
fi

TITLE="$1"
TYPE="${2:-article}"
DATE=$(date +"%Y-%m-%d")
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

if [ "$TYPE" = "quick-note" ]; then
    TEMPLATE="templates/quick-note-template.md"
    FILEPATH="articles/drafts/${DATE}-${FILENAME}.md"
else
    TEMPLATE="templates/article-template.md"
    FILEPATH="articles/drafts/${DATE}-${FILENAME}.md"
fi

# テンプレートをコピーして必要な情報を埋め込み
cp "$TEMPLATE" "$FILEPATH"
sed -i '' "s/title: \"\"/title: \"$TITLE\"/" "$FILEPATH"
sed -i '' "s/date: /date: $DATE/" "$FILEPATH"

echo "新しい記事を作成しました: $FILEPATH"
echo "エディタで開きますか？ [y/N]"
read -r response
if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    ${EDITOR:-code} "$FILEPATH"
fi