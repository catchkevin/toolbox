# 1. Verification & Context & Initialization
$SuccessList = @()
$SkippedList = @()

function Show-DirectorySummary {
    Write-Host "`n--- DIRECTORY PROCESSING SUMMARY ---" -ForegroundColor Blue
    Write-Host "Total Script Default Folders: $($baseFolders.Count)" -ForegroundColor Cyan
    Write-Host "Total Created: $($SuccessList.Count)" -ForegroundColor Green
    foreach ($item in $SuccessList) { Write-Host " [+] Created: $item" }
    Write-Host "Total Skipped: $($SkippedList.Count)" -ForegroundColor Yellow
    foreach ($item in $SkippedList) { Write-Host " [!] Skipped: $item (Already Exists)" }

    $allProcessed = $SuccessList + $SkippedList
    $missedFolders = $baseFolders | Where-Object { $_ -notin $allProcessed }
    Write-Host "Total Missed: $($missedFolders.Count)" -ForegroundColor Red
    foreach ($m in $missedFolders) { Write-Host " [X] Failed/Missed: $m" -ForegroundColor Red }
    Write-Host "------------------------------------" -ForegroundColor Blue
}

Write-Host "--- Repository Folder Manager ---" -ForegroundColor Cyan
$currentDir = Get-Location
Write-Host "Target Path: $currentDir" -ForegroundColor Gray

# --- LOCKED FORMATTING: BASE FOLDERS ---
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
    "scripts",
    "src",
    "tmp",
    "test",
    "tools"

$defaultContent = "# Created Empty Directory for Git Sync`n`nThis file was created as part of template folders setup. Empty folders do not sync to github, this file forces the sync."

# --- LOCKED FORMATTING: FOLDER DESCRIPTIONS ---
$folderDescriptions = @{
    "bin"                 = "For compiled binaries or build artifacts."
    "config"              = "For configuration files (ex. YAML, JSON, ENV, etc.)."
    "data"                = "For database files, datasets, excel files, sample data."
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
    "scripts"             = "For project-related scripts and or utilities."
    "src"                 = "For source code."
    "test"                = "For unit, integration, or end-to-end tests."
    "tmp"                 = "For temporary files."
    "tools"               = "For developer tools, scripts, or utilities."
}

# 2. Main Menu Loop
$mainLoop = $true
while ($mainLoop) {
    Write-Host "`n****************************************************" -ForegroundColor White
    Write-Host "FOLDERS WILL BE CREATED IN: $currentDir" -ForegroundColor Cyan
    Write-Host "****************************************************" -ForegroundColor White
    
    Write-Host "Press [C]ontinue or [Q]uit: " -ForegroundColor White -NoNewline
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $key

    if ($key -eq "q") { return }
    elseif ($key -eq "c") {
        $subLoop = $true
        while ($subLoop) {
            Write-Host "`nOptions: [D]efault | [N]ew Only | [L]ist | [B]ack: " -ForegroundColor White -NoNewline
            $mode = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
            Write-Host $mode

            if ($mode -eq "b") { $subLoop = $false }
            elseif ($mode -eq "l") {
                Write-Host "`nDefault folders currently set in script:" -ForegroundColor Cyan
                $baseFolders | ForEach-Object { Write-Host " - $_" }
            }
            elseif ($mode -eq "d") {
                foreach ($f in $baseFolders) { 
                    if (Test-Path $f) { $SkippedList += $f } 
                    else {
                        try {
                            New-Item -ItemType Directory -Path $f -Force -ErrorAction Stop | Out-Null
                            $SuccessList += $f
                            $syncFile = Join-Path $f "_$($f)_empty_directory_sync_github.md"
                            $content = "$($folderDescriptions[$f])`n`n$defaultContent"
                            $content | Out-File -FilePath $syncFile -Encoding utf8
                        } catch {}
                    }
                }
                Show-DirectorySummary
                $subLoop = $false; $mainLoop = $false
            }
            elseif ($mode -eq "n") { $subLoop = $false; $mainLoop = $false }
        }
    }
}

# 3. Additional Folders Loop
$continueLoop = $true
while ($continueLoop) {
    Write-Host "`nAdd an additional folder? (Y/N): " -ForegroundColor White -NoNewline
    $res = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $res

    if ($res -eq 'y') {
        Write-Host "Folder Name: " -ForegroundColor White -NoNewline
        $folderName = Read-Host 
        if ($folderName) {
            if (Test-Path $folderName) { $SkippedList += $folderName }
            else {
                New-Item -ItemType Directory -Path $folderName -Force | Out-Null
                $SuccessList += $folderName
                $syncFile = Join-Path $folderName "_$($folderName)_empty_for_git_sync.md"
                $directory_use = if ($folderDescriptions.ContainsKey($folderName)) { $folderDescriptions[$folderName] } else { "Custom folder." }
                $content = "$directory_use`n`n$defaultContent"
                $content | Out-File -FilePath $syncFile -Encoding utf8
            }
            Show-DirectorySummary
        }
    } else {
        $continueLoop = $false
    }
}

Write-Host "`nSetup Complete!" -ForegroundColor Cyan