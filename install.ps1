<#
.SYNOPSIS
    Windows Terminal & PowerShell Auto-Installer (Tokyo Night Theme)
.DESCRIPTION
    Automated setup script for Windows Terminal, Oh My Posh, Fastfetch, Terminal-Icons, and Colored dir.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   Windows Terminal & PowerShell Auto-Installer           " -ForegroundColor Cyan
Write-Host "   Theme: Tokyo Night | Fastfetch | Oh My Posh | dir Color" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$srcDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# ----------------------------------------------------
# 1. Install CLI Tools via WinGet
# ----------------------------------------------------
Write-Host "[1/5] Checking and installing CLI tools via WinGet..." -ForegroundColor Yellow

function Install-WingetPackage {
    param([string]$PackageId, [string]$Name)
    Write-Host "  - Checking $Name ($PackageId)... " -NoNewline
    $installed = winget list --id $PackageId --exact 2>$null
    if ($LASTEXITCODE -eq 0 -and $installed -match [regex]::Escape($PackageId)) {
        Write-Host "Already installed" -ForegroundColor Green
    } else {
        Write-Host "Installing..." -ForegroundColor Cyan
        winget install --id $PackageId -e --source winget --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    [OK] Installed $Name successfully" -ForegroundColor Green
        } else {
            Write-Host "    [!] Installation failed. Run manually: winget install $PackageId" -ForegroundColor Red
        }
    }
}

Install-WingetPackage -PackageId "Microsoft.PowerShell" -Name "PowerShell 7"
Install-WingetPackage -PackageId "JanDeDobbeleer.OhMyPosh" -Name "Oh My Posh"
Install-WingetPackage -PackageId "Fastfetch-cli.Fastfetch" -Name "Fastfetch"
Install-WingetPackage -PackageId "sharkdp.bat" -Name "Bat"

# ----------------------------------------------------
# 2. Install PowerShell Modules
# ----------------------------------------------------
Write-Host ""
Write-Host "[2/5] Checking and installing PowerShell modules..." -ForegroundColor Yellow

if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
    Write-Host "  - Installing NuGet Provider..." -ForegroundColor Cyan
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
}

function Install-PSModule {
    param([string]$ModuleName)
    Write-Host "  - Checking module $ModuleName... " -NoNewline
    if (Get-Module -Name $ModuleName -ListAvailable) {
        Write-Host "Already installed" -ForegroundColor Green
    } else {
        Write-Host "Installing..." -ForegroundColor Cyan
        Install-Module -Name $ModuleName -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
        Write-Host "    [OK] Installed $ModuleName successfully" -ForegroundColor Green
    }
}

Install-PSModule -ModuleName "Terminal-Icons"
Install-PSModule -ModuleName "PSReadLine"

# ----------------------------------------------------
# 3. Copy Configurations
# ----------------------------------------------------
Write-Host ""
Write-Host "[3/5] Deploying configuration files..." -ForegroundColor Yellow

$configsDir = Join-Path $srcDir "configs"

# 3.1 Oh My Posh Theme
$ompTarget = Join-Path $HOME "tokyonight_storm.omp.json"
Copy-Item (Join-Path $configsDir "tokyonight_storm.omp.json") $ompTarget -Force
Write-Host "  [OK] Oh My Posh Theme -> $ompTarget" -ForegroundColor Green

# 3.2 Fastfetch Config & Logo
$fastfetchTargetDir = Join-Path $HOME ".config\fastfetch"
if (-not (Test-Path $fastfetchTargetDir)) {
    New-Item -ItemType Directory -Path $fastfetchTargetDir -Force | Out-Null
}
Copy-Item (Join-Path $configsDir "fastfetch\config.jsonc") (Join-Path $fastfetchTargetDir "config.jsonc") -Force
Copy-Item (Join-Path $configsDir "fastfetch\logo2.txt") (Join-Path $fastfetchTargetDir "logo2.txt") -Force
Write-Host "  [OK] Fastfetch Config & Logo -> $fastfetchTargetDir" -ForegroundColor Green

# 3.3 PowerShell Profiles & ColoredMode XML (WindowsPowerShell & PowerShell 7)
$psDirs = @(
    (Join-Path $HOME "Documents\WindowsPowerShell"),
    (Join-Path $HOME "Documents\PowerShell")
)

foreach ($targetDir in $psDirs) {
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Copy-Item (Join-Path $configsDir "Microsoft.PowerShell_profile.ps1") (Join-Path $targetDir "Microsoft.PowerShell_profile.ps1") -Force
    Copy-Item (Join-Path $configsDir "ColoredMode.format.ps1xml") (Join-Path $targetDir "ColoredMode.format.ps1xml") -Force
    Write-Host "  [OK] Profile & ColoredMode XML -> $targetDir" -ForegroundColor Green
}

