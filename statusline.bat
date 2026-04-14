@echo off
chcp 65001 >nul 2>&1
where python >nul 2>&1 && (
    python "%~dp0statusline.py"
) || (
    python3 "%~dp0statusline.py"
)
