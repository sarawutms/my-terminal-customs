# 0. UTF-8 Encoding: รองรับการแสดงผล Emoji ใน Terminal
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# 1. Fastfetch: แสดงสถานะระบบเมื่อเปิด Terminal ทั่วไป (ข้ามเมื่อเปิดใน VS Code เพื่อลดเวลาโหลดและไม่แสดงซ้ำซ้อน)
$isVSCode = ($env:TERM_PROGRAM -eq 'vscode') -or ($env:VSCODE_INJECTION -eq '1')
if (-not $isVSCode -and [Environment]::CommandLine -notmatch '-(Command|c)\b') {
    if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
        fastfetch
    }
}

# 2. Oh My Posh: ธีม Terminal พร้อมระบบ Smart Cache เพื่อให้เปิด Terminal เร็วที่สุด (<100ms)
$ompConfig = "$HOME\tokyonight_storm.omp.json"
$shellType = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh' } else { 'powershell' }
$ompCache  = "$HOME\.posh-cache-$shellType.ps1"
if (Test-Path -LiteralPath $ompConfig) {
    if (!(Test-Path -LiteralPath $ompCache) -or ((Get-Item -LiteralPath $ompConfig).LastWriteTime -gt (Get-Item -LiteralPath $ompCache).LastWriteTime)) {
        & oh-my-posh init $shellType --config $ompConfig --print | Set-Content -Path $ompCache -Encoding UTF8
    }
    if (Test-Path -LiteralPath $ompCache) {
        . $ompCache
        $env:POSH_SESSION_ID = [guid]::NewGuid().ToString()
    }
}

# 3. PSReadLine: แนะนำคำสั่งเก่า & Syntax Highlighting สี Tokyo Night ตอนพิมพ์
if (Get-Module -Name PSReadLine -ListAvailable) {
    Set-PSReadLineOption -HistoryNoDuplicates
    if (![Console]::IsOutputRedirected) {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle InlineView
        Set-PSReadLineOption -Colors @{
            Command            = '#7aa2f7'  # คำสั่งถูกต้อง: สีฟ้า Tokyo Night
            Parameter          = '#bb9af7'  # พารามิเตอร์: สีม่วง
            Operator           = '#89ddff'  # ตัวดำเนินการ: สีฟ้าอ่อน
            Variable           = '#f7768e'  # ตัวแปร: สีชมพูแดง
            String             = '#9ece6a'  # ข้อความ String: สีเขียว
            Number             = '#ff9e64'  # ตัวเลข: สีส้ม
            Type               = '#0db9d7'  # Type ชนิดข้อมูล: สีฟ้าคราม
            Comment            = '#565f89'  # คอมเมนต์: สีเทา
            InlinePrediction   = '#565f89'  # แนะนำคำสั่ง: สีเทาจาง
        }
    }
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# 4. Terminal-Icons & Colored Mode: ตาราง dir / ls ของ Windows แบบเดิม 100% + มีไอคอน + สิทธิ์ (Mode) มีสีสัน
# โหลดเมื่อเรียกใช้ dir / ls ครั้งแรก (Lazy Loading เพื่อให้เปิด Terminal ทันที <120ms)
Remove-Item -Force Alias:dir, Alias:ls -ErrorAction SilentlyContinue
function dir {
    if (-not (Get-Module -Name Terminal-Icons)) {
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
        $modeFormat = Join-Path $PSScriptRoot "ColoredMode.format.ps1xml"
        if (-not (Test-Path -LiteralPath $modeFormat)) {
            $modeFormat = "$HOME\Documents\WindowsPowerShell\ColoredMode.format.ps1xml"
        }
        if (-not (Test-Path -LiteralPath $modeFormat)) {
            $modeFormat = "$HOME\Documents\PowerShell\ColoredMode.format.ps1xml"
        }
        if (Test-Path -LiteralPath $modeFormat) {
            Update-FormatData -PrependPath $modeFormat
        }
    }
    if ($MyInvocation.ExpectingInput) {
        $input | Microsoft.PowerShell.Management\Get-ChildItem @args
    } else {
        Microsoft.PowerShell.Management\Get-ChildItem @args
    }
}
Set-Alias -Name ls -Value dir -Option AllScope

# 5. Bat: คำสั่ง cat แสดงสีโค้ดและเลขบรรทัด (ค้นหาแบบยืดหยุ่น ไม่ล็อกเวอร์ชัน รองรับทุกเครื่อง)
$batExe = (Resolve-Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\sharkdp.bat_*\bat-*\bat.exe" -ErrorAction SilentlyContinue).Path | Select-Object -First 1
if (-not $batExe) {
    $batExe = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\bat.exe"
}
if ($batExe -and (Test-Path -LiteralPath $batExe)) {
    $batDir = Split-Path -Path $batExe
    if ($env:PATH -notmatch [regex]::Escape($batDir)) {
        $env:PATH = "$batDir;$env:PATH"
    }
    Remove-Item -Force Alias:cat -ErrorAction SilentlyContinue
    function cat { & $batExe --paging=never @args }
} elseif (Get-Command bat -ErrorAction SilentlyContinue) {
    Remove-Item -Force Alias:cat -ErrorAction SilentlyContinue
    function cat { bat --paging=never @args }
}

# 6. WSL Shortcut: รองรับการพิมพ์ wsl ~ เพื่อเข้าสู่ Linux Home Directory ทันที
function wsl {
    if ($args.Count -ge 1 -and ($args[0] -eq '~' -or $args[0] -eq $HOME)) {
        wsl.exe --cd '~' @($args | Select-Object -Skip 1)
    } else {
        wsl.exe @args
    }
}
