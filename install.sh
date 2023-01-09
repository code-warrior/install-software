#!/bin/bash

# Although “xterm-256color” is the default for the type of TERMinal macOS is using,
# explicitly setting it here ensures a correct value.
export TERM=xterm-256color

# If the variables.sh file exists, source it.
if [[ -e ./includes/globals/variables.sh ]]; then
   source ./includes/globals/variables.sh
else
   printf "The file variables.sh does not exist. This script requires it. Exiting...\n"

   exit 1
fi

# If the functions.sh file exists, source it.
if [[ -e ./includes/globals/functions.sh ]]; then
   source ./includes/globals/functions.sh
else
   printf "The file functions.sh does not exist. This script requires it. Exiting...\n"

   exit 1
fi

print_msg "log" "This script will install, update, and configure files and applications used"
print_msg "log" "in your Dept of Computing Sciences course at The University of Hartford."
echo ""

#####################################################################################
# Check if macOS version is at least Catalina (10.15.0), from Oct 2019
#####################################################################################
if [[ "$MAJOR_NUMBER_OF_CURRENT_OS" -lt "$MINIMUM_MAJOR_NUMBER_REQUIRED" ]]; then
   print_msg "error" "You are running $OS_VERSION of macOS, which is from before 2019. The minimum"
   print_msg "error" "version required to run the software installed by this script is $MINIMUM_MAJOR_NUMBER_REQUIRED.$MINIMUM_MINOR_NUMBER_REQUIRED.$MINIMUM_PATCH_NUMBER_REQUIRED"
   print_msg "error" "(Catalina). Please update your OS and try again. Exiting..."
   echo ""

   exit 1
else
   print_msg "warn" "This installation script was updated in Jan 2023 to work on macOS Monterey"
   print_msg "warn" "(12.1). It may work in versions as early as macOS Catalina ($MINIMUM_MAJOR_NUMBER_REQUIRED.$MINIMUM_MINOR_NUMBER_REQUIRED.$MINIMUM_PATCH_NUMBER_REQUIRED)."
   print_msg "warn" "However, versions older than that are likely not compatible with this"
   print_msg "warn" "script and are inadvisable to use."
   echo ""
fi

sudo -p "Enter your password, which, for security purposes, won’t be repeated in The
Terminal as you type it: " echo "${BG_GREEN}${BLACK} > Thank you! ${RESET}"

echo ""

print_msg "log" " "
print_msg "log" "Your current setup is: "
print_msg "log" " "
print_msg "log" "Operating System: $OS_NAME $OS_VERSION"
print_msg "log" "Shell:            $USER_SHELL"
print_msg "log" "Computer name:    $COMP_NAME"
print_msg "log" "Local hostname:   $LOCAL_HOST_NAME"
print_msg "log" "Full hostname:    $HOST_NAME"
print_msg "log" "Long user name:   $FULL_NAME"
print_msg "log" "Short user name:  $USER_NAME"
echo ""

#####################################################################################
# Do a quiet (-q) grep word search (-w) for “admin” privileges in the list of groups
# to which the current user belongs. If the user is an admin, proceed quietly.
#####################################################################################
if echo "$GROUPS_TO_WHICH_USER_BELONGS" | grep -q -w admin; then
   echo "" > /dev/null
else
   print_msg "error" " "
   print_msg "error" "The current user does not have administrator privileges. This program must be run "
   print_msg "error" "by a user with admin privileges. Exiting..."
   echo ""

   exit 1
fi

#####################################################################################
# Run software update, and, install (i) all (a) available packages.
#####################################################################################
print_msg "log" "Running software update... "
print_msg "log" " "
sudo softwareupdate -ia
print_msg "log" " "
print_msg "log" "Software update has been run."
echo ""

#####################################################################################
# Check for command line tools.
#####################################################################################
print_msg "log" "Checking for XCode Command Line Tools..."
echo ""

cmdline_version="CLTools_Executables"

#####################################################################################
# If the command line tools have been installed, they would appear as
# `com.apple.pkg.CLTools_Executables` in the result of `pkgutil --pkgs`. Similarly,
# `pkgutil --pkgs=com.apple.pkg.CLTools_Executables` yields
# `com.apple.pkg.CLTools_Executables`. Thus, if running the `pkgutil` command doesn’t
# return a null string, then the tools have been installed.
#####################################################################################
if [[ -n $(pkgutil --pkgs=com.apple.pkg."${cmdline_version}") ]]; then
   print_msg "log"  "Running software update on Mac OS... "
   echo ""

   # Install (-i) recommended (-r) software updates
   sudo softwareupdate -i -r
   print_msg "log" "Command Line Tools are installed!"
   echo ""
