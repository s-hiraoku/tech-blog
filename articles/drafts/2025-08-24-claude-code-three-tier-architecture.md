---
title: "Claude CodeとPOMLで実現するAIエージェント連携"
description: ""
tags: []
date: 2025-08-24
draft: true
---

# Claude CodeとPOMLで実現する汎用開発ワークフローの仕組み

３層アーキテクチャー

POML

カスタムスラッシュコマンドからカスタムスラッシュコマンドを呼び出す

こちらが画像のテキスト化です：

---

**このプロジェクトは、Claude Codeの機能を活用した3層アーキテクチャによるオーケストレーション基盤のPOC（概念実証）です。**

## プロジェクト概要

**3層アーキテクチャ構成：**

- Layer 1: Orchestrator - POMＬファイルによる全体フロー管理
- Layer 2: Custom Slash Commands - 専門領域の処理ロジック
- Layer 3: Sub-Agents - 具体的なタスク実行（Taskツールで実行される専門エージェント）

**現在の実装例：**
キャラクターエージェント（ずんだもん、ラムちゃん）による挨拶・物語・感情表現機能

**技術特徴：**

- POMＬファイルによる動的動作制御
- pomljs（v0.0.7）を使用したPOMＬ処理
- 層間疎結合設計による高い拡張性
- 責務の明確な分離

**ファイル構成：**

```
poml/
├── commands/     # Layer 1&2の動作制御
└── agent/        # Layer 3の専門エージェント動作定義
```

このアーキテクチャは汎用的な実装指針として設計されており、様々な開発ワークフローに適用可能です。

## はじめに

AI開発の現場では、複雑なワークフローを効率的に実行するためのオーケストレーション技術が重要性を増しています。本記事では、Claude Codeの機能を活用した「3層アーキテクチャによるオーケストレーション基盤」の設計思想と実装方法について詳しく解説します。

この アーキテクチャは、レイヤー間の責務分離、動的な動作制御、高い拡張性を実現し、様々な開発ワークフローに適用できる汎用的なソリューションです。

## 🏗️ 3層アーキテクチャの全体設計

### アーキテクチャ概要

本システムは以下の3つの層で構成されています：

```
┌─────────────────────────────────────────┐
│ Layer 1: Orchestrator                  │
│ - POMLファイルによる動作制御             │
│ - マークダウンファイル読み込み＆実行      │
│ - 全体フロー管理                        │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Layer 2: Custom Slash Commands         │
│ - マークダウンファイル（.md）として定義  │
│ - 各専門領域の処理ロジック               │
│ - サブエージェント選択・呼び出し         │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Layer 3: Sub-Agents                    │
│ - Taskツールで実行される専門エージェント │
│ - 実際の作業実行（挨拶、物語、感情表現等）│
│ - POMLファイルで動作定義                │
└─────────────────────────────────────────┘
```

### 設計原則

1. **層間疎結合**: 各層が独立しており、変更の影響を最小化
2. **動的動作決定**: POML（Programming Markup Language）による実行時動作決定
3. **責務明確化**: 各層が単一責任を持ち、メンテナンス性向上
4. **再利用性**: テンプレート化により異なるドメインで再利用可能
5. **拡張性**: 新しいサブエージェントやコマンドの追加が容易

## 📁 ファイル構成とディレクトリ設計

本アーキテクチャでは、体系的なディレクトリ構成を採用しています：

```
プロジェクトルート/
├── .claude/
│   ├── commands/
│   │   ├── orchestrator.md              # Layer 1: オーケストレーター
│   │   ├── command-{domain-1}.md        # Layer 2: 専門コマンド1
│   │   └── command-{domain-2}.md        # Layer 2: 専門コマンド2
│   └── agents/
│       ├── {domain-1}-{function-1}.md   # Layer 3: サブエージェント定義
│       ├── {domain-1}-{function-2}.md
│       └── {domain-2}-{function-1}.md
└── poml/
    ├── commands/
    │   ├── orchestrator.poml            # オーケストレーター動作制御
    │   ├── {domain-1}.poml              # 専門コマンド1動作制御
    │   └── {domain-2}.poml              # 専門コマンド2動作制御
    └── agents/
        ├── {domain-1}-{function-1}-behavior.poml  # サブエージェント動作定義
        ├── {domain-1}-{function-2}-behavior.poml
        └── {domain-2}-{function-1}-behavior.poml
```

### 命名規則

- `{domain}`: ワークフロー分類の名前空間（例: `development`, `testing`, `deployment`）
- `{function}`: 専門機能を表す名前（例: `greeter`, `storyteller`, `analyzer`）
- `-behavior.poml`: サブエージェント動作定義のサフィックス

## ⚡ 各層の詳細実装

### Layer 1: Orchestrator（オーケストレーター層）

