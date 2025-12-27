# 1. Verification & Context
Write-Host "--- Git Commit & Push Helper ---" -ForegroundColor Cyan
$currentDir = Get-Location
Write-Host "Target Path: $currentDir" -ForegroundColor Gray

# 2. Initial Readiness Prompt
Write-Host "`nAre you ready to stage files for commit? (Yes/No)" -ForegroundColor White -BackgroundColor DarkMagenta
$ready = Read-Host "Selection"

if ($ready -notmatch "^(y|yes)$") {
    Write-Host "Exiting script. No changes were staged." -ForegroundColor Yellow
    return
}

# 3. Stage Files (The "." captures EVERYTHING new since last commit)
Write-Host "`nStaging all files..." -ForegroundColor Gray
git add .
Write-Host "Current Staged Changes:" -ForegroundColor Magenta
git status -s

# 4. Description Loop
$finalMsg = ""
$accept = $false

while (-not $accept) {
    $commitMsg = Read-Host "`nEnter Commit Description/Notes"
    
    if ([string]::IsNullOrWhiteSpace($commitMsg)) {
        Write-Host "!! Description cannot be empty !!" -ForegroundColor Red
        continue
    }

    Write-Host "`n--- REVIEW DESCRIPTION ---" -ForegroundColor Cyan
    Write-Host "`"$commitMsg`"" -ForegroundColor White -BackgroundColor Black
    $review = Read-Host "Review & Accept: [Y]es / [Q]uit / [R]edo"

    if ($review -match "^q") {
        Write-Host "Aborting. Files remain staged but not committed." -ForegroundColor Red
        return
    }
    elseif ($review -match "^y") {
        $finalMsg = $commitMsg
        $accept = $true
    }
}

# 5. Final Commit Check
Write-Host "`n!!! LAST CHECK !!!" -ForegroundColor Black -BackgroundColor Yellow
$lastCheck = Read-Host "Commit these changes locally? [Y]es / [Q]uit"

if ($lastCheck -match "^y") {
    git commit -m "$finalMsg"
    Write-Host "SUCCESS: Changes committed locally." -ForegroundColor Green
    
    # 6. Push to GitHub Option
    $pushCheck = Read-Host "`nWould you like to PUSH (Upload) these changes to GitHub now? [Y]es / [N]o"
    if ($pushCheck -match "^y") {
        Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
        git push
        Write-Host "SUCCESS: Repository is now synced with GitHub!" -ForegroundColor Green
    } else {
        Write-Host "Skipping push. Your changes are saved locally but NOT on GitHub." -ForegroundColor Yellow
    }
} else {
    Write-Host "Commit cancelled. Changes are still staged." -ForegroundColor Yellow
}

Write-Host "`nScript Complete!" -ForegroundColor Cyan