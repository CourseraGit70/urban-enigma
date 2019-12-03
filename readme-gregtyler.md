Submiision 2: I wrote everything in the urban_enigma_v2 folder and the docker.sh script.
I also created an AWS server and started the openvpn server deployment as well as the DNS server deployment.

Submission 3: Created the docker vpn deployment scripts in docker_server.sh and docker client set up files. Starting investigating DNS in docker. Did Trello

Final Submission: Created the docker.sh script, docker_client_set_up.sh script, docker_server.sh script, docker_dns_encrypt.sh script, and docker_mail_server.sh script. Organized meetings, directed GUI development and submissions, directed and edited the poster submission.

This involved creating an openvpn server within docker, finding the configuration key, creating an openvpn client within a seperate docker container, and transferring the configuration to the client container. Once the VPN server was functioning we tested it on jacob's computer and fixed the issues regarding the directory.

The next step was trying to get dns servers running, but docker is not well documented enough for this yet. Instead I found DNSCRYPT, which encrypts dns queries, creating a similar effect. This will run in docker, so I made another container running DNSCRYPT. IRedMail had a similar issue, so I found a largely preconfigured mail server that will run within docker. It still requires external domain routing and information, so it doesn't completely run, but if you had that it's only a few steps to complete the process.

With all the pieces in place I looked at merging docker files, which doesn't work for this, and found docker-compose, that lets containers use eachothers services. I created a customer docker-compose.yml file that enabled the dns and vpn server in the mail server container, and all the pieces now work together.

The last step was to link to the GUI, so all console output was diverted to the data.js file that the website uses to populate its notification window.
