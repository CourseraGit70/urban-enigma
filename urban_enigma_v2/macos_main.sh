#!/bin/sh

source macos_functions.sh
set_up_unix_dependencies
gui_launch
install_extra_dependencies_unix
download_and_install_algo_unix

brew cask install osxfuse
brew install sshfs
cd cd Desktop
mkdir shared
cd shared
Shared=$(pwd)
sudo sshfs -o allow_other,defer_permissions,IdentityFile=/Users/gthome/Downloads/urbanenigma.pem  ubuntu@35.166.203.87:/home/ubuntu /Users/gthome/Desktop/shared
echo "sshfs#ubuntu@35.166.203.87:/home/ubuntu /Users/gthome/Desktop/shared" >> /etc/fstab

finish nginx config, domain and mail servers

