<#
.SYNOPSIS
    Windows Terminal & PowerShell Reset / Uninstaller Script
.DESCRIPTION
    Script to remove customizations and restore PowerShell and Windows Terminal to default settings.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host "   Windows Terminal & PowerShell Settings Reset           " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Are you sure you want to reset Terminal settings to defaults? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Reset canceled." -ForegroundColor Cyan
    exit 0
}

Write-Host ""
Write-Host "[1/2] Removing configuration files..." -ForegroundColor Yellow

# Remove files in User Home
$userFiles = @(
    "$HOME\tokyonight_storm.omp.json",
    "$HOME\.posh-cache.ps1",
    "$HOME\.posh-cache-pwsh.ps1",
    "$HOME\.posh-cache-powershell.ps1"
)
foreach ($f in $userFiles) {
    if (Test-Path $f) {
        Remove-Item -Force $f -ErrorAction SilentlyContinue
        Write-Host "  [OK] Removed: $f" -ForegroundColor Green
    }
}

# Remove Fastfetch config
$ffDir = "$HOME\.config\fastfetch"
if (Test-Path $ffDir) {
    Remove-Item -Recurse -Force $ffDir -ErrorAction SilentlyContinue
    Write-Host "  [OK] Removed: $ffDir" -ForegroundColor Green
}

# Reset PowerShell Profiles & Format XML
$psDirs = @(
    "$HOME\Documents\WindowsPowerShell",
    "$HOME\Documents\PowerShell"
)
foreach ($dir in $psDirs) {
    $prof = Join-Path $dir "Microsoft.PowerShell_profile.ps1"
    $xml = Join-Path $dir "ColoredMode.format.ps1xml"
    if (Test-Path $prof) {
        Remove-Item -Force $prof -ErrorAction SilentlyContinue
        Write-Host "  [OK] Removed: $prof" -ForegroundColor Green
    }
    if (Test-Path $xml) {
        Remove-Item -Force $xml -ErrorAction SilentlyContinue
        Write-Host "  [OK] Removed: $xml" -ForegroundColor Green
    }
}

# ----------------------------------------------------
# 2. Restore Windows Terminal settings.json
# ----------------------------------------------------
Write-Host ""
Write-Host "[2/2] Restoring Windows Terminal settings..." -ForegroundColor Yellow

$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettingsPath) {
    try {
        $jsonContent = Get-Content $wtSettingsPath -Raw -Encoding UTF8
        $wtSettings = $jsonContent | ConvertFrom-Json

        # Reset default profile
        if ($wtSettings.profiles.defaults.colorScheme -eq "Tokyo Night") {
            $wtSettings.profiles.defaults.PSObject.Properties.Remove("colorScheme")
        }
        if ($wtSettings.profiles.defaults.background -eq "#2E2E2E") {
            $wtSettings.profiles.defaults.PSObject.Properties.Remove("background")
        }
        if ($wtSettings.profiles.defaults.foreground -eq "#FFFFFF") {
            $wtSettings.profiles.defaults.PSObject.Properties.Remove("foreground")
        }
        if ($wtSettings.profiles.defaults.opacity -in @(90, 100)) {
            $wtSettings.profiles.defaults.PSObject.Properties.Remove("opacity")
        }

        # Remove Tokyo Night scheme
        if ($wtSettings.schemes) {
            $wtSettings.schemes = @($wtSettings.schemes | Where-Object { $_.name -ne 'Tokyo Night' })
        }

        $wtSettings | ConvertTo-Json -Depth 32 | Set-Content $wtSettingsPath -Encoding UTF8
        Write-Host "  [OK] Windows Terminal restored to defaults" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Could not auto-restore Windows Terminal settings.json: $_" -ForegroundColor DarkYellow
    }
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "   Reset Complete!                                        " -ForegroundColor Green
Write-Host "   Please restart Windows Terminal.                       " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
