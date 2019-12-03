docker pull tvial/docker-mailserver:latest >> website/data.js
curl -o setup.sh https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh; chmod a+x ./setup.sh >> website/data.js

curl -o docker-compose.yml https://raw.githubusercontent.com/tomav/docker-mailserver/master/docker-compose.yml.dist >> website/data.js

curl -o .env https://raw.githubusercontent.com/tomav/docker-mailserver/master/.env.dist >> website/data.js

curl -o env-mailserver https://raw.githubusercontent.com/tomav/docker-mailserver/master/env-mailserver.dist >> website/data.js


#insert the updated docker-compose.yml file into the directory created




docker-compose up -d mail >> website/data.js
./setup.sh email add <user@domain> [<password>] >> website/data.js
./setup.sh config dkim >> website/data.js

docker-compose down >> website/data.js
docker pull tvial/docker-mailserver:latest >> website/data.js
docker-compose up -d mail >> website/data.js


