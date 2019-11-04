docker run -t -i ubuntu /bin/bash
apt update
apt upgrade
apt install git
y
##git clone https://github.com/CourseraGit70/urban-enigma.git
##login to git
##cd urban-enigma/
##cd urban_enigma_v2/



docker pull sameersbn/bind:9.11.3-20190706


172.90.122.198


git clone https://github.com/kylemanna/docker-openvpn.git
cd docker-openvpn/
docker build -t myownvpn .
cd ..
mkdir vpn-data
docker run -v $PWD/vpn-data:/etc/openvpn --rm myownvpn ovpn_genconfig -u udp://IP_ADDRESS:3000
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it myownvpn ovpn_initpki
docker run -v $PWD/vpn-data:/etc/openvpn -d -p 3000:1194/udp --cap-add=NET_ADMIN myownvpn
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it myownvpn easyrsa build-client-full user1 nopass
docker run -v $PWD/vpn-data:/etc/openvpn --rm myownvpn ovpn_getclient user1 > user1.ovpn
