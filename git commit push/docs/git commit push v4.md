# ************************************************
# Helper Information
# ------------------------------------------------
# Account: catchkevin75
# Gemini Support Name: Git stage, commit, push automation script

# ************************************************

# Git Workflow Manager V2

A high-performance PowerShell utility designed to simplify Git lifecycle management. This script acts as an interactive "command center," providing a safer, more intuitive alternative to running raw terminal commands.

## 📌 Overview
Managing Git repositories can often lead to messy commit histories or lost work due to "dirty" rebases. This tool enforces a **Safety-First Architecture**: it ensures your local changes are snapshotted (committed) before it ever touches the remote server. 

By utilizing a **Rebase-Driven Workflow**, the script ensures that your project timeline remains a clean, linear path, free from unnecessary "Merge branch..." commits that clutter collaborative projects.

---

## 🚀 Operation Modes

The script offers three distinct paths depending on your immediate goal:

### 1. [S]tage Only (Simple Add)
* **What it does:** Runs `git add .` and displays a status summary.
* **When to use:** Use this for minor, temporary tracking where you aren't ready to create a formal "Save Point" yet, but want to see which files Git is currently watching.

### 2. [C]ommit (Local Save Point)
* **What it does:** Stages all files and creates a permanent local snapshot with a unique ID and description.
* **When to use:** This is your **Checkpoint**. Use this for significant local changes. It allows you to "Failback" (revert) to this exact moment if future work breaks the project. No internet is required.

### 3. [P]ush to GitHub (The Full Sync)
* **What it does:** The complete lifecycle:
    1.  **Commit:** Saves your work locally first.
    2.  **Smart Pull:** Performs a `pull --rebase` to bring down remote updates and slides your new work on top.
    3.  **Push:** Finalizes the sync by uploading your clean history to GitHub.
* **When to use:** Use this when you are finished with a task and want to safely backup and share your work.

---

## 🛠 Advanced Features

### Linear History Enforcement
The script defaults to `--rebase`. Unlike a standard merge, a rebase "rewrites" your local history to appear as if you wrote your code on top of the absolute latest version of the master branch. This results in a professional, easy-to-read commit graph.



### Conflict Resilience
If the remote repository has changed in a way that conflicts with your local code:
* The script detects the block immediately.
* It offers a **[F]orce** option to overwrite the remote with your local work (use with caution).
* It provides an **Abort** option to stop the process and let you resolve conflicts manually in your IDE.

### User Interface & Safety
* **Context Headers:** Displays your current Directory and Branch at all times to prevent "wrong repo" mistakes.
* **Prompt Roadmap:** A pre-run summary explains every step the script is about to take.
* **Clear Host Option:** An optional terminal cleanup and an **[E]xit** button for a quick escape before any logic runs.

---

## 📋 Requirements
* **Environment:** Windows PowerShell.
* **Git:** Must be installed and accessible via the system PATH.
* **Repository:** Must be run within a Git-initialized folder (or use the built-in [Y] Initialize prompt for new projects).

---

## 💡 Pro-Tip: The "Failback"
Because this script encourages a **Commit-then-Pull** logic, your work is saved the moment you enter your description. If the Sync/Push phase fails for any reason, your work is not lost; it is safely stored in your local Git history.