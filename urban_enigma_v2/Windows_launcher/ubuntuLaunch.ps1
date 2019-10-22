#/*
# Name: Luis Otero, Gregory Tyler 
# Student ID: 2281617, 2306644
# Chapman email: otero106@mail.chapman.edu, gtyler@chapman.edu
# Course number and section: 236-02
# Assignment Number: 05 – Final Project: Urban Enigma
#*/

#allows running of all scripts
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

#allows unsigned developers to change system variables
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"


#turns on linux subsystem
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"

#downloads ubuntu from the store
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing

#renames the file to be compatible with windows tools
Rename-Item Ubuntu.appx Ubuntu.zip

#unzips it
Expand-Archive Ubuntu.zip Ubuntu

#changes into the directory and runs in
cd .\Ubuntu\
.\ubuntu.exe

#default u/n and password
#username: stupidname
#password: stupidpassword







#housekeeping

sudo apt-get update
sudo apt-get upgrade
#binary included
#curl -O -J -L https://trailofbits/algo/archive/master.zip

#prep
sudo apt-get install unzip
unzip algo-master.zip
cd algo-master

#install requirements
sudo apt-get update && sudo apt-get install git build-essential libssl-dev libffi-dev python-dev python-pip python-setuptools python-virtualenv -y
cd ~ && git clone https://github.com/trailofbits/algo && cd algo

#configure python
python -m virtualenv --python=`which python2` env &&
    source env/bin/activate &&
    python -m pip install -U pip virtualenv &&
    python -m pip install -r requirements.txt

#start client script
    ./algo

#adds ubuntu to the path
$userenv = [System.Environment]::GetEnvironmentVariable("Path", "User")
[System.Environment]::SetEnvironmentVariable("PATH", $userenv + "C:\Users\Administrator\Ubuntu", "User")

#keeps the window open to see results
Read-Host -Prompt "Press Enter to exit"