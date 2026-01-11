# 1. Verification & Context 
$ErrorActionPreference = "Stop"
$VariableContext = "GIT WORKFLOW MANAGER V2"

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
Write-Host " This script is a centralized Git management tool"
Write-Host " designed to handle local saving and remote syncing."
Write-Host " "
Write-Host " You will be prompted for the following:"
Write-Host " 1. Clear Terminal: Optional cleanup or [E]xit script."
Write-Host " 2. Operation Mode: [S]tage, [C]ommit, or [P]ush."
Write-Host " 3. Description: Text for your local save point."
Write-Host " 4. Conflict Handling: Choice to Force or Abort."
Write-Host " 5. Final Push: Last confirmation before uploading."
Write-Host "****************************************************" -ForegroundColor White

# --- NEW PROMPT: CLEAR TERMINAL (Updated with Exit) ---
Write-Host "`nDo you want to clear script terminal before running this script?" -ForegroundColor White
Write-Host "[Y]es | [N]o | [E]xit: " -ForegroundColor White -NoNewline
$clearChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $clearChoice

if ($clearChoice -eq 'e') { 
    Write-Host "Exiting script..." -ForegroundColor Yellow
    return 
}
if ($clearChoice -eq 'y') { Clear-Host }

# --- THE MASTER SELECTOR ---
Write-Host "`nWhat to run:" -ForegroundColor Cyan
Write-Host "[S]tage only (Simple Add)"
Write-Host "[C]ommit (Local Save Point)"
Write-Host "[P]ush to GitHub (Stage, Commit, Push)"
Write-Host "Please Select: " -ForegroundColor White -NoNewline
$mainChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $mainChoice

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
        }
    } else { return }
}

# --- 3. EXECUTION LOGIC ---

# ROUTINE: STAGE (Used by S, C, and P)
if ($mainChoice -eq 's' -or $mainChoice -eq 'c' -or $mainChoice -eq 'p') {
    Write-Host "`nStaging files..." -ForegroundColor Gray
    git add .
    git status -s
    if ($mainChoice -eq 's') { 
        Write-Host "`nFiles Staged. Workflow Complete." -ForegroundColor Green
        return 
    }
}

# ROUTINE: COMMIT (Used by C and P)
if ($mainChoice -eq 'c' -or $mainChoice -eq 'p') {
    Write-Host "`nEnter Commit Description: " -ForegroundColor White -NoNewline
    $commitMsg = Read-Host 
    if ([string]::IsNullOrWhiteSpace($commitMsg)) { 
        Write-Host "!! Description cannot be empty !!" -ForegroundColor Red
        return 
    }
    git commit -m "$commitMsg"
    Write-Host "Local save point created." -ForegroundColor Gray
    if ($mainChoice -eq 'c') { 
        Write-Host "`nCommit Saved Locally. Workflow Complete." -ForegroundColor Green
        return 
    }
}

# ROUTINE: PUSH/SYNC (Only used by P)
if ($mainChoice -eq 'p') {
    Write-Host "`nSyncing with remote (Pull --rebase)... " -ForegroundColor Cyan -NoNewline
    git pull origin $currentBranch --rebase

    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n[!] CONFLICT DETECTED." -ForegroundColor Yellow
        Write-Host "Options: [F]orce Local Overwrite | [Q] Abort: " -ForegroundColor White -NoNewline
        $fixChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
        Write-Host $fixChoice
        
        if ($fixChoice -eq 'f') {
            $GLOBAL:ForcePushRequired = $true
            git rebase --abort 2>$null
        } else {
            git rebase --abort 2>$null
            return
        }
    }

    Write-Host "`nFinalize Push to GitHub? [Y]es | [Q]uit: " -ForegroundColor White -NoNewline
    $lastCheck = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
    Write-Host $lastCheck

    if ($lastCheck -eq "y") {
        if ($GLOBAL:ForcePushRequired) {
            git push origin $currentBranch --force
            $GLOBAL:ForcePushRequired = $false 
        } else {
            $upstream = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
            if ($null -eq $upstream -or $LASTEXITCODE -ne 0) {
                git push -u origin $currentBranch
            } else {
                git push
            }
        }
        Write-Host "Sync Complete!" -ForegroundColor Green
    }
}

Write-Host "`nScript Complete!" -ForegroundColor Cyan