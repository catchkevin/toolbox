# List of all functions
Get-Command -CommandType Function | Where-Object { $_.ModuleName -eq '' }

# List of only custom added functions
Get-Command -CommandType Function | 
    Where-Object { $_.ScriptBlock.File -eq $PROFILE } | 
    Select-Object Name, Definition