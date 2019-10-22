#!/bin/sh
 
source functions.sh
USRNME=whoami
Xcode=497799835

set_up_unix_dependencies
cd electron-quick-start
echo "welcome" > alerts.txt
brew install node >> output.txt
echo "text2" >alerts.txt
npm install
npm start >> output.txt 
npm install sanitize --save >> output.txt

set_up_unix_build
build_unix_install >> output.txt
install_unix_bind9
configuraton_unix_named_config
download_unix_filters
configuration_unix_localhost_zone
configuration_unix_named_local
configuration_unix_named_block
configuration_unix_xml_launch_daemon
check_and_test_unix
install_extra_dependencies_unix
download_and_install_algo_unix
download_bind9_linux
sudo /etc/init.d/bind9 restart
vpn_deploy_loop
