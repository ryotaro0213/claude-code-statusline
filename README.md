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

**1. ターミナルを開く**

macOSでは以下のいずれかの方法で「ターミナル」アプリを起動します：

- `Command (⌘) + Space` で Spotlight を開き、「ターミナル」または「Terminal」と入力して Enter
- `アプリケーション` → `ユーティリティ` → `ターミナル.app` をダブルクリック

Linux の場合は、お使いのディストリビューションのターミナルアプリを起動してください（多くの場合 `Ctrl + Alt + T`）。

**2. 以下のコマンドをコピーして、ターミナルに貼り付けて Enter**

ターミナルへの貼り付けは `Command (⌘) + V`（macOS）または `Ctrl + Shift + V`（Linux）です。

```bash
git clone https://github.com/ryotaro0213/claude-code-statusline-.git ~/.claude/statusline && cd ~/.claude/statusline && chmod +x setup.sh && ./setup.sh
```

> 💡 途中でパスワードを求められた場合は、Mac のログインパスワードを入力してください（入力文字は画面に表示されませんが、正しく入力されています）。

**3. Claude Code を再起動**

起動中の Claude Code を一度終了し、再度起動してください。

### Windows (PowerShell)

**1. PowerShell を開く**

- スタートメニューを開き、「PowerShell」と入力して `Windows PowerShell` を起動

**2. 以下のコマンドをコピーして、PowerShell に貼り付けて Enter**

PowerShell への貼り付けは右クリック、または `Ctrl + V` です。

```powershell
git clone https://github.com/ryotaro0213/claude-code-statusline-.git $env:USERPROFILE\.claude\statusline; cd $env:USERPROFILE\.claude\statusline; .\setup.ps1
```

> 💡 `.\setup.ps1` が実行できない場合、以下を先に実行してから再度お試しください。
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
> ```

**3. Claude Code を再起動**

起動中の Claude Code を一度終了し、再度起動してください。

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
