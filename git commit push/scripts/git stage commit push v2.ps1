# 1. Verification & Context
# Stop the script immediately if a critical system command fails unexpectedly
$ErrorActionPreference = "Stop"

Write-Host "--- Git Commit & Push Helper (v2.4) ---" -ForegroundColor Cyan
$currentDir = Get-Location
Write-Host "Target Path: $currentDir" -ForegroundColor Gray

# --- 2. Check for New Project vs. Existing ---
if (!(Test-Path ".git")) {
    Write-Host "`n[!] ATTENTION: No Git repository detected in this folder." -ForegroundColor Yellow
    Write-Host "It looks like this is a NEW project." -ForegroundColor White
    
    $setupNew = Read-Host "Would you like to initialize a NEW Git repo and link to GitHub? [Y]es / [Q]uit"
    
    if ($setupNew -match "^y") {
        git init
        $repoUrl = Read-Host "Paste your GitHub Repository URL"
        if (![string]::IsNullOrWhiteSpace($repoUrl)) {
            git remote add origin $repoUrl
            git branch -M main
            Write-Host "Local repo initialized and linked to origin." -ForegroundColor Green
        } else {
            Write-Host "No URL provided. Initialized locally only." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Exiting script. No changes made." -ForegroundColor Red
        return
    }
} else {
    # --- 3. Branch Check ---
    $currentBranch = (git branch --show-current)
    if ($currentBranch -ne "main") {
        Write-Host "`n[!] NOTE: You are currently on branch '$currentBranch'." -ForegroundColor Yellow
    }

    # --- 4. The SMART PULL Step ---
    Write-Host "`nChecking for updates from GitHub (Git Pull)..." -ForegroundColor Cyan
    
    # Try a standard pull using the CURRENT branch
    git pull origin $currentBranch --rebase
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "`n[!] PULL BLOCKED: Local files and GitHub history do not match." -ForegroundColor Yellow
        Write-Host "This happens if files were deleted/changed on GitHub.com directly." -ForegroundColor White
        
        Write-Host "`nHow would you like to proceed?" -ForegroundColor Cyan
        Write-Host "1. Force local version (Overwrite GitHub)" -ForegroundColor White
        Write-Host "2. Stop script and fix manually" -ForegroundColor White
        $fixChoice = Read-Host "Selection [1 or 2]"
        
        if ($fixChoice -eq "1") {
            Write-Host "Setting local files as the priority. Proceeding..." -ForegroundColor Gray
            $GLOBAL:ForcePushRequired = $true
        } else {
            git rebase --abort 2>$null
            Write-Host "Script stopped. Please resolve conflicts in VS Code." -ForegroundColor Red
            return
        }
    } else {
        Write-Host "Local files are now in sync with GitHub." -ForegroundColor Gray
    }
}

# 5. Initial Readiness Prompt
Write-Host "`nAre you ready to stage files for commit? (Yes/No)" -ForegroundColor White -BackgroundColor DarkMagenta
$ready = Read-Host "Selection"

if ($ready -notmatch "^(y|yes)$") {
    Write-Host "Exiting script. No changes were staged." -ForegroundColor Yellow
    return
}

# 6. Stage Files
Write-Host "`nStaging all files..." -ForegroundColor Gray
git add .
Write-Host "Current Staged Changes:" -ForegroundColor Magenta
git status -s

# 7. Description Loop
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

# 8. Final Commit Check
Write-Host "`n!!! LAST CHECK !!!" -ForegroundColor Black -BackgroundColor Yellow
$lastCheck = Read-Host "Commit these changes locally? [Y]es / [Q]uit"

if ($lastCheck -match "^y") {
    git commit -m "$finalMsg"
    Write-Host "SUCCESS: Changes committed locally." -ForegroundColor Green
    
    # 9. Push to GitHub Option
    $pushCheck = Read-Host "`nWould you like to PUSH (Upload) these changes to GitHub now? [Y]es / [N]o"
    if ($pushCheck -match "^y") {
        Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
        
        $currentBranch = (git branch --show-current)

        if ($GLOBAL:ForcePushRequired) {
            Write-Host "Performing FORCE push to resolve history mismatch..." -ForegroundColor Yellow
            git push origin $currentBranch --force
            $GLOBAL:ForcePushRequired = $false 
        } else {
            # --- THE SAFETY SWITCH ---
            # Temporarily allow errors so the script doesn't crash if there is no upstream
            $prevErrorAction = $ErrorActionPreference
            $ErrorActionPreference = "SilentlyContinue"
            
            $upstream = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
            
            # Restore original ErrorAction
            $ErrorActionPreference = $prevErrorAction

            if ($null -eq $upstream -or $LASTEXITCODE -ne 0) {
                Write-Host "No upstream found. Linking local branch to GitHub..." -ForegroundColor Gray
                git push -u origin $currentBranch
            } else {
                git push
            }
        }
        
        Write-Host "SUCCESS: Repository is now synced with GitHub!" -ForegroundColor Green
    } else {
        Write-Host "Skipping push. Your changes are saved locally." -ForegroundColor Yellow
    }
} else {
    Write-Host "Commit cancelled. Changes are still staged." -ForegroundColor Yellow
}

Write-Host "`nScript Complete!" -ForegroundColor Cyan