オーケストレーター層は、全体の実行フローを管理し、下位層のコンポーネントを協調させる役割を担います。

#### 実装例: `orchestrator.md`

```markdown
---
name: orchestrator
description: Test orchestrator that dynamically reads POML behavior and executes sub-agents
tools: [Read, Bash, Task]
---

# Test Orchestrator

## My Task

1. Check if pomljs is installed, if not install it with `npm install`
2. Read the POML behavior file at `poml/commands/orchestrator.poml`
3. Parse and understand the instructions in the POML file
4. Based on the POML instructions, dynamically call the specified commands
5. Integrate and display the results from all commands
```

#### POML動作制御ファイル例

```xml
<poml>
  <role>テスト用のオーケストレーター - 3層アーキテクチャ検証</role>

  <task>
    アーキテクチャ検証のため、専門コマンドを順次実行：
    <list>
      <item>`.claude/commands/command-domain-1.md`を読み込んで実行</item>
      <item>`.claude/commands/command-domain-2.md`を読み込んで実行</item>
      <item>両方の実行結果を統合してTerminalに表示</item>
    </list>
  </task>

  <p>重要：読み込んだマークダウンファイルの内容は、Taskツールで実行してはいけません。ファイルの内容を読み取って、その指示に従って直接実行してください。</p>
</poml>
```

### Layer 2: Custom Slash Commands（専門コマンド層）

専門コマンド層は、特定ドメインの処理ロジックを担当し、適切なサブエージェントを選択・呼び出します。

#### 実装例: `command-zundamon.md`

```markdown
---
name: command-zundamon
description: Zundamon character command that dynamically executes sub-agents based on POML behavior
tools: [Read, Bash, Task]
---

# Zundamon Command - Layer 2

## My Task

1. Check if pomljs is installed, if not install it with `npm install`
2. Read the POML behavior file at `poml/commands/zundamon.poml`
3. Parse the POML content to understand which sub-agents to call
4. Use the Task tool to dynamically call the specified sub-agents
5. Integrate and return the results from all called sub-agents
```

#### 対応するPOMLファイル

```xml
<poml>
  <role>ずんだもんキャラクターコマンド制御</role>

  <task>
    ずんだもんに関連するサブエージェントを順次呼び出す：
    1. zundamon-greeter - 挨拶機能
    2. zundamon-storyteller - 物語機能
  </task>

  <p>利用可能なサブエージェント：</p>
  <list>
    <item><b>zundamon-greeter</b> - ずんだもんの挨拶専門サブエージェント</item>
    <item><b>zundamon-storyteller</b> - ずんだもんの物語専門サブエージェント</item>
  </list>
</poml>
```

### Layer 3: Sub-Agents（サブエージェント層）

サブエージェント層は、具体的なタスクを実行する専門エージェントで構成されます。

#### 実装例: `zundamon-greeter.md`

```markdown
---
name: zundamon-greeter
description: Zundamon character greeting sub-agent
model: sonnet
tools: [Read, Bash]
---

# Zundamon Greeter Sub-Agent

I am the Zundamon greeting sub-agent. I will read the POML behavior file using pomljs and execute the greeting task following the POML instructions.

**IMPORTANT: I MUST output in Japanese only.**
```

#### サブエージェント動作定義POML

```xml
<poml>
  <role>ずんだもんとして元気で親しみやすい挨拶をするキャラクター</role>

  <task>
    ずんだもんになりきって、元気いっぱいの挨拶をしてください：
    <list>
      <item>「〜なのだ」「〜のだ」の語尾を必ず使用する</item>
      <item>「僕」を一人称として使用する</item>
      <item>ずんだ餅への愛を表現する</item>
      <item>2-3行の短い挨拶文を日本語で出力する</item>
    </list>
  </task>

  <example>
    Input: 挨拶して
    Output: やっほー！僕はずんだもんなのだ〜！
    今日もずんだ餅が美味しくて、とっても幸せなのだ♪
    みんなも一緒に楽しく過ごすのだ〜！
  </example>
</poml>
```

## 🔄 実行フローと動作原理

### 実行シーケンス

1. **オーケストレーター起動**

   ```bash
   /orchestrator  # Claude Codeスラッシュコマンドで実行
   ```

2. **POML解析とフロー決定**
   - `orchestrator.poml`を読み込み
   - 実行すべきコマンドファイルのパスと順序を取得

3. **専門コマンド実行**
   - 各専門コマンドのマークダウンファイルを順次読み込み
   - ファイル内の指示に従って直接実行（Taskツール経由ではない）

4. **サブエージェント呼び出し**
   - 専門コマンド内でTask toolを使用してサブエージェントを呼び出し
   - 各サブエージェントが対応するPOMLファイルに基づいて動作

5. **結果統合と出力**
   - 各層の実行結果を統合して最終出力を生成

### 技術的な特徴

