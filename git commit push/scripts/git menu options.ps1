# --- CONFIGURATION: PATHS ---
$Path_Personal = "C:\Users\catch\OneDrive\Documents\projects\toolbox\git commit push\scripts"
$Path_Work     = "C:\Users\kludwig\OneDrive\Documents\dev_and_scripts\toolbox\git commit push\scripts"

# --- DESIGN: STYLE B (PATH SELECTION) ---
Write-Host "`n****************************************************" -ForegroundColor White
Write-Host " SELECT ENVIRONMENT" -ForegroundColor Cyan
Write-Host "****************************************************" -ForegroundColor White

Write-Host "Options: [P]ersonal | [W]ork : " -ForegroundColor White -NoNewline
$envChoice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString().ToLower()
Write-Host $envChoice

# Logic to set the active ScriptPath
if ($envChoice -eq 'p') {
    $ScriptPath = $Path_Personal
    $VariableContext = "GIT: PERSONAL"
} elseif ($envChoice -eq 'w') {
    $ScriptPath = $Path_Work
    $VariableContext = "GIT: WORK"
} else {
    Write-Host "Invalid selection. Defaulting to Personal." -ForegroundColor Yellow
    $ScriptPath = $Path_Personal
    $VariableContext = "GIT: PERSONAL"
}

# --- DESIGN: STYLE A (COMMAND MENU) ---
Write-Host "`n****************************************************" -ForegroundColor White
Write-Host " CONTEXT HEADER: $VariableContext" -ForegroundColor Cyan
Write-Host "****************************************************" -ForegroundColor White

Write-Host "1. git status"
Write-Host "2. git diff"
Write-Host "3. git log [Full Details]"
Write-Host "4. git log [Stat Only]"
Write-Host "5. git [Commit / Push]"

# --- DESIGN: STYLE B (COMMAND SELECTION) ---
Write-Host "`nPick your Number: " -ForegroundColor White -NoNewline
$selection = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString()
Write-Host $selection

Write-Host "`n--- Executing from: $ScriptPath ---`n" -ForegroundColor Gray

# Logic for Commands
switch ($selection) {
    "1" { & "$ScriptPath\git status.ps1" }
    "2" { & "$ScriptPath\git diff.ps1" }
    "3" { & "$ScriptPath\git log.ps1" }
    "4" { & "$ScriptPath\git log -stat.ps1" }
    "5" { 
        # Call function or script for commit/push
        & "$ScriptPath\git-commit-push.ps1" 
    }
    Default { Write-Host "Invalid Selection." -ForegroundColor Red }
}