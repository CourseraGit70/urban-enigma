#!/bin/sh

source linux_functions.sh
USRNME=whoami
UrbanEnigma=$(pwd)
AlertFile="$(pwd)/alerts.txt"

download_bind9_linux
configuration_linux_etc_hosts
configuration_linux_named_config_options
vpn_deploy_loop
i_red_mail_deploy

sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install bitcoin-qt