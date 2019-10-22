#!/bin/sh

USRNME=whoami
UrbanEnigma=$(pwd)
AlertFile="$(pwd)/alerts.txt"

set_up_unix_dependencies()
{
	Xcode=497799835
	BrewURL=https://raw.githubusercontent.com/Homebrew/install/master/install
	Test=www.yahoo.com

	echo "Welcome" > $AlertFile
	echo "Please update Mac OSX to the latest version" >> $AlertFile
	echo "Installing brew"
	ruby -e "$(curl -fsSL $BrewURL)"
	brew tap caskroom/cask
	brew install caskroom/cask/brew-cask
	brew install mas
	echo "Install the Xcode app from the App Store"
	mas install $Xcode
	echo "Installing Xcode Tools"
	xcode-select --install
	echo "Please start Xcode and accept permissions"
	echo "Installing wget"
	brew install wget
	echo "Test tools"
	wget $Test
}

gui_launch()
{
	electron=electron-quick-start
	GUIDir="${UrbanEnigma}/${electron}"
	cd
	cd GUIDir

	echo "welcome" > alerts.txt
	brew install node >> output.txt
	echo "text2" >alerts.txt
	npm install
	npm start >> output.txt 
	npm install sanitize --save >> output.txt
}

set_up_unix_build()
{
	OpenSSLURL=http://www.openssl.org/source/openssl-1.0.2g.tar.gz
	OpenSSLName=openssl-1.0.2g.tar.gz
	OpenSSLFile="${UrbanEnigma}/${OpenSSLName}"
	
	sudo mkdir /usr/local/bindmac
	sudo chown $USRNME /usr/local/bindmac
	cd
	mkdir /usr/local/bindmac/openssl
	mv $OpenSSLFile /usr/local/bindmac/openssl
	cd
	cd /usr/local/bindmac/openssl
	tar zxf $OpenSSLName
	mkdir install-1.0.2g
	echo "Create a link"
	ln -s install-1.0.2g install
}

build_unix_install()
{
	echo "Build the secure software"
	cd
	cd /usr/local/bindmac/openssl/openssl-1.0.2g
	sudo ./Configure darwin64-x86_64-cc --prefix=/usr/local/bindmac/openssl/install-1.0.2g
	sudo make depend
	sudo make
	sudo make test
	sudo make install
}

install_unix_bind9()
{
	BindURL=https://www.isc.org/downloads/file/bind-9-10-6/?version=tar-gz
	BindName=bind-9.10.3-P3.tar.gz
	BindFile="${UrbanEnigma}/${BindName}"
	

	echo "Set up BIND9"
	cd
	mkdir /usr/local/bindmac/bind
	cd
	cd /usr/local/bindmac/bind
	mv $BindFile /usr/local/bindmac/bind
	tar zxf bind-9.10.3-P3.tar.gz
	cd
	cd /usr/local/bindmac/bind/bind-9.10.3-P3
	sudo ./configure --with-openssl=/usr/local/bindmac/openssl/install
	sudo make
	sudo make test
	echo "Test should fail"
	echo "This next part might take an hour or two, the internet is a big place"
	sudo bin/tests/system/ifconfig.sh up
	sudo make force-test
	sudo make install
	echo "Wooo all set up, time to input details"
	sudo bash
	/usr/local/sbin/rndc-confgen | sed '/^#/d' | head -n 10 > /etc/rndc.conf
	head -n 4 /etc/rndc.conf > /etc/rndc.key
}

configuration_unix_named_config()
{
	cat > /etc/named.conf  <<'END'
# /etc/named.conf

include "/etc/rndc.key";

// modify 192.168.22.0/24 to be your non-localhost local network to allow access, or omit the entry
acl our-networks { localhost; 192.168.22.0/24; };
acl bogus-networks { 0.0.0.0/8; 192.0.2.0/24; 224.0.0.0/3; 10.0.0.0/8; 172.16.0.0/12; 192.168.0.0/16; };

// control access from the /usr/local/sbin/rndc utility to be this computer only
controls { inet 127.0.0.1 allow { 127.0.0.1; } keys { "rndc-key"; }; };

// global options
options {
	directory "/var/named";
	allow-new-zones yes;
	notify no;
	querylog yes;
	allow-query { our-networks; };
	allow-recursion { our-networks; };
	allow-transfer { our-networks; };
	blackhole { bogus-networks; };
	max-ncache-ttl 300;
	// If you enable the next two lines (forward... and forwarders...), BIND will query OpenDNS first
	// (for all zones we are not master on) if it does not already have the answer cached.
	// forward first;
	// forwarders { 208.67.222.222; 208.67.220.220; };
	// If you want to use Google DNS instead of the line above, use the line below
	// forwarders { 8.8.8.8; 8.8.4.4; };
};


zone "." IN { type hint; file "named.ca"; };

zone "localhost" IN { type master; file "localhost.zone"; allow-update { none; }; };

zone "0.0.127.in-addr.arpa" IN { type master; file "named.local"; allow-update { none; }; };

// local upstream ISP may present internal response different from external queries (e.g. for SMTP/POP/IMAP)
// so defer to them, but fallback if no response from them
zone "bell.ca" IN { type forward; forward first; forwarders { 207.164.234.193; 207.164.234.129; }; };

// When querying for zone example.com, use the OpenDNS name servers. This is an example of per-domain use of OpenDNS
zone "example.com" IN { type forward; forward first; forwarders { 208.67.222.222; 208.67.220.220; }; };

// When querying for zone zombo.com, use the Google name servers. This is an example of per-domain use of Google DNS
zone "zombo.com" IN { type forward; forward first; forwarders { 8.8.8.8; 8.8.4.4; }; };

// include (master) zones for irresponsible advertisers to block them
include "/var/named/named.advert";

// include manually blocked zones
include "/var/named/named.blocked";


// server log configuration
logging {
	category default { log_default; };
	category resolver { log_resolver; }; 
	category client { log_client; };
	category queries { log_queries; };
	category query-errors { log_query-errors; };
	category lame-servers { log_lame; };

	channel log_default { file "/var/log/named/named.log" versions unlimited size 20m; severity info; print-time yes; print-category yes; };
	channel log_resolver { file "/var/log/named/named-res.log" versions 5 size 20m; severity info; print-time yes; };
	channel log_client { file "/var/log/named/named-client.log" versions 5 size 20m; severity info; print-time yes; };
	channel log_queries { file "/var/log/named/named-queries.log" versions 5 size 20m; severity info; print-time yes; };
	channel log_query-errors { file "/var/log/named/named-query-errors.log" versions 5 size 20m; severity info; print-time yes; };
	channel log_lame { file "/var/log/named/named-lame.log" versions 5 size 5m; severity info; print-time yes; };
};

END
}