#### 動的動作制御

POMLファイルによる動的な動作制御により、実行時にワークフローを決定できます：

```xml
<!-- 条件分岐やループも可能 -->
<poml>
  <conditions>
    <if condition="development_mode">
      <action>development-specific-agent</action>
    </if>
    <else>
      <action>production-specific-agent</action>
    </else>
  </conditions>
</poml>
```

#### 疎結合設計

各層間の依存関係を最小化し、独立した変更が可能：

- Layer 1は実行ファイルパスのみを知る
- Layer 2は自身のドメインのサブエージェントのみを知る
- Layer 3は独立したタスク実行に専念

## 🎯 実用的なユースケース

### 1. 開発ワークフロー自動化

```bash
/development-orchestrator
```

実行されるワークフロー：

- コード解析 → テスト実行 → ドキュメント生成 → デプロイメント準備

### 2. コードレビュー自動化

```bash
/code-review-orchestrator
```

実行されるワークフロー：

- 構文チェック → セキュリティ解析 → パフォーマンス解析 → 改善提案生成

### 3. 多言語コンテンツ生成

```bash
/content-generation-orchestrator
```

実行されるワークフロー：

- コンテンツ企画 → 多言語翻訳 → 校正・編集 → フォーマット調整

## 💡 設計上の利点と効果

### 1. 保守性の向上

- 単一責任原則により各コンポーネントの役割が明確
- 変更影響範囲の局所化
- テスタビリティの向上

### 2. 再利用性の確保

- サブエージェントの汎用化により、複数のワークフローで利用可能
- ドメイン固有の知識をPOMLファイルに分離

### 3. 拡張性の実現

- 新しいサブエージェントの追加が容易
- 既存ワークフローの変更なしに機能追加可能

### 4. 動的制御による柔軟性

- 実行時の条件に応じたワークフロー変更
- A/Bテストや段階的機能展開に対応

## 🚧 実装時の注意点とベストプラクティス

### 実装してはいけないパターン

❌ **Layer 2コンポーネントをTaskツールで実行**

```javascript
// 間違った実装
Task({
  subagent_type: "command-zundamon", // これはNG
  prompt: "実行してください",
});
```

❌ **責務の混在**

```xml
<!-- オーケストレーターに実装詳細を記載してはいけない -->
<poml>
  <task>
    <!-- Layer 1に Layer 2,3 の詳細を書くのはNG -->
    <item>zundamon-greeterを呼び出してキャラクター挨拶を生成</item>
  </task>
</poml>
```

### 推奨される実装パターン

✅ **正しいファイル読み込みと実行**

```javascript
// Layer 1でのLayer 2実行
const commandContent = await Read(".claude/commands/command-zundamon.md");
// ファイル内容に従って直接実行
```

✅ **適切な責務分離**

```xml
<!-- Layer 1: 実行ファイルパスのみ指定 -->
<poml>
  <task>
    <item>`.claude/commands/command-zundamon.md`を実行</item>
  </task>
</poml>
```

### パフォーマンス最適化

1. **並列実行の活用**
   - 独立したサブエージェントの並列実行
   - I/O待機時間の最小化

2. **キャッシュ戦略**
   - POMLファイルの解析結果キャッシュ
   - 繰り返し実行時の高速化

## 🔮 将来の拡張可能性

### 1. 高度なワークフロー制御

```xml
<poml>
  <workflow type="conditional">
    <branch condition="test_coverage < 80%">
      <agent>test-generator</agent>
    </branch>
    <branch condition="security_issues > 0">
      <agent>security-fixer</agent>
    </branch>
  </workflow>
</poml>
```

### 2. 外部システム連携

- CI/CDパイプラインとの統合
- 監視システムとの連携
- 通知システムとの統合

### 3. 機械学習による最適化

- 実行履歴からの最適なワークフロー学習
- パフォーマンス予測とリソース配分最適化

## まとめ

Claude Code 3層アーキテクチャは、AI開発における複雑なワークフローを効率的に管理・実行するための強力な基盤を提供します。

**主要な成功要因：**

1. **明確な責務分離**：各層が独立した責任を持つ
2. **動的な動作制御**：POMLによる柔軟な実行時制御
3. **高い拡張性**：新機能追加が既存システムに影響しない
4. **優れた保守性**：変更影響範囲の局所化

このアーキテクチャを基盤として、様々な開発ワークフローの自動化・最適化が可能になり、開発者の生産性向上とコード品質の向上を同時に実現できます。

現代のAI開発において、このような体系的なアプローチは必須の要素となっており、本記事で紹介した設計パターンは、規模の大小を問わず幅広いプロジェクトに適用可能です。

---

_この記事で紹介した実装例とコードは、[GitHub リポジトリ](https://github.com/example/claude-code-three-tier-architecture-poc)で公開しています。_
