# ==============================================================================
# INSTRUCTIONS FOR AI MODEL: SCRIPT STRUCTURE
# Section of the Script: HEADER INFO FOR ALL SCRIPTS Standardizations (TEMPLATE)
# ------------------------------------------------------------------------------
# DIRECTIVE: Properly incorporated as the mandatory starting framework.
# ==============================================================================

# 1. SET CONTEXT AND VERSION
$VariableContext = "GIT_INITIAL_SYNC_V1.1"
$LastUpdated     = "2026-01-11 20:55:00"

# --- DESIGN: CONTEXT HEADER ---
Write-Host "`n****************************************************" -ForegroundColor White
Write-Host " CONTEXT: $VariableContext" -ForegroundColor Cyan
Write-Host " UPDATED: $LastUpdated" -ForegroundColor Cyan
Write-Host "****************************************************" -ForegroundColor White

# --- DESIGN: PURPOSE AND PROMPTS HEADER ---
Write-Host " Script Purpose:" -ForegroundColor Yellow
Write-Host " Initializes a local Git repo and performs the first sync to GitHub."
Write-Host ""
Write-Host " Input/Steps Required:" -ForegroundColor Yellow
Write-Host " 1. Confirm initial sync intent"
Write-Host " 2. Choose or create a Commit Message"
Write-Host " 3. Provide the GitHub Repository URL"
Write-Host " 4. Final confirmation before pushing to 'main'"
Write-Host "****************************************************" -ForegroundColor White

# --- INTERACTION: RUN/CLEAR/EXIT (Wait for Enter) ---
Write-Host "`nDo you want to clear script terminal before running?" -ForegroundColor White
$choice = Read-Host " [Y]es | [N]o | [E]xit"
$selection = $choice.ToLower()

switch ($selection) {
    'e' { 
        Write-Host "`nExiting script..." -ForegroundColor Red
        exit 
    }
    'y' { 
        # Clear-Host (Commented out per user preference 2026-01-10)
        Write-Host "Continuing with current terminal view..." -ForegroundColor Gray
    }
    'n' { 
        Write-Host "Proceeding..." -ForegroundColor Gray 
    }
    Default {
        Write-Host "`nInvalid selection. Exiting to prevent accidental execution." -ForegroundColor Red
        exit
    }
}

# ==============================================================================
# START MAIN SCRIPT LOGIC
# ==============================================================================
Write-Host "`n--- Execution Started ---" -ForegroundColor Green

# 1. INITIAL CONFIRMATION
Write-Host "`n****************************************************" -ForegroundColor White
$confirmSync = Read-Host " Confirm initial sync from local to new github.com repo: [Y]es | [E]xit"
if ($confirmSync.ToLower() -ne 'y') { Write-Host "Exiting..."; exit }

# 2. GIT INIT & ADD
Write-Host "Initializing Git and staging files..." -ForegroundColor Gray
git init
git add .

# 3. COMMIT MESSAGE LOGIC
$defaultMessage = "Initial commit of existing local code"
Write-Host "`nCommit Message: $defaultMessage" -ForegroundColor White
$msgChoice = Read-Host " Options: Accept [D]efault | [C]reate custom | [E]xit"

switch ($msgChoice.ToLower()) {
    'e' { Write-Host "Exiting..."; exit }
    'd' { $finalMessage = $defaultMessage }
    'c' { $finalMessage = Read-Host " >> Enter Custom Commit Message" }
    Default { Write-Host "Invalid entry. Exiting."; exit }
}

git commit -m "$finalMessage"

# 4. BRANCH & REMOTE
Write-Host "`nUpdating branch name to main..." -ForegroundColor Cyan
git branch -M main

$repoUrl = Read-Host "`n Provide github.com repository URL"
if ([string]::IsNullOrWhiteSpace($repoUrl)) { Write-Host "URL cannot be empty."; exit }

git remote add origin $repoUrl

# 5. FINAL PUSH CONFIRMATION
Write-Host "`n****************************************************" -ForegroundColor White
$finalPush = Read-Host " Last step, okay to push to github: [Y]es | [E]xit"

if ($finalPush.ToLower() -eq 'y') {
    Write-Host "Pushing to origin main..." -ForegroundColor Green
    git push -u origin main
    $pushStatus = "Success"
} else {
    Write-Host "Push cancelled. Local repo remains initialized." -ForegroundColor Yellow
    $pushStatus = "Cancelled"
}

# ==============================================================================
# RESULTS & SUMMARY OUTPUT
# ==============================================================================

# The Summary Function
function Show-ScriptSummary {
    param([string]$Title = "GIT INITIAL SYNC SUMMARY")

    # Determine status color for legacy PowerShell compatibility
    $statusColor = "Yellow"
    if ($pushStatus -eq "Success") { $statusColor = "Green" }

    Write-Host "`n--- $Title ---" -ForegroundColor Blue
    Write-Host "Final Commit Msg: $finalMessage" -ForegroundColor White
    Write-Host "Remote URL:       $repoUrl" -ForegroundColor White
    Write-Host "Push Status:      $pushStatus" -ForegroundColor $statusColor
    
    Write-Host "--------------------------" -ForegroundColor Blue
    Write-Host "Done.`n"
}

Show-ScriptSummary