#!/bin/bash

RHOST=am1

USAGE="Usage: $0 go"

DEFAULT=simple-mixed-ssl
DEFMSG='using simple, mixed-SSL'

if [[ -z $1 ]] ; then
  echo
  echo $USAGE
  echo "       (default: '$DEFAULT')"
  echo "Send local apache2 conf files to the remote server ($RHOST)."
  echo
  exit
fi

PICK=$1;

if [[ $PICK = "go" ]] ; then
  echo "Using $DEFMSG..."
  PICK=$DEFAULT
else
  echo "ERROR input '$PICK'"
  echo $USAGE
  echo
  exit
fi

SUFFIX=$PICK

FROMDIR=./conf
TODIR=httpd.conf.d

FILS="\
httpd.conf \
modules.list \
"

ssh $RHOST "if [ ! -d '$TODIR' ]; then mkdir httpd.conf.d ; fi"

for f in $FILS
do
  DOC=$FROMDIR/$f.$SUFFIX

  # rsync is kind of slow for small payloads
  #echo "rsyncing '$DOC' to remote 'httpd.conf.d/$f'..."
  #rsync -avz $DOC $RHOST:$TODIR/$f

  echo "copying '$DOC' to remote 'httpd.conf.d/$f'..."

  scp -C $DOC $RHOST:$TODIR/$f

done

# remote suid (root) binary executable
SUIDCMD='./on-server-copy-httpdconf go'
ssh $RHOST $SUIDCMD
