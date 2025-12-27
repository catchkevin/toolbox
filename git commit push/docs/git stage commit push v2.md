# Git Commit & Push Helper (v2.0)

### 🚀 Overview
This PowerShell script provides an intelligent, interactive workflow for managing your Git repositories. It acts as a "safety net," ensuring you stay in sync with GitHub, handle new projects correctly, and never commit code with messy merge markers.

---

### ✨ Key Features

* **🔍 Auto-Detection:** Detects if a folder is a Git repo; if not, it offers to run `git init` and link to GitHub for you.
* **🔄 Sync Before Save (Pull):** Automatically pulls the latest changes from GitHub to prevent "Rejected Push" errors later.
* **⚠️ Conflict Safety:** Detects if a "Merge Conflict" occurs during the pull and stops the script safely so you can fix files manually.
* **📝 Staging Summary:** Displays a concise list of modified files (`git status -s`) before you commit.
* **🔁 Review & Redo Loop:** Review your commit message and redo it if you spot a typo.
* **⬆️ Smart Push:** Automatically handles the first-time setup push (`-u origin main`) if it’s a new project.

---

### 🛠️ How to Use

1.  **Open Terminal:** Open your project folder in VS Code.
2.  **Run the Script:**
    ```powershell
    & "C:\Path\To\Your\Toolkit\git-helper.ps1"
    ```
3.  **Follow the Intelligent Prompts:**
    * **New Project?** The script will ask to initialize Git and prompt for your GitHub URL.
    * **Existing Project?** It will automatically `git pull` to ensure you are up to date.
    * **Conflict Check:** If a pull fails, follow the on-screen instructions to fix files in VS Code.

---

### 📉 The Integrated Workflow
The script automates the following logic to keep your code safe:

1.  **Sync:** `git pull origin main` (Checks for cloud updates)
2.  **Stage:** `git add .` (Gathers your local changes)
3.  **Commit:** `git commit -m "Your Description"` (Saves locally)
4.  **Push:** `git push` (Uploads to GitHub)

---

### 📋 Prerequisites
* **Execution Policy:** Ensure PowerShell allows you to run local scripts:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
* **GitHub URL:** Have your repository URL ready (e.g., `https://github.com/username/repo-name`) if setting up a new project.

---

### 🆘 Troubleshooting

* **Merge Conflict Error:** If the script stops during the "Pull" phase, look at your files in VS Code. Look for `<<<<<<< HEAD` markers, choose which code to keep, save the file, and run the script again.
* **Nothing to Commit:** If no changes have been made, the script will stage nothing and the commit will not trigger.

> **Pro-Tip:** When a **Merge Conflict** happens, press `Ctrl + Shift + P` and type **"Merge Conf"** to see all conflict-related commands in VS Code.