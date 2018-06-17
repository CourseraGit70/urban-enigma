#!/bin/sh
 
USRNME="$1"
echo "Welcome"
echo "Please update Mac OSX to the latest version"
echo "Installing brew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew install caskroom/cask/brew-cask
brew install mas
echo "Install the Xcode app from the App Store"
mas install 497799835
echo "Installing Xcode Tools"
xcode-select --install
echo "Please start Xcode and accept permissions"
echo "Installing wget"
brew install wget
echo "Test tools"
wget 
sudo mkdir /usr/local/bindmac
USRNME=whoami
sudo chown USRNME /usr/local/bindmac
mkdir /usr/local/bindmac/openssl
cd /usr/local/bindmac/openssl
echo "Get latest version of OpenSSL"
wget http://www.openssl.org/source/openssl-1.0.2g.tar.gz
tar zxf openssl-1.0.2g.tar.gz
mkdir install-1.0.2g
echo "Create a link"
ln -s install-1.0.2g install
echo "Build the secure software"
cd openssl-1.0.2g
sudo ./Configure darwin64-x86_64-cc --prefix=/usr/local/bindmac/openssl/install-1.0.2g
sudo make depend
sudo make
sudo make test
sudo make install
echo "Set up BIND9"
mkdir /usr/local/bindmac/bind
cd /usr/local/bindmac/bind
echo "Download the latest version of BIND9"
curl -O -J -L https://www.isc.org/downloads/file/bind-9-10-6/?version=tar-gz
tar zxf bind-9.10.3-P3.tar.gz
cd bind-9.10.3-P3
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


echo "check file input here"
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

mkdir /var/named
echo "Download hinting cache"
wget -O /var/named/named.ca ftp://ftp.rs.internic.net/domain/db.cache
echo "Download some spam protection"
wget -O /var/named/null.zone.file http://pgl.yoyo.org/adservers/null.zone.file
wget -O /var/named/named.advert http://pgl.yoyo.org/adservers/serverlist.php?hostformat=bindconfig\&mimetype=plaintext\&showintro=0


echo "check file input here"

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

echo "second file, check USRNME goes in properly"

cat > /var/named/named.local << END
$TTL    86400 ; 24 hours could have been written as 24h or 1D
0.0.127.in-addr.arpa. IN SOA USRNME.local. root.USRNME.local. (
                           19970331    ; serial number
                           10800       ; refresh every 3 hours
                           10800       ; retry every 3 hours
                           604800      ; expire after a week
                           86400 )     ; TTL of 1 day

0.0.127.in-addr.arpa.   IN  NS  USRNME.local.
1                       IN  PTR localhost.local.
END

echo "extra sites to block go here"

cat > /var/named/named.blocked <<'END'
zone "blockthisresolution.com" { type master; notify no; file "null.zone.file"; };
END

mkdir /var/log/named

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


echo "test this thoroughly"
echo "Set up Streisand"
mkdir -p ~/Library/Python/2.7/lib/python/site-packages
echo '/usr/local/lib/python2.7/site-packages' > ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
sudo chown -R $(whoami) /usr/local/lib/python2.7/site-packages
sudo chown -R $(whoami):admin  /usr/local
ssh-keygen
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

echo "Hook up to EC2 with Algo"
sudo pip install boto
sudo pip install --ignore-installed six boto3
echo "boto is for steisand try without"






echo "dl and install everything"
curl -O -J -L https://github.com/trailofbits/algo/archive/master.zip
cd
cd Downloads
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
echo "put in your username // use cat to input"
$myVar=$(tee)
open $VAR2

echo "add algo vpn toggle switch to menu bar and refresh"
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/vpn.menu"
killall SystemUIServer -HUP

echo "log in to vpn server as admin"
ssh -i configs/algo.pem ubuntu@54.67.101.85        #\"\n"



echo "dns server install on ubuntu vpn server goes here"






echo "deploy additional vpns"
cd
curl -O -J -L https://github.com/trailofbits/algo/archive/master.zip
sudo apt install unzip
unzip algo-master.zip
cd algo-master
echo "install core dependencies"
sudo apt-get update && sudo apt-get install \
    build-essential \
    libssl-dev \
    libffi-dev \
    python-dev \
    python-pip \
    python-setuptools \
    python-virtualenv -y
python -m virtualenv env && source env/bin/activate && python -m pip install -U pip && python -m pip install -r requirements.txt

echo "need to use cat to insert username into right place"
sudo apt install gedit
gedit config.cfg
./algo
echo "your vpn server just deployed a vpn server"
