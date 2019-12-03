README-camwang.md

**Urban Enigma**
------------
This is a docker container that will download software for people to
keep their private information private. The goal is to make the process
as simple as possible, so that it is available to everyone - even those
that may be technologically illiterate. Everyone deserves to be safe
and secure.
------------
For this project I am working on the frontend with Megan. The idea is to create a HTML page that loads from the docker container and gathers information to pass to the backend.
The general process of the backend is quite lengthy so the page should be updating the user on the progress, and create engaging "fidget" games on the webpage to keep the user interested.


Stretch #1:
- Begin a simple website using node
- Start looking into and setting up Heroku for emails

Stretch #2:
- Combine work with Megan on frontend and have the webpage implemented in Node.js
- Have the Heroku server running

Stretch #3:
- Created three sample games and had them implemented with Megan
- Changed from using Three.js to Phaser
- Heroku not working how we want for email server rethinking using domain name and redirect with Greg

Final Submission
- Polished the three javascript games which proved to be challenging because I had not worked with the Phaser library before nor did I have much expirence with javascript or html
- Worked with Megan to finish the implementation of the games in an iframe on the website
- Ensure the games worked in the docker container and that it did not disrupt the cookie generation or any other frontend client processes.

Notes:
All goals of Stretch #1 were accomplished. I have a Heroku account and have begun looking at using Heroku for SMTP. I also setup a Node.js webpage that is a basic Hello World! for now. 

Stretch #2 goals shifted slightly but have games working in the frontend webpage, and accomplished integrating with Megan's UI. For email Greg is going to purchase the domain name.
