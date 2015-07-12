# gluon-set-geo

## Idea

You have an freifunk access point, that should be used in a mobile scenario. Until now you had two possibilities: You can leave out setting geo-coordinates or you commit the coordinates with an ssh connection every time you change your location. Having in mind that you don't have your Laptop with you all the time and changing the settings using an ssh client on your smartphone is very annoying, I wrote this little lua-script. Since it uses simple **HTTP-requests**, you can change the location very easy. I added a little html-frontend made with JQuery mobile (The functionality is written in plain JS to ensure the functionality without connection to internet).

## Configuration

You need an ssh-connection to the gluon-node.

First you need to think about a save password. The password has to be set in the location.lua. If you want to use the push.sh script, which automatically pushes the files via ssh to the right path in gluon, you need to set the connection to the server in it.

## Tools

**Shell-Client:**

I also wrote a simple shell example client named send.sh. USAGE: ```./send.sh $LAT $LON```

**The HTML-frontend uses:**

* SHA512 - https://github.com/emn178/js-sha512
* UI - https://jquerymobile.com/
* GPS/Location - Browser Position API

## How it works

We are using a plain *("unencrypted")* HTTP connection. To perform a secure password validation the serverside-script creates a random salt.txt (```/lib/gluon/status-page/www/salt.txt```) which is e.g. reachable over ```http://[...]/salt.txt```. The location request is a HTTP POST with ```"$LAT,$LON,$HASH"``` to ```http://[...]/cgi-bin/set_location```. The $HASH is an SHA512 of ```"$LAT$LON$PASSWORD$SALT"```. The salt.txt is created automatically, if it does not exist. When there was a successful request, the server creates a new salt.
