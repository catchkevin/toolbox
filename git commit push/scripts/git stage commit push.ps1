# 1. Verification & Context (Design Header)
$ErrorActionPreference = "Stop"

$currentDir = Get-Location
$currentBranch = (git branch --show-current)

Write-Host "`n****************************************************" -ForegroundColor White
Write-Host " CONTEXT HEADER: $currentDir" -ForegroundColor Cyan
Write-Host " BRANCH        : $currentBranch" -ForegroundColor Cyan
Write-Host "****************************************************" -ForegroundColor White

# --- 2. Check for New Project vs. Existing ---
if (!(Test-Path ".git")) {
    Write-Host "`n[!] No Git repository detected." -ForegroundColor Yellow
    Write-Host "Options: [Y] Initialize New | [Q] Quit: " -ForegroundColor White -NoNewline
    $setupNew = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $setupNew

    if ($setupNew -eq "y") {
        git init
        $repoUrl = Read-Host " Enter GitHub Repository URL"
        if (![string]::IsNullOrWhiteSpace($repoUrl)) {
            git remote add origin $repoUrl
            git branch -M main
            Write-Host "Initialized and linked to origin." -ForegroundColor Green
        }
    } else { return }
}

# --- 3. The SMART PULL Step ---
Write-Host "`nChecking for updates (Git Pull)... " -ForegroundColor Cyan -NoNewline
git pull origin $currentBranch --rebase

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] PULL BLOCKED: History mismatch." -ForegroundColor Yellow
    Write-Host "Options: [F]orce Local | [Q]uit: " -ForegroundColor White -NoNewline
    $fixChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $fixChoice
    
    if ($fixChoice -eq "f") {
        $GLOBAL:ForcePushRequired = $true
    } else {
        git rebase --abort 2>$null
        return
    }
} else {
    Write-Host "Synced." -ForegroundColor Gray
}

# --- 4. Readiness & Staging ---
Write-Host "`nStage files for commit? [Y]es | [Q]uit: " -ForegroundColor White -NoNewline
$ready = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $ready

if ($ready -eq "y") {
    Write-Host "Staging files..." -ForegroundColor Gray
    git add .
    git status -s
} else { return }

# --- 5. Description Input ---
Write-Host "`nEnter Commit Description: " -ForegroundColor White -NoNewline
$commitMsg = Read-Host 
if ([string]::IsNullOrWhiteSpace($commitMsg)) { 
    Write-Host "!! Description cannot be empty !!" -ForegroundColor Red
    return 
}

# --- 6. Review & Logic ---
Write-Host "Review: `"$commitMsg`"" -ForegroundColor Cyan
Write-Host "Options: [Y] Accept | [R]edo | [Q]uit: " -ForegroundColor White -NoNewline
$review = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $review

if ($review -eq "q") { return }
if ($review -eq "r") { 
    Write-Host "Redo selected. Please restart script." -ForegroundColor Yellow
    return 
}

# --- 7. Finalize (Commit & Push) ---
Write-Host "`nFinalize & Push to GitHub? [Y]es | [Q]uit: " -ForegroundColor White -NoNewline
$lastCheck = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $lastCheck

if ($lastCheck -eq "y") {
    git commit -m "$commitMsg"
    Write-Host "Local commit saved." -ForegroundColor Gray

    if ($GLOBAL:ForcePushRequired) {
        git push origin $currentBranch --force
        $GLOBAL:ForcePushRequired = $false 
    } else {
        $prevErrorAction = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
        $upstream = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
        $ErrorActionPreference = $prevErrorAction

        if ($null -eq $upstream -or $LASTEXITCODE -ne 0) {
            git push -u origin $currentBranch
        } else {
            git push
        }
    }
    Write-Host "Sync Complete!" -ForegroundColor Green
}

Write-Host "`nScript Complete!" -ForegroundColor Cyan