download_unix_filters()
{
	cd
	mkdir /var/named
	echo "Download hinting cache"
	wget -O /var/named/named.ca ftp://ftp.rs.internic.net/domain/db.cache
	echo "Download some spam protection"
	wget -O /var/named/null.zone.file http://pgl.yoyo.org/adservers/null.zone.file
	wget -O /var/named/named.advert http://pgl.yoyo.org/adservers/serverlist.php?hostformat=bindconfig\&mimetype=plaintext\&showintro=0

}



configuration_unix_localhost_zone()
{
	cat > /var/named/localhost.zone <<'END'
$TTL    86400 ; 24 hours could have been written as 24h or 1D
$ORIGIN localhost.
; line below expands to: localhost 1D IN SOA localhost root.localhost
@  1D  IN        SOA @  root (
                              2002022401 ; serial
                              3H ; refresh
                              15 ; retry
                              1w ; expire
                              3h ; minimum
                             )
@  1D  IN  NS @
   1D  IN  A  127.0.0.1

END
}



configuration_unix_named_local()
{
	echo "second file, check USRNME goes in properly"

cat > /var/named/named.local << 'END'
$TTL    86400 ; 24 hours could have been written as 24h or 1D
0.0.127.in-addr.arpa. IN SOA $USRNME.local. root.$USRNME.local. (
                           19970331    ; serial number
                           10800       ; refresh every 3 hours
                           10800       ; retry every 3 hours
                           604800      ; expire after a week
                           86400 )     ; TTL of 1 day

0.0.127.in-addr.arpa.   IN  NS  $USRNME.local.
1                       IN  PTR localhost.local.
END
}

configuration_unix_named_block()
{
	echo "extra sites to block go here"

cat > /var/named/named.blocked <<'END'
zone "blockthisresolution.com" { type master; notify no; file "null.zone.file"; };
END
}



configuration_unix_xml_launch_daemon()
{
	echo "Create XML launch daemon"

cat > /Library/LaunchDaemons/org.isc.named.plist <<'END'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Disabled</key>
        <false/>
        <key>EnableTransactions</key>
        <true/>
        <key>Label</key>
        <string>org.isc.named</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/local/sbin/named</string>
                <string>-f</string>
        </array>
        <key>ServiceIPC</key>
        <false/>
</dict>
</plist>
END
}

check_and_test_unix()
{
	echo "Make sure it has permission"
	chown root:wheel /Library/LaunchDaemons/org.isc.named.plist
	chmod 644 /Library/LaunchDaemons/org.isc.named.plist

	echo "Launch BIND it should start automatically on reboot"
	launchctl load -wF /Library/LaunchDaemons/org.isc.named.plist

	exit

	echo "Check everything"
	tail /var/log/named/named.log
	/usr/local/sbin/rndc status

	echo "Check yahoo"
	dig @127.0.0.1 www.yahoo.com a
	dig @127.0.0.1 www.yahoo.com a
	echo "Everything is running, just tell your network about it!"

	echo "Change to your brand new DNS server"
	networksetup -setdnsservers Wi-Fi 127.0.0.1
}

install_extra_dependencies_unix()
{
	echo "Set up git"
	brew install git
	brew link git
	echo "Install pip"
	sudo easy_install pip
	echo "Install Ansible"
	sudo -H pip install pycurl
	brew install ansible
	brew link gdbm
	brew postinstall python
	echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.bash_profile
}





download_and_install_algo_unix()
{
	echo "Install Algo"
	cd
	cd $UrbanEnigma
	unzip algo-master.zip
	cd algo-master
	python -m ensurepip --user
	python -m pip install --user --upgrade virtualenv
	python -m virtualenv env && source env/bin/activate && python -m pip install -U pip && python -m pip install -r requirements.txt
	echo "fill in the fields"
	./algo
	echo "cd to ip directory"
	cd configs 
	echo "find directory and save in variable" 
	$VAR = find . -maxdepth 1 -type d
	cd $VAR



	----------breaking here------------------
	echo "put in your username // use cat to input"
	$myVar=$(tee)
	open $VAR2

	echo "add algo vpn toggle switch to menu bar and refresh"
	defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/vpn.menu"
	killall SystemUIServer -HUP

	echo "log in to vpn server as admin"
	ssh -i configs/algo.pem ubuntu@54.67.101.85        #\"\n"

}

