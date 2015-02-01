#!/bin/bash

# remote host (uses 3rd party setup)
RHOST=am1

USAGE="Usage: $0 all | gen | gen-only | <site name> "
if [[ -z $1 ]] ; then
  echo
  echo $USAGE
  echo "Send '${RHOST}' web-site files to the remote server."
  echo
  exit
fi

# sites with generated pages
GENSITES="\
mysite.org \
"
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

# need some functions
source web-site-funcs.bash

#========= sync GEN sites ================
if [[ $1 == "gen" || $1 == "all" ]] ; then
  for w in $GENSITES ; do
    sync_site $w
  done

  sync_Resources

  # cleanup auto-generated files?
  # no, keep manual for now
  #./delete-auto-gen-files.pl go

  #echo "Now go to the remote host ($RHOST) and, as root, execute"
  #echo "  ./cp-web-site-files.sh go"
    #echo "Then, still as root, execute"
  #echo "  apachectl graceful"

  # copying web sites
  ssh $RHOST './copytbrowdewebsites go'
  exit
fi
#========= end sync ALL sites ================

#========= sync ONE site ================
for w in $GENSITES ; do
  if [[ $w == $1 ]] ; then
    echo "Synching known site '$w'..."
    #echo "Exiting after commands..."
    sync_site $w
    ssh $RHOST './copytbrowdewebsites go'
    exit
  fi
done

echo "WARNING:  Site '$1' is unknown."
