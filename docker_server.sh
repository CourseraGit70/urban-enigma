git clone https://github.com/kylemanna/docker-openvpn.git >> website/data.js
cd docker-openvpn/ >> website/data.js
docker build -t myownvpn . >> website/data.js
cd .. >> website/data.js
mkdir vpn-data >> website/data.js
docker run -v $PWD/vpn-data:/etc/openvpn --rm myownvpn ovpn_genconfig -u udp://IP_ADDRESS:3000 >> website/data.js
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it myownvpn ovpn_initpki >> website/data.js
docker run -v $PWD/vpn-data:/etc/openvpn -d -p 3000:1194/udp --cap-add=NET_ADMIN myownvpn >> website/data.js
docker run -v $PWD/vpn-data:/etc/openvpn --rm -it myownvpn easyrsa build-client-full user1 nopass >> website/data.js
docker run -v $PWD/vpn-data:/etc/openvpn --rm myownvpn ovpn_getclient user1 > user1.ovpn >> website/data.js

docker create --name ue-server myownvpn >> website/data.js
