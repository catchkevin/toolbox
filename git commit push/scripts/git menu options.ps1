# --- CONFIGURATION ---
$VariableContext = "GIT QUICK-RUN"
$ScriptPath = "C:\Users\catch\OneDrive\Documents\projects\toolbox\git commit push\scripts"

# Function for Option 5 (Style C logic)
function gitcp {
    Write-Host "`n--- Running Git Commit & Push ---" -ForegroundColor Yellow
    # Insert commit/push logic or call script here
}

# --- DESIGN: PROMPT & SELECTION ---

# Style A: Header
Write-Host "`n****************************************************" -ForegroundColor White
Write-Host " CONTEXT HEADER: $VariableContext" -ForegroundColor Cyan
Write-Host "****************************************************" -ForegroundColor White

# Display Options
Write-Host "1. git status"
Write-Host "2. git diff"
Write-Host "3. git log [Full Details]"
Write-Host "4. git log [Stat Only]"
Write-Host "5. git [Commit / Push]"

# Style B: Selection (Instant Keypress)
Write-Host "`nPick your Number: " -ForegroundColor White -NoNewline
$selection = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character.ToString()
Write-Host $selection # Visual confirmation of the key pressed

Write-Host "`n--- Executing ---`n" -ForegroundColor Gray

# Logic for Selection
switch ($selection) {
    "1" { & "$ScriptPath\git status.ps1" }
    "2" { & "$ScriptPath\git diff.ps1" }
    "3" { & "$ScriptPath\git log.ps1" }
    "4" { & "$ScriptPath\git log -stat.ps1" }
    "5" { gitcp }
    Default { Write-Host "Invalid Selection. Exiting." -ForegroundColor Red }
}

# Script ends here and closes/returns to prompt automatically.