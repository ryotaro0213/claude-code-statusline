#!/usr/bin/env bash
set -euo pipefail

# Claude Code Status Line - Setup Script (macOS / Linux)
# Displays token usage, context window, and rate limit info in the status bar.

CLAUDE_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

echo "=== Claude Code Status Line Setup ==="
echo ""

# Detect runtime
RUNTIME=""
COMMAND=""

if command -v node &>/dev/null; then
  RUNTIME="node"
  COMMAND="node ~/.claude/statusline.mjs"
  echo "[OK] Node.js detected: $(node --version)"
elif command -v python3 &>/dev/null; then
  RUNTIME="python3"
  COMMAND="python3 ~/.claude/statusline.py"
  echo "[OK] Python3 detected: $(python3 --version)"
elif command -v python &>/dev/null; then
  RUNTIME="python"
  COMMAND="python ~/.claude/statusline.py"
  echo "[OK] Python detected: $(python --version)"
else
  echo "[ERROR] Node.js or Python3 が必要です。いずれかをインストールしてください。"
  exit 1
fi

echo ""

# Ensure ~/.claude exists
mkdir -p "${CLAUDE_DIR}"

# Copy scripts
cp "${SCRIPT_DIR}/statusline.mjs" "${CLAUDE_DIR}/statusline.mjs"
cp "${SCRIPT_DIR}/statusline.py"  "${CLAUDE_DIR}/statusline.py"
echo "[OK] スクリプトを ${CLAUDE_DIR}/ にコピーしました"

# Update settings.json
if [ -f "${SETTINGS_FILE}" ]; then
  # Check if jq is available for safe JSON manipulation
  if command -v jq &>/dev/null; then
    UPDATED=$(jq --arg cmd "${COMMAND}" '.statusLine = {"type": "command", "command": $cmd}' "${SETTINGS_FILE}")
    echo "${UPDATED}" > "${SETTINGS_FILE}"
    echo "[OK] settings.json を更新しました (jq)"
  elif command -v node &>/dev/null; then
    node -e "
      const fs = require('fs');
      const f = '${SETTINGS_FILE}';
      const d = JSON.parse(fs.readFileSync(f, 'utf8'));
      d.statusLine = { type: 'command', command: '${COMMAND}' };
      fs.writeFileSync(f, JSON.stringify(d, null, 2) + '\n');
    "
    echo "[OK] settings.json を更新しました (node)"
  elif command -v python3 &>/dev/null || command -v python &>/dev/null; then
    PY=$(command -v python3 || command -v python)
    "${PY}" -c "
import json, pathlib
f = pathlib.Path('${SETTINGS_FILE}')
d = json.loads(f.read_text())
d['statusLine'] = {'type': 'command', 'command': '${COMMAND}'}
f.write_text(json.dumps(d, indent=2) + '\n')
"
    echo "[OK] settings.json を更新しました (python)"
  else
    echo "[WARN] settings.json の自動更新に失敗しました。手動で以下を追加してください:"
    echo ""
    echo '  "statusLine": {'
    echo '    "type": "command",'
    echo "    \"command\": \"${COMMAND}\""
    echo '  }'
  fi
else
  # Create new settings.json
  cat > "${SETTINGS_FILE}" <<JSONEOF
{
  "statusLine": {
    "type": "command",
    "command": "${COMMAND}"
  }
}
JSONEOF
  echo "[OK] settings.json を新規作成しました"
fi

echo ""
echo "=== セットアップ完了 ==="
echo "Claude Code を再起動すると、ステータスラインにトークン使用量が表示されます。"
echo "使用ランタイム: ${RUNTIME} (${COMMAND})"
