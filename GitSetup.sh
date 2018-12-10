#!/bin/bash

# Declare yo variables
    varTmp="/tmp/gitsetup"
    varHome="/home/$(whoami)/"
    varHomeVim="/home/$(whoami)/.vim"
	
# Install Git
printf 'Installing Git, you may need to enter sudoer password...\n\n'
    sudo apt-get install git

# User input
printf "Enter your Git user name: \n"
    read -r varUser
printf "Enter your Git email address: \n"
    read -r varEmail

# Apply some value 
    git config --global user.name $varUser
    git config --global user.email $varEmail
    git config --global color.ui auto

# Stay safe
if [ ! -d "$varTmp" ]; then
    printf "Creating temp directory ... \n\n"
    mkdir /tmp/gitsetup
fi
    cd "$varTmp"
    pwd; sleep 2

# Download/Setup Vim
    wget https://github.com/tambow44/.vim/archive/master.zip
    unzip master.zip

# Homeward bound
if [ ! -d "$varHomeVim" ]; then
    printf "Creating '$varHomeVim' ... \n\n"
    mkdir "$varHomeVim"
fi
    cd "$varHomeVim"
    pwd; sleep 2

# Phone home...
printf "Moving Day...\n\n"
    cp -r /tmp/gitsetup/.vim-master/ "$varHomeVim"
    cp "$varHomeVim"/.bkup/.* "$varHome"
    ls -la "$varHome" | grep vim
    sleep 2

# Cleaning day
if [ -d "$varTmp" ]; then
    rm -rf "$varTmp"
fi

exit