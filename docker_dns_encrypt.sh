docker run --name=dnscrypt-server -p 443:443/udp -p 443:443/tcp --net=host \
--ulimit nofile=90000:90000 --restart=unless-stopped \
jedisct1/dnscrypt-server init -N example.com -E 192.168.1.1:443 >> website/data.js

docker start dnscrypt-server >> website/data.js
