# Install-VSCodeExtensions.ps1
# This script installs VS Code extensions automatically, skipping those already installed.

Write-Host "Checking and installing Visual Studio Code extensions..." -ForegroundColor Cyan

# List of extensions to install
$extensions = @(
    @{ id = "GitHub.copilot"; name = "GitHub Copilot" },
    @{ id = "GitHub.vscode-pull-request-github"; name = "GitHub Pull Requests" },
    @{ id = "ms-vscode.powershell"; name = "PowerShell" },
    @{ id = "yzhang.markdown-all-in-one"; name = "Markdown All in One" },
    @{ id = "DavidAnson.vscode-markdownlint"; name = "markdownlint" },
    @{ id = "swyphcosmo.spellchecker"; name = "SpellChecker" }
)

# Check if 'code' command is available in PATH
if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "VS Code command-line tool 'code' not found in PATH." -ForegroundColor Red
    Write-Host "Please open VS Code, press Ctrl+Shift+P, and run 'Shell Command: Install 'code' command in PATH'." -ForegroundColor Yellow
    exit 1
}

# Get list of currently installed extensions
$installed = code --list-extensions


# Counters and lists
$installedCount = 0
$skippedCount = 0
$installedList = @()
$skippedList = @()

# Loop through each desired extension
foreach ($ext in $extensions) {
    if ($installed -contains $ext.id) {
        Write-Host "Skipping: $($ext.id) ($($ext.name)) (already installed)" -ForegroundColor Yellow
        $skippedCount++
        $skippedList += $ext
    } else {
        Write-Host "Installing: $($ext.id) ($($ext.name))" -ForegroundColor Green
        code --install-extension $($ext.id) --force
        $installedCount++
        $installedList += $ext
    }
}

# Summary
Write-Host "`n==============================" -ForegroundColor Cyan
Write-Host " VS Code Extension Summary" -ForegroundColor White
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ("Installed: {0}" -f $installedCount) -ForegroundColor Green
if ($installedList.Count -gt 0) {
    foreach ($ext in $installedList) {
        Write-Host ("  - {0} | {1}" -f $ext.name, $ext.id) -ForegroundColor Green
    }
}
Write-Host ("Skipped:   {0}" -f $skippedCount) -ForegroundColor Yellow
if ($skippedList.Count -gt 0) {
    foreach ($ext in $skippedList) {
        Write-Host ("  - {0} | {1}" -f $ext.name, $ext.id) -ForegroundColor Yellow
    }
}
Write-Host ("Total:     {0}" -f ($extensions.Count)) -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "`nAll done!" -ForegroundColor White
