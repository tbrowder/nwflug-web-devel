#!/bin/bash

# remote host (uses 3rd party setup)
RHOST=am1

USAGE="Usage: $0 go | gen | gen-only | cp-only"
if [[ -z $1 ]] ; then
  echo
  echo $USAGE
  echo "Send '${RHOST}' web-site files to the remote server."
  echo
  exit
fi

GENSITES="\
mysite.org \
"

if [[ $1 == "cp-only" ]] ; then
  # copying web sites on the server
  ssh -v ${RHOST} "./copywebsites go"
  exit
fi

# first generate pages if requested
if [[ $1 == "gen" || $1 == "gen-only" ]] ; then
  for w in $GENSITES ; do
    echo "Working site '$w'..."
    (cd ./web-sites/$w/public ; ./gen-pages.pl)
  done

  if [[ $1 == "gen-only" ]] ; then
    echo "Early exit after web site generation."
    exit
  fi
fi

# note trailing slash on 'web-sites"
FROMDIR="./web-sites/"
TODIR="${RHOST}:web-sites-incoming"

OPTS="-avzr"
# careful:
DEL="--del"
#DEL=""
#                 --exclude="*Resources*" \
rsync $OPTS $DEL \
  --exclude="*~" \
  --exclude="*.template" \
  --exclude="*.content" \
  --exclude="*.source" \
  --exclude="*.pm" \
  --exclude="*.orig" \
  --exclude="gen-pages.pl" \
  --exclude="t" \
  --exclude="tt" \
  --exclude="ttt" \
  --exclude="tmp-pics" \
  $FROMDIR $TODIR

#now send resources
FROMDIR2="./web-sites/Resources/"
TODIR2="${RHOST}:web-sites-incoming/Resources"
rsync $OPTS $DEL --exclude="*~" \
                 --exclude="t" \
                 --exclude="tt" \
                 --exclude="ttt" \
  $FROMDIR2 $TODIR2

# copy web sites on the server
ssh -v ${RHOST} './copywebsites go'
