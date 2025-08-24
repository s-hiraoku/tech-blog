#!/bin/bash

# 執筆統計を更新するスクリプト

DRAFTS_COUNT=$(find articles/drafts -name "*.md" | wc -l | tr -d ' ')
PUBLISHED_COUNT=$(find articles/published -name "*.md" | wc -l | tr -d ' ')
TOTAL_COUNT=$((DRAFTS_COUNT + PUBLISHED_COUNT))

# タグ別統計
echo "# 執筆統計" > STATS.md
echo "" >> STATS.md
echo "- **総記事数**: $TOTAL_COUNT" >> STATS.md
echo "- **公開済み**: $PUBLISHED_COUNT" >> STATS.md
echo "- **ドラフト**: $DRAFTS_COUNT" >> STATS.md
echo "" >> STATS.md
echo "## 最近の記事" >> STATS.md

# 最新5記事を表示
find articles/published -name "*.md" -exec ls -t {} \; | head -5 | while read -r file; do
    TITLE=$(grep "^title:" "$file" | sed 's/title: "//' | sed 's/"//')
    DATE=$(grep "^date:" "$file" | sed 's/date: //')
    echo "- [$TITLE]($file) ($DATE)" >> STATS.md
done

echo "" >> STATS.md
echo "最終更新: $(date)" >> STATS.md

echo "統計情報を更新しました: STATS.md"