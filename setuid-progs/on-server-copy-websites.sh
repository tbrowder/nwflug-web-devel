#!/bin/bash

# run as root on the remote server

SRCDIR=./web-sites-incoming
TODIR=/home/web-sites

if [[ -z $1 ]] ; then
  echo "Usage: $0 go"
  echo
  echo "Run as root to copy web site files to '$TODIR'."
  echo
  exit
fi

# allow for multiple users
SITES="\
Resources \
mysite.org \
"

if [[ ! -d "$TODIR" ]] ; then
  mkdir -p $TODIR
fi

OPTS="-avzr"
# careful:
DEL="--del"
#DEL=""

for d in $SITES
do

  # note trailing slash on the src dir"
  FROMDIR="$SRCDIR/$d/"
  TDIR="$TODIR/$d"
  if [[ ! -d "$FROMDIR" ]] ; then
    continue
  fi

  rsync $OPTS $DEL --exclude="*~" --exclude="t" $FROMDIR $TDIR

done

# set perms on data
# completely private
chown -R apache.web-content $TODIR
find $TODIR -type f -exec chmod 644 {} \;
find $TODIR -type d -exec chmod 754 {} \;

