docker pull ubuntu
docker cp ue-server:/testclient.ovpn C:/Users/Jake/DataCom/Urban-Enigma/testclient.ovpn
docker cp C:/Users/Jake/DataCom/Urban-Enigma/testclient.ovpn ue-client:/etc/openvpn/client
docker run --name ue-client -i -t ubuntu /bin/bash
apt-get update
apt-get upgrade
apt-get install openvpn
y
openvpn –config testclient.ovpn

on the server run the docker.sh file and or server config

cmd /k
