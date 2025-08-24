#!/bin/bash

# コンテンツ最適化スクリプト - SEOとreadability向上

if [ $# -eq 0 ]; then
    echo "使用法: ./content-optimizer.sh 記事ファイル"
    exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo "ファイルが見つかりません: $FILE"
    exit 1
fi

echo "=== コンテンツ分析: $FILE ==="
echo

# 文字数カウント
CHAR_COUNT=$(wc -m < "$FILE")
WORD_COUNT=$(wc -w < "$FILE")
LINE_COUNT=$(wc -l < "$FILE")

echo "📊 基本統計:"
echo "  - 文字数: $CHAR_COUNT"
echo "  - 単語数: $WORD_COUNT"
echo "  - 行数: $LINE_COUNT"
echo

# 見出し構造の分析
echo "📝 見出し構造:"
grep "^#" "$FILE" | while read -r line; do
    echo "  $line"
done
echo

# リンクの確認
LINK_COUNT=$(grep -o '\[.*\](.*\)' "$FILE" | wc -l | tr -d ' ')
echo "🔗 リンク数: $LINK_COUNT"
echo

# 画像の確認
IMAGE_COUNT=$(grep -o '!\[.*\](.*\)' "$FILE" | wc -l | tr -d ' ')
echo "🖼️  画像数: $IMAGE_COUNT"
echo

# コードブロックの確認
CODE_BLOCK_COUNT=$(grep -c '^```' "$FILE")
echo "💻 コードブロック数: $((CODE_BLOCK_COUNT / 2))"
echo

# SEO推奨事項
echo "🚀 SEO推奨事項:"
if [ $CHAR_COUNT -lt 1000 ]; then
    echo "  ⚠️  記事が短すぎます (推奨: 1000文字以上)"
fi

if [ $LINK_COUNT -eq 0 ]; then
    echo "  ⚠️  外部リンクを追加することを検討してください"
fi

if [ $IMAGE_COUNT -eq 0 ]; then
    echo "  ⚠️  画像やスクリーンショットの追加を検討してください"
fi

# メタデータチェック
if ! grep -q "description:" "$FILE"; then
    echo "  ⚠️  descriptionメタデータがありません"
fi

if ! grep -q "tags:" "$FILE"; then
    echo "  ⚠️  tagsメタデータがありません"
fi

# textlint校正チェック
echo
echo "📝 文章校正 (textlint):"
if command -v textlint > /dev/null; then
    textlint "$FILE" 2>/dev/null || echo "  ⚠️  文章の校正が必要です"
else
    echo "  ⚠️  textlintがインストールされていません (npm install)"
fi

echo "  ✅ 分析完了"