else
   print_msg "error" "Command Line Tools are not installed!"
   print_msg "error" "Running 'xcode-select --install' Please click Install!"
   echo ""

   xcode-select --install
fi

print_msg "log" "Setting OS configurations..."
echo ""

#####################################################################################
# Install environment, including Git, Bash, and Editorconfig
#####################################################################################
print_msg "log" "Downloading environment files for Git, Bash, and Editorconfig..."
echo ""

base_URL="https://raw.githubusercontent.com/code-warrior/web-dev-env-config-files/master"

install_configuration_file "$GIT_PROMPT" "${base_URL}/terminal/git-env-for-mac-and-windows/"
install_configuration_file "$GIT_COMPLETION" "${base_URL}/terminal/git-env-for-mac-and-windows/"
install_configuration_file "$BASH_ALIAS" "${base_URL}/terminal/mac/"
install_configuration_file "$BASH_RUN_COMMANDS" "${base_URL}/terminal/mac/"
install_configuration_file "$BASH_PFILE" "${base_URL}/terminal/mac/"
install_configuration_file "$EDITOR_CONFIG_SETTINGS" "${base_URL}/"

#####################################################################################
# Install typefaces
#####################################################################################
print_msg "log" "Installing typefaces..."
echo ""

install_typeface "IBMPlexMono-Regular.ttf" \
   "IBM Plex Mono" \
   "https://fonts.google.com/download?family=IBM%20Plex%20Mono" \
   "IBM_Plex_Mono.zip" \
   "IBM_Plex_Mono"
install_typeface "UbuntuMono-Regular.ttf" \
   "Ubuntu Mono" \
   "https://fonts.google.com/download?family=Ubuntu%20Mono" \
   "Ubuntu_Mono.zip" \
   "Ubuntu_Mono"
install_typeface "Inconsolata-VariableFont_wdth,wght.ttf" \
   "Inconsolata" \
   "https://fonts.google.com/download?family=Inconsolata" \
   "Inconsolata.zip" \
   "Inconsolata"
install_typeface \
   "CourierPrime-Regular.ttf" \
   "Courier Prime" \
   "https://fonts.google.com/download?family=Courier%20Prime" \
   "Courier_Prime.zip" \
   "Courier_Prime"

#####################################################################################
# Install Java
#####################################################################################
print_msg "log" "Installing Java..."
echo ""

install 'Java 19 SDK (Apple M1 Chip)' 'jdk-19_macos-aarch64_bin.dmg' 'https://download.oracle.com/java/19/latest/jdk-19_macos-aarch64_bin.dmg' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:108.0) Gecko/20100101 Firefox/108.0' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
-H 'Accept-Language: en-US,en;q=0.5' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Referer: https://www.oracle.com/java/technologies/downloads/' \
-H 'DNT: 1' \
-H 'Connection: keep-alive' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'Sec-Fetch-Dest: document' \
-H 'Sec-Fetch-Mode: navigate' \
-H 'Sec-Fetch-Site: same-site' \
-H 'Sec-Fetch-User: ?1' \
-H 'Sec-GPC: 1'

install 'Java 19 SDK (Intel Chip)' 'jdk-19_macos-x64_bin.dmg' 'https://download.oracle.com/java/19/latest/jdk-19_macos-x64_bin.dmg' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:108.0) Gecko/20100101 Firefox/108.0' \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
-H 'Accept-Language: en-US,en;q=0.5' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Referer: https://www.oracle.com/java/technologies/downloads/' \
-H 'DNT: 1' \
-H 'Connection: keep-alive' \
-H 'Upgrade-Insecure-Requests: 1' \
-H 'Sec-Fetch-Dest: document' \
-H 'Sec-Fetch-Mode: navigate' \
-H 'Sec-Fetch-Site: same-site' \
-H 'Sec-Fetch-User: ?1' \
-H 'Sec-GPC: 1'

#####################################################################################
# Install the VS Code text editor
#####################################################################################
print_msg "log" "Installing text editor..."

