@echo off
setlocal
cd /d "%~dp0"
title Windows Terminal Setup Installer

:: Check for Administrator privileges and elevate if needed
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -NoProfile -Command "Start-Process cmd.exe -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Starting Windows Terminal ^& PowerShell Installer...
echo ============================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

echo.
echo Press any key to exit...
pause >nul
