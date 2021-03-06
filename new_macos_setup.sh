#!/usr/bin/env bash

# Thanks to Adam Eivy https://github.com/atomantic/dotfiles
source ./config/echos.sh
source ./config/requirers.sh

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
Usage: $(basename "$0")
See the README for documentation.
https://github.com/micjagga/dotfiles
Copyright (c) 2016 "Temper" Enoc Leonrd
Licensed under the ISC license.
http://leonrdenoc.me/ for more information
HELP
exit; fi

awesome_header

fullname=$(osascript -e "long user name of (system info)")

bot "Hi $fullname. I'm going to make your OSX system better. We're going to:"
action "install Xcode's command line tools"
action "install Homebrew and brew cask"
action "install all better default applications"
action "if you feel like it, we will also install more things"

bot " I'm going to install some tooling and tweak your system settings. Here I go..."

# Ask for the administrator password upfront
if sudo grep -q "# %wheel\tALL=(ALL) NOPASSWD: ALL" "/etc/sudoers"; then

# Ask for the administrator password upfront
bot "I need you to enter your sudo password so I can install some things:"
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

read -r -p "Make sudo passwordless? [y|N] " response

if [[ $response =~ (yes|y|Y) ]];then
   sed --version 2>&1 > /dev/null
   sudo sed -i '' 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      if [[ $? == 0 ]];then
         sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
     fi
    sudo dscl . append /Groups/wheel GroupMembership $(whoami)
    bot "You can now run sudo commands without password!"
   fi
fi
##############################################################################
# XCode Command Line Tools                                                    #
###############################################################################
running "checking Xcode CLI install"
xcode_select="xcode-select --print-path"
xcode_install=$($xcode_select) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
    bot "You are missing the Xcode CLI tools. I'll launch the install for you, but then you'll have to restart the process again."
    running "After that you'll need to paste the command and press Enter again."

    read -r -p "Let's go? [y|N] " response
    if [[ $response =~ ^(y|yes|Y) ]];then
        xcode-select --install &> /dev/null
    fi
    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done
fi
ok
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Point the `xcode-select` developer directory to
  # the appropriate directory from within `Xcode.app`
  # https://github.com/alrra/dotfiles/issues/13

sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
action 'Making "xcode-select" developer directory point to Xcode' ok

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Prompt user to agree to the terms of the Xcode license
  # https://github.com/alrra/dotfiles/issues/10

sudo xcodebuild -license
bot 'Agree with the XCode Command Line Tools licence'

bot "OK, let's roll..."
bot "Woot! All done. If you want to go further, here are some options:"

read -r -p "install extra development command-line tools? (node, curl, etc) [y|N] " cli_response
if [[ $cli_response =~ ^(y|yes|Y) ]];then
    ok "will install command-line tools."
else
    ok "will skip command-line tools.";
fi
bot "Creating missing Site & Developer directories for your development"

read -r -p "create development folder structure (~/Development/sites)? [y|N] " dev_folder_response
if [[ $dev_folder_response =~ ^(y|yes|Y) ]];then
    ok "will create the folder structure."
else
    ok "will skip folder structure.";
fi

if [[ $cli_response =~ ^(y|yes|Y) ]];then
    bash ./bin/setup.sh
else
    ok "skipped command-line tools.";
fi

if [[ $dev_folder_response =~ ^(y|yes|Y) ]];then
    mkdir -p ~/Development/sites/
    ok "Created ~/Development/sites/"
else
    ok "skipped development folder structure.";
fi

bot "I'm going to install some tooling and tweak your system settings. "

read -r -p "Would you like me to do this? [y|N] " toolresponse
if [[ $toolresponse =~ ^(y|yes|Y) ]];then
    ok "will tweak your system setting with better defaults."
else
    ok "will skip tweaking your system setting with better defaults.";
fi

if [[ $toolresponse =~ ^(y|yes|Y) ]];then
bash ./install.sh;
else
    ok "Skipped tweaking your system setting with better defaults.";
fi

bot "All done. Have fun!"
