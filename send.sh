#!/bin/sh
PASSWORD=
IP6=
SALT=$(curl -g http://$IP6/salt.txt 2>/dev/null)
HASH=$(echo -n "$1$2$PASSWORD$SALT" | sha512sum | head -c 128)

echo -= REQUEST =-
echo salt=$SALT
echo lan=$1 lat=$2 hash=$HASH

echo
echo -= ANSWER =- 
echo -n "$1,$2,$HASH" | curl -g -X POST -d @- http://$IP6/cgi-bin/set_location
