#!/bin/bash

# コンテンツアイデア生成スクリプト

IDEAS_FILE="content-ideas.md"

show_help() {
    echo "コンテンツアイデア管理ツール"
    echo ""
    echo "使用法:"
    echo "  ./content-ideas.sh add \"アイデア\"     - 新しいアイデアを追加"
    echo "  ./content-ideas.sh list               - アイデア一覧を表示"
    echo "  ./content-ideas.sh random             - ランダムなアイデアを1つ表示"
    echo "  ./content-ideas.sh trending           - トレンドキーワードを追加"
}

add_idea() {
    if [ -z "$1" ]; then
        echo "アイデアを入力してください"
        return 1
    fi
    
    DATE=$(date +%Y-%m-%d)
    echo "- [ ] $1 ($DATE)" >> "$IDEAS_FILE"
    echo "アイデアを追加しました: $1"
}

list_ideas() {
    if [ ! -f "$IDEAS_FILE" ]; then
        echo "# コンテンツアイデア" > "$IDEAS_FILE"
        echo "" >> "$IDEAS_FILE"
        echo "## 未実装" >> "$IDEAS_FILE"
        echo "" >> "$IDEAS_FILE"
        echo "## 完了" >> "$IDEAS_FILE"
    fi
    
    cat "$IDEAS_FILE"
}

random_idea() {
    if [ ! -f "$IDEAS_FILE" ]; then
        echo "アイデアファイルが存在しません"
        return 1
    fi
    
    UNCHECKED=$(grep "^- \[ \]" "$IDEAS_FILE")
    if [ -z "$UNCHECKED" ]; then
        echo "未実装のアイデアがありません"
        return 1
    fi
    
    echo "🎯 今日のおすすめアイデア:"
    echo "$UNCHECKED" | sort -R | head -1 | sed 's/^- \[ \] //'
}

add_trending() {
    DATE=$(date +%Y-%m-%d)
    
    echo "トレンドキーワードベースのアイデアを追加中..."
    
    # 技術トレンドアイデア例
    TRENDING_IDEAS=(
        "AI/機械学習の最新動向について"
        "WebAssemblyの実用例"
        "サーバーレス架構の設計パターン"
        "Progressive Web Appsの実装方法"
        "マイクロフロントエンドの課題と解決策"
        "GraphQLの活用事例"
        "Dockerコンテナのセキュリティベストプラクティス"
        "CI/CDパイプラインの最適化"
        "クラウドネイティブアプリケーションの設計"
        "TypeScriptの高度な型システム活用"
    )
    
    # ランダムに3つ選択
    for i in {1..3}; do
        RANDOM_INDEX=$((RANDOM % ${#TRENDING_IDEAS[@]}))
        IDEA="${TRENDING_IDEAS[$RANDOM_INDEX]}"
        echo "- [ ] $IDEA ($DATE) #trending" >> "$IDEAS_FILE"
        echo "追加: $IDEA"
    done
}

case "$1" in
    add)
        add_idea "$2"
        ;;
    list)
        list_ideas
        ;;
    random)
        random_idea
        ;;
    trending)
        add_trending
        ;;
    *)
        show_help
        exit 1
        ;;
esac