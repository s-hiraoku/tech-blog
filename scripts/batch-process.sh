#!/bin/bash

# バッチ処理スクリプト - 複数記事の一括処理

show_help() {
    echo "バッチ処理ユーティリティ"
    echo ""
    echo "使用法:"
    echo "  ./batch-process.sh analyze     - 全ドラフトを分析"
    echo "  ./batch-process.sh optimize    - 画像を最適化"
    echo "  ./batch-process.sh backup      - バックアップを作成"
    echo "  ./batch-process.sh clean       - 一時ファイルを削除"
    echo "  ./batch-process.sh count-tags  - タグ使用統計"
}

analyze_drafts() {
    echo "=== 全ドラフト分析 ==="
    find articles/drafts -name "*.md" | while read -r file; do
        echo "分析中: $file"
        ./scripts/content-optimizer.sh "$file"
        echo "---"
    done
}

optimize_images() {
    echo "=== 画像最適化 ==="
    if command -v imageoptim > /dev/null; then
        find assets/images -name "*.jpg" -o -name "*.png" | while read -r img; do
            echo "最適化中: $img"
            imageoptim "$img"
        done
    else
        echo "ImageOptim未インストール。brew install imageoptim-cli を実行してください"
    fi
}

create_backup() {
    DATE=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="backups/backup_$DATE"
    
    echo "=== バックアップ作成: $BACKUP_DIR ==="
    mkdir -p "$BACKUP_DIR"
    
    cp -r articles/ "$BACKUP_DIR/"
    cp -r assets/ "$BACKUP_DIR/"
    cp -r templates/ "$BACKUP_DIR/"
    
    echo "バックアップ完了: $BACKUP_DIR"
}

clean_temp() {
    echo "=== 一時ファイル削除 ==="
    find . -name "*.tmp" -delete
    find . -name "*.temp" -delete
    find . -name ".DS_Store" -delete
    echo "クリーンアップ完了"
}

count_tags() {
    echo "=== タグ使用統計 ==="
    find articles -name "*.md" -exec grep "^tags:" {} \; | \
    sed 's/tags: \[\(.*\)\]/\1/' | \
    tr ',' '\n' | \
    sed 's/[" \[\]]//g' | \
    sort | uniq -c | sort -nr | head -20
}

case "$1" in
    analyze)
        analyze_drafts
        ;;
    optimize)
        optimize_images
        ;;
    backup)
        create_backup
        ;;
    clean)
        clean_temp
        ;;
    count-tags)
        count_tags
        ;;
    *)
        show_help
        exit 1
        ;;
esac