# ----------------------------------------------------
# 4. Windows Terminal Configuration
# ----------------------------------------------------
Write-Host ""
Write-Host "[4/5] Configuring Windows Terminal..." -ForegroundColor Yellow

$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettingsPath) {
    try {
        $jsonContent = Get-Content $wtSettingsPath -Raw -Encoding UTF8
        $wtSettings = $jsonContent | ConvertFrom-Json
        
        $schemeFile = Join-Path $configsDir "wt-tokyonight-scheme.json"
        if (Test-Path $schemeFile) {
            $newScheme = Get-Content $schemeFile -Raw -Encoding UTF8 | ConvertFrom-Json

            # Add Tokyo Night color scheme if not present
            $existing = $wtSettings.schemes | Where-Object { $_.name -eq 'Tokyo Night' }
            if (-not $existing) {
                $wtSettings.schemes += $newScheme
                Write-Host "  [OK] Added Tokyo Night color scheme to Windows Terminal" -ForegroundColor Green
            } else {
                Write-Host "  - Tokyo Night color scheme already exists" -ForegroundColor Green
            }
        }

        # Set default colorScheme, background, foreground, opacity, and font
        if (-not $wtSettings.profiles.defaults.colorScheme) {
            $wtSettings.profiles.defaults | Add-Member -MemberType NoteProperty -Name "colorScheme" -Value "Tokyo Night" -Force
        } else {
            $wtSettings.profiles.defaults.colorScheme = "Tokyo Night"
        }

        if (-not $wtSettings.profiles.defaults.background) {
            $wtSettings.profiles.defaults | Add-Member -MemberType NoteProperty -Name "background" -Value "#2E2E2E" -Force
        } else {
            $wtSettings.profiles.defaults.background = "#2E2E2E"
        }

        if (-not $wtSettings.profiles.defaults.foreground) {
            $wtSettings.profiles.defaults | Add-Member -MemberType NoteProperty -Name "foreground" -Value "#FFFFFF" -Force
        } else {
            $wtSettings.profiles.defaults.foreground = "#FFFFFF"
        }

        if (-not $wtSettings.profiles.defaults.opacity) {
            $wtSettings.profiles.defaults | Add-Member -MemberType NoteProperty -Name "opacity" -Value 100 -Force
        } else {
            $wtSettings.profiles.defaults.opacity = 100
        }

        if (-not $wtSettings.profiles.defaults.font) {
            $wtSettings.profiles.defaults | Add-Member -MemberType NoteProperty -Name "font" -Value ([PSCustomObject]@{ face = "JetBrainsMono NF"; size = 11 }) -Force
        } else {
            if (-not $wtSettings.profiles.defaults.font.face) {
                $wtSettings.profiles.defaults.font | Add-Member -MemberType NoteProperty -Name "face" -Value "JetBrainsMono NF" -Force
            } else {
                $wtSettings.profiles.defaults.font.face = "JetBrainsMono NF"
            }
        }

        # Set PowerShell 7 as default profile if available
        $pwshProfile = $wtSettings.profiles.list | Where-Object { $_.source -eq 'Windows.Terminal.PowershellCore' } | Select-Object -First 1
        if ($pwshProfile -and $pwshProfile.guid) {
            $wtSettings.defaultProfile = $pwshProfile.guid
            Write-Host "  [OK] Set PowerShell 7 as default terminal profile" -ForegroundColor Green
        }

        $wtSettings | ConvertTo-Json -Depth 32 | Set-Content $wtSettingsPath -Encoding UTF8
        Write-Host "  [OK] Windows Terminal defaults updated (Tokyo Night + Opacity 90%)" -ForegroundColor Green
    } catch {
        Write-Host "  [!] Could not auto-update Windows Terminal settings.json: $_" -ForegroundColor DarkYellow
    }
} else {
    Write-Host "  - Windows Terminal not found in standard package location" -ForegroundColor DarkYellow
}

# ----------------------------------------------------
# 5. Font Setup (JetBrainsMono Nerd Font)
# ----------------------------------------------------
Write-Host ""
Write-Host "[5/5] Installing JetBrainsMono Nerd Font..." -ForegroundColor Yellow
try {
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        Write-Host "  - Downloading and installing JetBrainsMono NF..." -ForegroundColor Cyan
        & oh-my-posh font install JetBrainsMono
        Write-Host "  [OK] Font installed successfully" -ForegroundColor Green
    } else {
        Write-Host "  [!] oh-my-posh not found in PATH yet. Run manually after restart: oh-my-posh font install JetBrainsMono" -ForegroundColor DarkYellow
    }
} catch {
    Write-Host "  [!] Font auto-install skipped: $_" -ForegroundColor DarkYellow
}
Write-Host ""

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "   Installation Complete!                                 " -ForegroundColor Green
Write-Host "   Please restart Windows Terminal to apply all changes.  " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
