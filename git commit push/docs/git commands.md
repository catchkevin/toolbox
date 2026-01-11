# Git Commands

before running master script
git add .
git commit -m "text"

I like this add too:
# 3. Commit with a timestamp or a generic message
# (You could also pass a message as an argument)
MESSAGE=${1:-"Auto-update $(date +'%Y-%m-%d %H:%M:%S')"}
git commit -m "$MESSAGE"



1. git status (The "Current Inventory" Check)
You should run this constantly. It tells you exactly what is happening in your workspace right now before you make a save point.

   1. What it shows:
      1. Untracked files: New files Git hasn't started watching yet.
      2. Modified files: Files you changed but haven't "staged" (put in the box for the next commit).
      3. Staged files: Changes that will be in your next commit.
      4. Branch Info: Are you ahead or behind the cloud (GitHub)?

Pro Tip: Use git status -s for a "Short" version. It uses a code like M (Modified) or ?? (Untracked) to give you a clean, one-line-per-file view.

2. git log (The "Quest Journal")
This is how you look at every save point you have ever made. It is your project’s history book.

   1. The Basic Version: git log Shows a long list of commits with the Author, Date, and Message. (Press q to exit this view!)
   2. The "Bird's Eye" View: git log --oneline This is much easier to read. Each save point gets exactly one line.
   3. The "Deep Dive": git log -p This shows the actual code changes (the "diff") inside every commit.
   4. The Search: git log --grep="bug fix" This searches your history for any commit message containing "bug fix.
Examples:
git log --all --oneline --graph --decorate The "Big Three" Combo:  (This is the "Pro" view included in your script).

git log -S "code snippet": (The "Pickaxe") Searches the actual code for when a specific string was added or removed.
git log -p	Shows the actual code changes.

git log --stat	Shows which files changed and how much.

git log --oneline -5	Shows a quick list of the last 5 saves.

git log --author="Me"	Shows only my work.

git log --grep="fix"	Finds saves related to fixing things.


3. git diff (The "What did I actually change?" tool)
Before you even run your script, you might forget exactly what lines of code you edited.
    Command: git diff
    
    What it does: Shows the exact line-by-line changes in your files that haven't been staged yet.
    
    Why use it: It’s a great "sanity check" to make sure you didn't leave a console.log or a password in your code before committing.

4. git checkout or git restore (The "Undo" buttons)
If you made a mess of a file and just want to throw away your changes and go back to how the file looked at the last "Save Point."
    Command: git restore <filename>

    What it does: Discards local changes in a specific file and restores it to the last committed state.

    Why use it: When an experiment fails and you just want to start that file over from scratch.

5. git stash (The "Pause" button)
Imagine you're halfway through a feature, but you need to switch branches to fix a bug or pull a teammate's code. You aren't ready to commit yet because the code is "broken."

    Command: git stash (to save)
    Command: git stash pop (to bring it back).

    What it does: Takes your uncommitted changes, puts them in a "temporary drawer," and clears your workspace.

    Why use it: It allows you to move around Git without being forced to create a "messy" commit just to save your place.

6. git branch (The "Parallel Universe" tool)
Instead of working on main all the time, you can create a branch for a specific feature.

    Command: git checkout -b feature-name

    What it does: Creates a new timeline where you can take risks without breaking the "main" version of your project.

    Why use it: This is how professional teams work. You do your work on a branch, and only "Merge" it into main once it’s perfect.

7. git remote -v (The "Connection Check")
If you ever wonder "Where is this actually pushing to?", use this.

    Command: git remote -v

    What it does: Lists the URLs of the cloud repositories (like GitHub) your local folder is linked to.

    Why use it: Useful if you need to verify you are pushing to the correct GitHub account or organization.
8.  git pull
    1.  -rebase
        1.  You only need to pull if Git rejects your push. This happens if you (or someone else) pushed changes from a different device that your current computer doesn't know about yet.
        2.  Using --rebase keeps your commit history linear and "cleaner" by putting your new changes on top of the latest changes from the server, rather than creating a messy "Merge commit" every time you run your script.
        3.  Why use --rebase?
            1.  In a standard git pull, Git performs a Merge. This often creates a "Merge commit" (e.g., "Merge branch 'main' of github.com..."), which can make your project history look like a tangled web of lines.
            2.  Rebase is used to keep a linear history. Instead of joining two branches with a new commit, it takes your local commits, "lifts" them up, pulls the new changes from the server, and then places your commits back down on top. It looks like you did all your work after the latest updates, even if you didn't.
