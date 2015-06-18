#!/bin/sh

# set the ssh name/connection here
ROUTER=

scp location.lua $ROUTER:/lib/gluon/status-page/www/cgi-bin/set_location
ssh $ROUTER "chmod +x /lib/gluon/status-page/www/cgi-bin/set_location"

# comment this lines out, if you don't want to have the graphical html-interface
scp set_location.html $ROUTER:/lib/gluon/status-page/www
scp sha512.js $ROUTER:/lib/gluon/status-page/www
