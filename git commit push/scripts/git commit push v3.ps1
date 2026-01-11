# 1. Verification & Context (Your Standard Header)
$ErrorActionPreference = "Stop"
$VariableContext = "GIT SMART SYNC (REBASE WORKFLOW) V1"

$currentDir = Get-Location
$currentBranch = (git branch --show-current)

# --- DESIGN: CONTEXT HEADER ---
Write-Host "****************************************************" -ForegroundColor White
Write-Host " CONTEXT HEADER: $VariableContext" -ForegroundColor Cyan
Write-Host " DIRECTORY      : $currentDir" -ForegroundColor White
Write-Host " BRANCH         : $currentBranch" -ForegroundColor White
Write-Host "****************************************************" -ForegroundColor White

# --- DESIGN: PURPOSE AND PROMPTS HEADER ---
Write-Host "****************************************************" -ForegroundColor White
Write-Host " Script Purpose and Prompts" -ForegroundColor Yellow
Write-Host ""
Write-Host " This script automates a clean Git workflow by"
Write-Host " performing the following steps:"
Write-Host ""
Write-Host " 1. Stage and Commit local changes (Safety First)"
Write-Host " 2. Pull Remote updates using --rebase (Clean History)"
Write-Host " 3. Push finalized work to GitHub"
Write-Host "****************************************************" -ForegroundColor White

# --- NEW PROMPT: CLEAR TERMINAL ---
Write-Host "`nDo you want to clear script terminal before running this script?" -ForegroundColor White
Write-Host "[Y]es | [N]o: " -ForegroundColor White -NoNewline
$clearChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $clearChoice

if ($clearChoice -eq 'y') { Clear-Host }

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
            $currentBranch = "main"
            Write-Host "Initialized and linked to origin." -ForegroundColor Green
        }
    } else { return }
}

# --- 3. Stage & Commit (The "Option B" approach) ---
Write-Host "`nStage all changes? [Y]es | [Q]uit: " -ForegroundColor White -NoNewline
$ready = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $ready

if ($ready -eq "y") {
    git add .
    git status -s
} else { return }

Write-Host "`nEnter Commit Description: " -ForegroundColor White -NoNewline
$commitMsg = Read-Host 
if ([string]::IsNullOrWhiteSpace($commitMsg)) { 
    Write-Host "!! Description cannot be empty !!" -ForegroundColor Red
    return 
}

Write-Host "Commit locally? [Y] Accept | [Q] Quit: " -ForegroundColor White -NoNewline
$review = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $review

if ($review -eq "y") {
    git commit -m "$commitMsg"
    Write-Host "Local commit saved." -ForegroundColor Gray
} else { return }

# --- 4. The SMART PULL (Rebase happens on a clean directory) ---
Write-Host "`nSyncing with remote (Pull --rebase)... " -ForegroundColor Cyan -NoNewline
git pull origin $currentBranch --rebase

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] CONFLICT DETECTED." -ForegroundColor Yellow
    Write-Host "Options: [F]orce Local Overwrite | [Q] Abort & Resolve Manually: " -ForegroundColor White -NoNewline
    $fixChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $fixChoice
    
    if ($fixChoice -eq "f") {
        $GLOBAL:ForcePushRequired = $true
        git rebase --abort 2>$null
    } else {
        git rebase --abort 2>$null
        Write-Host "Rebase aborted. Please fix conflicts manually." -ForegroundColor Red
        return
    }
} else {
    Write-Host "Remote changes integrated." -ForegroundColor Gray
}

# --- 5. Final Push ---
Write-Host "`nPush to GitHub? [Y]es | [Q]uit: " -ForegroundColor White -NoNewline
$lastCheck = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $lastCheck

if ($lastCheck -eq "y") {
    if ($GLOBAL:ForcePushRequired) {
        git push origin $currentBranch --force
        $GLOBAL:ForcePushRequired = $false 
        Write-Host "Force pushed successfully." -ForegroundColor Yellow
    } else {
        $upstream = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
        if ($LASTEXITCODE -ne 0) {
            git push -u origin $currentBranch
        } else {
            git push
        }
    }
    Write-Host "Sync Complete!" -ForegroundColor Green
}

Write-Host "`nScript Complete!" -ForegroundColor Cyan