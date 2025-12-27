# PowerShell Profile Script Shortcuts

This guide explains how to add convenient PowerShell functions (aliases) to your profile for frequently used scripts, such as creating default project folders and automating git stage/commit/push operations.

## How to Add Script Shortcuts to Your PowerShell Profile

1. **Open your PowerShell profile for editing:**
     ```powershell
     notepad $PROFILE
     ```

2. **Add the following functions to your profile:**
     ```powershell
     # Shortcut for creating default project folders
     function New-ProjectFolders {
             & "C:\Users\catch\OneDrive\Documents\projects\projects setup info cheats\setting up new repository\scripts\default repository folders.ps1"
     }

     # Shortcut for git stage, commit, and push
     function git-commit-push {
             & "C:\Users\catch\OneDrive\Documents\projects\projects setup info cheats\setting up new repository\scripts\git stage commit push.ps1"
     }
     ```

3. **Save and close your profile.**

4. **Reload your profile or restart PowerShell to use the new functions:**
     ```powershell
     . $PROFILE
     ```

## Usage

- To create default project folders, run:
    ```powershell
    New-ProjectFolders
    ```
- To stage, commit, and push changes with git, run:
    ```powershell
    git-commit-push
    ```

## How to Remove These Functions

If you want to remove these functions from your current PowerShell session, run:

```powershell
Remove-Item Function:New-ProjectFolders
Remove-Item Function:git-commit-push
```

To permanently remove them, delete or comment out their definitions in your PowerShell profile and reload it.

---
*Created by catch — PowerShell automation shortcuts for project setup and git workflows.*