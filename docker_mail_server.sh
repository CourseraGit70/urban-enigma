docker pull tvial/docker-mailserver:latest
curl -o setup.sh https://raw.githubusercontent.com/tomav/docker-mailserver/master/setup.sh; chmod a+x ./setup.sh

curl -o docker-compose.yml https://raw.githubusercontent.com/tomav/docker-mailserver/master/docker-compose.yml.dist

curl -o .env https://raw.githubusercontent.com/tomav/docker-mailserver/master/.env.dist

curl -o env-mailserver https://raw.githubusercontent.com/tomav/docker-mailserver/master/env-mailserver.dist


#insert the updated docker-compose.yml file into the directory created




docker-compose up -d mail
./setup.sh email add <user@domain> [<password>]
./setup.sh config dkim

docker-compose down
docker pull tvial/docker-mailserver:latest
docker-compose up -d mail


