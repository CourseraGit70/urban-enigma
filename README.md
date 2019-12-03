#Urban-Enigma
------------
This is a docker container that will download software for people to
keep their private information private. The goal is to make the process
as simple as possible, so that it is available to everyone - even those
that may be technologically illiterate. Everyone deserves to be safe
and secure.
------------

To run:
Execute docker_server.sh. 
Execute docker_client_setup.sh.  
You will need to manually update the directories. 
Execute docker_dns_encrypt.sh.
Execute lines 1-8 in docker_mail_server.sh. Replace the docker-compose.yml file in the newly created directory with the one in the github repo.
Execute line 16-18. (mail server is not fully functional however)
