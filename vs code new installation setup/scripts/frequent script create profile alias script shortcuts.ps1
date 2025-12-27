

# Check if PowerShell profile exists; if not, create it
if (!(Test-Path -Path $PROFILE)) {
	New-Item -Path $PROFILE -ItemType File -Force | Out-Null
}


# Define the functions to add (name and code)
$functionsToAdd = @(
	@{ Name = 'New-ProjectFolders'; Code = 'function New-ProjectFolders {\n    & "C:\\Users\\catch\\OneDrive\\Documents\\projects\\projects setup info cheats\\setting up new repository\\scripts\\default repository folders.ps1"\n}'}
	@{ Name = 'git-commit-push'; Code = 'function git-commit-push {\n    & "C:\\Users\\catch\\OneDrive\\Documents\\projects\\projects setup info cheats\\setting up new repository\\scripts\\git stage commit push.ps1"\n}'}
)

$added = @()
$skipped = @()
foreach ($func in $functionsToAdd) {
	if (Get-Command -Name $func.Name -CommandType Function -ErrorAction SilentlyContinue) {
		$skipped += $func.Name
		Write-Host ("SKIPPED: Function '$($func.Name)' already exists.") -ForegroundColor Yellow
	} else {
		Add-Content -Path $PROFILE -Value ($func.Code + "`n")
		$added += $func.Name
		Write-Host ("ADDED:   Function '$($func.Name)' added to profile.") -ForegroundColor Green
	}
}

Write-Host ("`nSummary:") -ForegroundColor Cyan
Write-Host ("  Functions added:   {0}" -f $added.Count) -ForegroundColor Green
if ($added.Count -gt 0) { Write-Host ("    " + ($added -join ", ")) -ForegroundColor Green }
Write-Host ("  Functions skipped: {0}" -f $skipped.Count) -ForegroundColor Yellow
if ($skipped.Count -gt 0) { Write-Host ("    " + ($skipped -join ", ")) -ForegroundColor Yellow }


# ---
# Prompt to remove functions from current session

$removePrompt = Read-Host "Would you like to remove any functions? (Yes/No/List)"
if ($removePrompt -match '^(n|no)$') {
	Write-Host "No functions will be removed. Exiting."
	return
}

# Get all user-defined functions (excluding built-in ones)
$customFunctions = Get-Command -CommandType Function | Where-Object { $_.ModuleName -eq '' }
if ($removePrompt -match '^(list)$') {
	if ($customFunctions.Count -eq 0) {
		Write-Host "No custom functions found."
		return
	}
	Write-Host "Custom functions:"
	$i = 1
	foreach ($func in $customFunctions) {
		Write-Host "$i. $($func.Name)"
		$i++
	}
	$removePrompt = Read-Host "Would you like to remove any functions? (Yes/No)"
	if ($removePrompt -match '^(n|no)$') {
		Write-Host "No functions will be removed. Exiting."
		return
	}
}

if ($customFunctions.Count -eq 0) {
	Write-Host "No custom functions found."
	return
}

Write-Host "Select the number(s) of the function(s) to remove (comma separated):"
$i = 1
$funcMap = @{}
foreach ($func in $customFunctions) {
	Write-Host "$i. $($func.Name)"
	$funcMap[$i] = $func.Name
	$i++
}

$selection = Read-Host "Enter number(s) (or press Enter to cancel)"
if ([string]::IsNullOrWhiteSpace($selection)) {
	Write-Host "No functions selected. Exiting."
	return
}

$toRemove = $selection -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' -and $funcMap.ContainsKey([int]$_) } | ForEach-Object { $funcMap[[int]$_] }
$removed = @()
foreach ($funcName in $toRemove) {
	if (Get-Command -Name $funcName -CommandType Function -ErrorAction SilentlyContinue) {
		Remove-Item Function:$funcName -ErrorAction SilentlyContinue
		$removed += $funcName
		Write-Host ("REMOVED: Function '$funcName' removed from session.") -ForegroundColor Red
	}
}
if ($removed.Count -gt 0) {
	Write-Host ("Removed function(s): " + ($removed -join ", ")) -ForegroundColor Red
} else {
	Write-Host "No functions were removed." -ForegroundColor Yellow
}

# ---
