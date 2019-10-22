#!/bin/sh

download_bind9_linux()
{
	echo "dns server install on ubuntu vpn server goes here"
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install bind9 bind9utils bind9-doc
	sudo apt-get install systemd
}


configuration_linux_etc_hosts()
{
	cat > /etc/hosts << 'END'
	127.0.1.1 ip-10-0-0-50

END

}

configuration_linux_named_config_options()
{
	cat > /named.conf.options << 'END'
		acl goodclients {
    	192.0.2.0/24;
    	localhost;
    	localnets;
		};

		options {
        directory "/var/cache/bind";

        recursion yes;
        allow-query { goodclients; };

        dnssec-validation auto;

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
		};
END
sudo /etc/init.d/bind9 restart

}


vpn_deploy_loop()
{
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
}

i_red_mail_deploy()
{

	BindName=bind-9.10.3-P3.tar.gz
	BindFile="${UrbanEnigma}/${BindName}"
	echo "$BindFile"


	ssh -i "urbanenigma.pem" ubuntu@35.166.203.87


sudo apt-get install bzip2
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install update-manager-core
sudo do-release-upgrade


	HostName=$(hostname -f)
	NewHostName=gtrresearch.com
	cat > /etc/hostname << 'END'
	"mx"
END

	cat > /etc/hosts << 'END'
"# Part of file: /etc/hosts
127.0.0.1   mx.example.com mx localhost localhost.localdomain"
END


sudo reboot
ssh -i "urbanenigma.pem" ubuntu@35.166.203.87
wget https://bitbucket.org/zhb/iredmail/downloads/iRedMail-0.9.8.tar.bz2
IRedMailCompFile=$(ls)
tar xjf $IRedMailCompFile
cd $(ls -d */|head -n 1)
# default password xxx555xxx
# mail domain admin 112233bb
#use expect
}
