# Claude Code Status Line - Token Usage & Rate Limit Display

Claude Code のステータスバーに以下を表示するカスタムステータスラインです：

- **モデル名** - 使用中のClaudeモデル
- **ctx** - コンテキストウィンドウ使用率
- **5h** - 5時間レートリミット使用率
- **7d** - 7日間レートリミット使用率

使用率に応じて緑→赤のグラデーションカラーでプログレスバーを表示します。

## 前提条件

以下のいずれかが必要です：

- **Node.js** (推奨) - v18以上
- **Python 3** - v3.8以上

## 自動セットアップ

### macOS / Linux

```bash
git clone <this-repo> ~/.claude/statusline
cd ~/.claude/statusline
chmod +x setup.sh
./setup.sh
```

### Windows (PowerShell)

```powershell
git clone <this-repo> $env:USERPROFILE\.claude\statusline
cd $env:USERPROFILE\.claude\statusline
.\setup.ps1
```

セットアップ後、Claude Code を再起動してください。

## 手動セットアップ

### 1. スクリプトを配置

`statusline.mjs` (Node.js版) と `statusline.py` (Python版) を `~/.claude/` にコピーします。

Windows の場合は `statusline.bat` もコピーしてください。

### 2. settings.json を編集

`~/.claude/settings.json` に以下を追加：

**Node.js を使う場合:**

```json
{
  "statusLine": {
    "type": "command",
    "command": "node ~/.claude/statusline.mjs"
  }
}
```

**Python を使う場合:**

```json
{
  "statusLine": {
    "type": "command",
    "command": "python3 ~/.claude/statusline.py"
  }
}
```

### 3. Claude Code を再起動

## ファイル構成

```
~/.claude/statusline/
├── README.md           # このファイル
├── setup.sh            # macOS/Linux セットアップスクリプト
├── setup.ps1           # Windows セットアップスクリプト
├── statusline.mjs      # Node.js版 (メイン)
├── statusline.py       # Python版 (フォールバック)
└── statusline.bat      # Windows用ラッパー
```

## 表示例

```
 Claude Opus 4.6 │ ctx ██████░░░░ 60% │ 5h ███░░░░░░░ 30% │ 7d █░░░░░░░░░ 10%
```

低使用率は緑、高使用率は赤で表示されます。
