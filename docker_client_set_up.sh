docker pull ubuntu >> website/data.js
docker cp ue-server:/testclient.ovpn C:/Users/Jake/DataCom/Urban-Enigma/testclient.ovpn >> website/data.js
docker cp C:/Users/Jake/DataCom/Urban-Enigma/testclient.ovpn ue-client:/etc/openvpn/client >> website/data.js
docker run --name ue-client -i -t ubuntu /bin/bash >> website/data.js
apt-get update >> website/data.js
apt-get upgrade >> website/data.js
apt-get install openvpn >> website/data.js
y >> website/data.js
openvpn –config testclient.ovpn >> website/data.js

on the server run the docker.sh file and or server config

cmd /k
