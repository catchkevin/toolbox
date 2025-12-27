
# 1. Verification & Context & Initialization
$SuccessList = @()
$SkippedList = @()

function Show-DirectorySummary {
    # Blue text, NO background
    Write-Host "`n--- DIRECTORY PROCESSING SUMMARY ---" -ForegroundColor Blue
    Write-Host "Total Created: $($SuccessList.Count)" -ForegroundColor Green
    foreach ($item in $SuccessList) { Write-Host " [+] Created: $item" }
    Write-Host "Total Skipped: $($SkippedList.Count)" -ForegroundColor Yellow
    foreach ($item in $SkippedList) { Write-Host " [!] Skipped: $item (Already Exists)" }
    Write-Host "------------------------------------" -ForegroundColor Blue
}

Write-Host "--- Repository Folder Manager ---" -ForegroundColor Cyan
$currentDir = Get-Location
Write-Host "Target Path: $currentDir" -ForegroundColor Gray

# Define Defaults
$baseFolders = 
    "bin",
    "config",
    "data",
    "distribution",
    "docs",
    "docs_script_updates",
    "future_features",
    "images",
    "lib",
    "logs",
    "misc",
    "project_scripts",
    "release_notes",
    "src",
    "tmp",
    "test",
    "tools"

$defaultContent = "# Created Empty Directory for Git Sync`n`nThis file was created as part of template folders setup. Empty folders do not sync to github, this file forces the sync."

# Folder descriptions
$folderDescriptions = @{
    "bin"                 = "For compiled binaries or build artifacts."
    "config"              = "For configuration files (ex. YAML, JSON, ENV, etc.)."
    "data"                = "For datasets, sample data, or database files."
    "distribution"        = "For distribution-ready files (ex. minified, bundled, or packaged output)."
    "docs"                = "For documents like the markdowns."
    "docs_script_updates" = "For notes of script addition, changes, updates. (Developers verbos information)"
    "future_features"     = "For ideas or plans for future features or enhancements."
    "images"              = "For images."
    "lib"                 = "For libraries or reusable code modules."
    "logs"                = "For log files."
    "misc"                = "Miscellaneous items."
    "project_scripts"     = "For scripts that compliment the project, perform additional work (ex. clean up scripts, macros)."
    "release_notes"       = "For release notes."
    "src"                 = "For source code."
    "test"                = "For unit, integration, or end-to-end tests."
    "tmp"                 = "For temporary files."
    "tools"               = "For developer tools, scripts, or utilities."
}

$validChoice = $false

# 2. Main Menu Loop
while (-not $validChoice) {
    Write-Host "`n****************************************************" -ForegroundColor White
    Write-Host "FOLDERS WILL BE CREATED IN: $currentDir" -ForegroundColor Cyan
    Write-Host "****************************************************" -ForegroundColor White
    Write-Host "Press [C]ontinue or [Q]uit" -ForegroundColor White -BackgroundColor DarkMagenta
    $action = Read-Host "Selection"

    if ($action -match "^(q|quit)$") {
        Write-Host "Exiting script..." -ForegroundColor Red
        return
    }
    elseif ($action -match "^(c|continue)$") {
        while (-not $validChoice) {
            Write-Host "`nOptions: [D]efault & New | [N]ew Only | [L]ist Defaults" -ForegroundColor Yellow
            $mode = Read-Host "Select (D, N, or L)"

            if ($mode -eq "L") {
                Write-Host "`nDefault folders currently set in script:" -ForegroundColor Magenta
                $baseFolders | ForEach-Object { Write-Host " - $_" }
                break 
            }
            elseif ($mode -eq "D") {
                $validChoice = $true
                foreach ($f in $baseFolders) { 
                    if (Test-Path $f) { $SkippedList += $f } 
                    else {
                        New-Item -ItemType Directory -Path $f -Force | Out-Null
                        $SuccessList += $f
                        $syncFile = Join-Path $f "_$($f)_empty_directory_sync_github.md"
                        # Merge Description + Default Content
                        $directory_use = $folderDescriptions[$f]
                        $content = "$directory_use`n`n$defaultContent"
                        $content | Out-File -FilePath $syncFile -Encoding utf8
                    }
                }
                Show-DirectorySummary
            }
            elseif ($mode -eq "N") {
                $validChoice = $true
                Write-Host "Skipping defaults..." -ForegroundColor Gray
            }
        }
    }
}

# 3. Additional Folders Loop with 10-Second Timeout
do {
    Write-Host "`nAdd a additional or custom folder? (Yes/No) [Auto-No in 10s]: " -NoNewline
    
    $timeout = 10
    $timer = [diagnostics.stopwatch]::StartNew()
    $response = ""

    # Wait for key press or timeout
    while ($timer.Elapsed.TotalSeconds -lt $timeout -and -not $Host.UI.RawUI.KeyAvailable) {
        Start-Sleep -Milliseconds 250
    }

    if ($Host.UI.RawUI.KeyAvailable) {
        $response = Read-Host
    } else {
        Write-Host "`nTimeout reached. Defaulting to 'No'..." -ForegroundColor Yellow
        $response = "no"
    }
    
    if ($response -match "^(y|yes)$") {
        Write-Host "Folder Name: " -NoNewline
        $folderName = Read-Host
        if ($folderName -ne "") {
            if (Test-Path $folderName) { $SkippedList += $folderName } 
            else {
                New-Item -ItemType Directory -Path $folderName -Force | Out-Null
                $SuccessList += $folderName
                $syncFile = Join-Path $folderName "_$($folderName)_empty_for_git_sync.md"
                # Check for description or use fallback
                if ($folderDescriptions.ContainsKey($folderName)) {
                    $directory_use = $folderDescriptions[$folderName]
                } else {
                    $directory_use = "Custom or miscellaneous folder."
                }
                $content = "$directory_use`n`n$defaultContent"
                $content | Out-File -FilePath $syncFile -Encoding utf8
            }
            Show-DirectorySummary
        }
    }
} while ($response -match "^(y|yes)$")

Write-Host "`nSetup Complete!" -ForegroundColor Cyan -BackgroundColor Black