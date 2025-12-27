# 1. Define the "All Hosts" profile path (works for VS Code AND regular Terminal)
$TargetProfile = $PROFILE.CurrentUserAllHosts

# 2. Ensure the directory exists (especially important for OneDrive paths)
$profileDir = Split-Path -Parent $TargetProfile
if (!(Test-Path -Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
}

# 3. Check if the profile file exists; if not, create it
if (!(Test-Path -Path $TargetProfile)) {
    New-Item -Path $TargetProfile -ItemType File -Force | Out-Null
}

# Define the functions to add (name and code)
$functionsToAdd = @(
    @{ Name = 'New-ProjectFolders'; Code = "function New-ProjectFolders {`n    & 'C:\Users\catch\OneDrive\Documents\projects\projects setup info cheats\setting up new repository\scripts\default repository folders.ps1'`n}"}
    @{ Name = 'git-commit-push'; Code = "function git-commit-push {`n    & 'C:\Users\catch\OneDrive\Documents\projects\projects setup info cheats\setting up new repository\scripts\git stage commit push.ps1'`n}"}
)

$added = @()
$skipped = @()

foreach ($func in $functionsToAdd) {
    # Check if function is already in the file to prevent duplicates
    if (Select-String -Path $TargetProfile -Pattern "function $($func.Name)" -Quiet) {
        $skipped += $func.Name
        Write-Host ("SKIPPED: Function '$($func.Name)' already exists in Profile.") -ForegroundColor Yellow
    } else {
        Add-Content -Path $TargetProfile -Value ("`n" + $func.Code + "`n")
        $added += $func.Name
        Write-Host ("ADDED:   Function '$($func.Name)' added to All-Hosts Profile.") -ForegroundColor Green
    }
}

Write-Host ("`nSummary:") -ForegroundColor Cyan
Write-Host ("   Functions added:   {0}" -f $added.Count) -ForegroundColor Green
if ($added.Count -gt 0) { Write-Host ("    " + ($added -join ", ")) -ForegroundColor Green }
Write-Host ("   Functions skipped: {0}" -f $skipped.Count) -ForegroundColor Yellow
if ($skipped.Count -gt 0) { Write-Host ("    " + ($skipped -join ", ")) -ForegroundColor Yellow }

# Force the current session to load the changes immediately
. $TargetProfile

# ---
# Prompt to remove functions from CURRENT session only
Write-Host "`n--- Session Management ---" -ForegroundColor Gray
$removePrompt = Read-Host "Would you like to remove any functions from the CURRENT session? (Yes/No/List)"
if ($removePrompt -match '^(n|no)$' -or [string]::IsNullOrWhiteSpace($removePrompt)) {
    Write-Host "Exiting script."
    return
}

$customFunctions = Get-Command -CommandType Function | Where-Object { $_.ModuleName -eq '' -and $_.Name -ne 'TabExpansion2' }

if ($removePrompt -match '^(list)$') {
    if ($customFunctions.Count -eq 0) {
        Write-Host "No custom functions found."
        return
    }
    Write-Host "Custom functions in session:"
    $i = 1
    foreach ($func in $customFunctions) {
        Write-Host "$i. $($func.Name)"
        $i++
    }
    $removePrompt = Read-Host "Remove any? (Yes/No)"
    if ($removePrompt -notmatch '^(y|yes)$') { return }
}

Write-Host "Select the number(s) to remove (comma separated):"
$i = 1
$funcMap = @{}
foreach ($func in $customFunctions) {
    Write-Host "$i. $($func.Name)"
    $funcMap[$i] = $func.Name
    $i++
}

$selection = Read-Host "Enter number(s)"
if (![string]::IsNullOrWhiteSpace($selection)) {
    $toRemove = $selection -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' -and $funcMap.ContainsKey([int]$_) } | ForEach-Object { $funcMap[[int]$_] }
    foreach ($funcName in $toRemove) {
        Remove-Item Function:$funcName -ErrorAction SilentlyContinue
        Write-Host ("REMOVED: '$funcName' from session.") -ForegroundColor Red
    }
}