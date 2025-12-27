# Setting up a new project for VSCode

## Setup local repository (folder)
1. Initialize your Local Repository
   1. First, you need to tell Git to track your project folder.
   2. Open your project folder in VS Code.
   3. Open the terminal in VS Code (Ctrl + ~).
   4. Run the following command:
      1. type: git init
   5. (Optional) To ignore tracking of certain files or file types, add the additional if needed
      1. Create a file named .gitignore at root of project
         1. Example Ignore File for Excel
            1. ignore file
               #Copy from below ---
               # Ignore Excel temporary/lock files (The ones that start with ~$)
               ~$*.xlsx
               ~$*.xlsm
               ~$*.xlsb

               # Ignore Excel's automatic backups and temp files
               *.tmp
               *.bak
               *.crdownload

               # Optional: Ignore your "misc" folder if you don't want it on GitHub
               # misc/
               --- to above

## Connect to GitHub
1.  Go to GitHub and create a New Repository.
2.  Give it a name and keep it Public or Private.
    1.  Do not initialize it with a README or License yet (it's easier to push an existing project).
3.  Copy the Remote URL (it looks like https://github.com/yourname/your-repo.git).
4.  Goto VS Code terminal
    1.  Link your local folder to GitHub:
    2.  Using Bash:
        1.  type: git remote add origin [PASTE_URL_HERE]
  
--------------


## Best Practice: Handling the Script Files
Keep a separate folder: Create a folder named /src or /scripts in your VS Code workspace.

## Initialize the project for git
1. Bash terminal
2. Type: git init

## Create Default Project Folders
Script location \projects\projects setup info cheats\setting up new repository\scripts
Run Script ../default repository folders.ps1
1. Default folders:
   1. bin - For compiled binaries or build artifacts.
   2. config - For configuration files (ex. YAML, JSON, ENV, etc.).
   3. docs - For documents like the markdowns 
   4. docs_script_updates - For notes of script addition, changes, updates. (Developers verbos information)
   5. data - For datasets, sample data, or database files.
   6. distribution - For distribution-ready files (ex. minified, bundled, or packaged output).
   7. future_features - For ideas or plans for future features or enhancements.
   8. images - For images
   9. lib - For libraries or reusable code modules.
   10. logs - For log files
   11. release_notes - For release notes
   12. project_scripts - For scripts that compliment the project, perform additional work (ex. clean up scripts, macros).
   13. src - For source code
   14. tmp - For temporary files
   15. tools - For developer tools, scripts, or utilities.
   16. test - For unit, integration, or end-to-end tests
   17. misc - miscellaneous items
2. How to execute in new project
3. Goto new project in vscode
4. Goto the powershell terminal
5. Enter full path and powershell script name
   1. (copy including quotes) & "C:\Users\catch\OneDrive\Documents\projects\toolbox\project repository default_new setups\script_create repository folders.ps1"

### Notes to Bullet 5
The & symbol is the "Call Operator." It tells PowerShell: "Go to this location and execute whatever is there."

Because your terminal is "pointing" at your New Project folder, the mkdir commands inside the script will build the folders right where you want them.

"docs", "release_notes"