install 'Visual Studio Code' 'VSCode-darwin-universal.zip' 'https://az764295.vo.msecnd.net/stable/899d46d82c4c95423fb7e10e68eba52050e30ba3/VSCode-darwin-universal.zip' \
  -H 'authority: az764295.vo.msecnd.net' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://code.visualstudio.com/' \
  -H 'accept-language: en-US,en;q=0.9'

print_msg "warn" "Add VS Code to your path for command line usage before continuing:"
echo ""

print_msg "log" "1. Launch VS Code"
print_msg "log" "2. Open the command palette (CMD + SHIFT + P), then type 'shell command'"
print_msg "log" "3. Choose 'Shell Command: Install 'code' command in PATH'"
print_msg "log" "4. Close VS Code"
pause

# If VSCode is configured at the command line, then install the extensions
if code --help > /dev/null 2>&1; then
   for i in "${!VSCODE_EXTENSIONS[@]}"; do
      install_plugin_for "vscode" "${VSCODE_EXTENSIONS[$i]}"
   done
else
   print_msg "error" "VSCode isn’t configured to work from the command line. This may be the"
   print_msg "error" "result of not having configured it, not having installed VS Code, or some"
   print_msg "error" "other issue. If VS Code is installed, then visit"
   print_msg "error" "https://code.visualstudio.com/docs/setup/mac to learn how to configure VS"
   print_msg "error" "Code to work from the command line. Then, look at the VSCODE_EXTENSIONS"
   print_msg "error" "array in includes/globals/variables.sh for a list of the extensions that"
   print_msg "error" "should be installed manually."
   pause
fi

#####################################################################################
# Install GitHub
#####################################################################################
print_msg "log" "Installing the GitHub Desktop client..."
echo ""

install 'GitHub' 'GitHubDesktop-x64.zip' 'https://desktop.githubusercontent.com/github-desktop/releases/2.9.6-9196a1ae/GitHubDesktop-x64.zip' \
  -H 'authority: desktop.githubusercontent.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'referer: https://desktop.github.com/' \
  -H 'accept-language: en-US,en;q=0.9'

#####################################################################################
# Install Homebrew
#####################################################################################
print_msg "log" "Installing the Homebrew package manager..."
echo ""

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#####################################################################################
# Set OS configurations
#####################################################################################
print_msg "log" "Setting OS configurations..."
echo ""

print_msg "log" "Setting OS option that, when clicking the clock in the login window,"
print_msg "log" "reveals IP address, hostname, and OS version."
echo ""

sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

print_msg "log" "Setting OS option that accepts UTF-8 as input in The Terminal."
echo ""

sudo defaults write com.apple.terminal StringEncodings -array 4

print_msg "log" "Enabling the following features when clicking the clock in the upper"
print_msg "log" "right hand corner of the login window: Host name, OS version number, and"
print_msg "log" "IP address."
echo ""

sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

print_msg "log" "Show all filename extensions in Finder."
echo ""

defaults write NSGlobalDomain AppleShowAllExtensions -bool true

print_msg "log" "Show Path Bar (at the bottom of windows) in Finder."
echo ""

defaults write com.apple.finder ShowPathbar -bool true

print_msg "log" "Show Status Bar (below Path Bar) in Finder."
echo ""

defaults write com.apple.finder ShowStatusBar -bool true

print_msg "log" "Hide/show the Dock when the mouse hovers over the screen edge of the Dock."
echo ""

defaults write com.apple.dock autohide -bool true

print_msg "log" "Use UTF-8 as input to The Terminal."
echo ""

defaults write com.apple.terminal StringEncodings -array 4

print_msg "log" "Display full POSIX path as Finder window title."
echo ""

defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

print_msg "log" "Bring up a dialog box when the power button is held for 2 seconds."
echo ""

defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

print_msg "log" "Request user’s password to wake from sleep or return from screen saver."
echo ""

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

print_msg "log" "Expose the entire \"save\" panel (instead of collapsing it) when saving."
echo ""

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

print_msg "log" "Expose the entire \"print\" panel (instead of collapsing it) when printing."
echo ""

defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

print_msg "log" "Installation complete. Please restart your machine."
echo ""

for app in Finder Dock SystemUIServer;
   do killall "$app" >/dev/null 2>&1;
done
