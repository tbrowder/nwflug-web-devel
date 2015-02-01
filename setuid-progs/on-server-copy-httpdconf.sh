#!/bin/bash

# run as root on the remote server

FROMDIR=httpd.conf.d
TODIR=/usr/local/apache2/conf

if [[ -z $1 ]] ; then
  echo "Usage: $0 go"
  echo
  echo "Run as root to copy conf files to '$TODIR'."
  echo
  exit
fi

# run as root on the remote server
FROMDIR=httpd.conf.d
/bin/cp -f $FROMDIR/* $TODIR

# set perms on data
# completely private
chown -R root.root $TODIR
find $TODIR -type f -exec chmod 644 {} \;
find $TODIR -type d -exec chmod 744 {} \;
