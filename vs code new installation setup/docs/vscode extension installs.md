# Install-VSCodeExtensions.ps1

## Overview

This PowerShell script automates the installation of a curated list of Visual Studio Code extensions. It checks which extensions are already installed and only installs those that are missing, providing a clear summary at the end. This is ideal for quickly setting up a new development environment or sharing a consistent toolset with your team.

---

## Features
- **Automated Installation:** Installs a predefined set of VS Code extensions.
- **Idempotent:** Skips extensions that are already installed, so you can safely run it multiple times.
- **User Feedback:** Color-coded output for actions (install, skip, errors, summary).
- **Summary Report:** Lists which extensions were installed and which were skipped.

---

## Prerequisites
- **PowerShell** (Windows, macOS, or Linux)
- **Visual Studio Code** installed
- The `code` command must be available in your system PATH.

> **Tip:** If you see an error about the `code` command not being found, open VS Code, press `Ctrl+Shift+P`, and run `Shell Command: Install 'code' command in PATH`.

---

## Usage

1. **Save the Script:**
   Save the script as `Install-VSCodeExtensions.ps1`.

2. **Open PowerShell:**
   Open a PowerShell terminal window.

3. **Run the Script:**
   ```powershell
   .\Install-VSCodeExtensions.ps1
   ```

---

## What Extensions Are Installed?

The script installs the following extensions:

| Name                    | Extension ID                          |
|-------------------------|---------------------------------------|
| GitHub Copilot          | GitHub.copilot                        |
| GitHub Pull Requests    | GitHub.vscode-pull-request-github     |
| PowerShell              | ms-vscode.powershell                  |
| Markdown All in One     | yzhang.markdown-all-in-one            |
| markdownlint            | DavidAnson.vscode-markdownlint        |
| Spell Checker           | streetide-vsc.spell-checker           |
| SpellChecker            | swyphcosmo.spellchecker               |

You can customize the `$extensions` array in the script to add or remove extensions as needed.

---

## Script Logic (How It Works)
1. Checks if the `code` command is available in your PATH.
2. Defines a list of desired extensions (with IDs and friendly names).
3. Gets the list of currently installed extensions.
4. Installs any missing extensions, skipping those already present.
5. Prints a summary of actions taken.

---

## Example Output
```
Checking and installing Visual Studio Code extensions...
Installing: GitHub.copilot (GitHub Copilot)
Skipping: ms-vscode.powershell (PowerShell) (already installed)
...
==============================
 VS Code Extension Summary
==============================
Installed: 2
  - GitHub Copilot | GitHub.copilot
  - markdownlint   | DavidAnson.vscode-markdownlint
Skipped:   5
  - PowerShell     | ms-vscode.powershell
  ...
Total:     7
==============================
All done!
```

---

## Customization
- **Add/Remove Extensions:**
  Edit the `$extensions` array at the top of the script to include any extensions you want.
- **Re-run Anytime:**
  The script is safe to run as often as you like; it will only install missing extensions.

---

## License
Feel free to use, modify, and share this script!

---

*Created by catch — Automate your VS Code setup for speed and consistency.*
