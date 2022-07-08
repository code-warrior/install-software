# Software Installer
## CS 114, Fundamentals of Computing I

This repo contains a Bash script that automates installation of macOS-based software used by any number of courses I teach at UHart. Each class has its own branch. (This branch belongs to CS 114, Fundamentals of Computing I.) Thus, inspect the branch list for the course specific to you.

*Installation time*: ~15 minutes

---

## Installation
1. Close all programs running on your computer, then restart it
2. With your computer restarted, launch The Terminal by doing a Spotlight search (`⌘ + Space bar`), then search for “terminal”
4. Navigate to the root folder of this repository using The Terminal: `cd PATH_TO_PARENT_FOLDER_OF_THIS_FILE`
5. Change the permission bits of the files in this folder by typing `chmod 755 *`
6. Finally, run the script: `./install.sh`

---

## Updates
Once this installer is done, you’ll need to update VS Code and GitHub.

### Update VS Code
1. Launch VS Code
2. Go to the Code menu to the right of the  icon in the upper left-hand corner of your screen: `Code | Check for Updates...`
3. Restart VS Code

### Update GitHub
1. Launch GitHub
2. Go to the GitHub Desktop menu to the right of the  icon in the upper left-hand corner of your screen: `GitHub Desktop | About GitHub Desktop`
3. Click `Check for Updates`
4. Restart GitHub Desktop

---

## Bash Configuration
On newer installations of macOS, the default shell has been switched from Bash to the Z shell (`zsh`). You can verify this by typing `echo $SHELL` at The Terminal.

We’ll use bash in class. You can switch to Bash in two ways. The first is simple: Type `bash` at The Terminal, and you’ll be switched to bash for the duration of your session. The Z shell will still be your default shell.

A more permanent option is to allow The Terminal to set bash automatically: Bring up The Terminal’s preferences and go to `General | Shells open with `, then type `/bin/bash`.

---

## Verify Software
We now need to verify that `javac`, the Java compiler, `java`, the Java application launcher, and Git have been installed.

1. Launch The Terminal
2. Type `javac --version`. The Terminal should respond with something akin to `javac 18.0.1.1`.
3. Type `java --version`. The Terminal should respond with something akin to the earlier message, with some extra info regarding Java’s runtime environment and HotSpot server.
4. Type `git --version`. The Terminal should respond with `git version` followed by a SemVer number.

---

## Conclusion
All the macOS-based software you need for CS 114, *Fundamentals of Computing I*, is now installed on your Mac. Restart.