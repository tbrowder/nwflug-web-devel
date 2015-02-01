# must be 'source'd to use

# note trailing slash on 'web-sites'
FROMDIR="./web-sites/"
TODIR="${RHOST}:web-sites-incoming"

OPTS="-avzr"
# careful:
DEL="--del"
#DEL=""
#                 --exclude="*Resources*" \

function sync_site {
  # arg is a web site name
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
  $FROMDIR/$1/ $TODIR/$1
}

FROMDIR2="./web-sites/Resources/"
TODIR2="${RHOST}:web-sites-incoming/Resources"

function sync_Resources {
  #now send resources
  rsync $OPTS $DEL --exclude="*~" \
                 --exclude="t" \
                 --exclude="tt" \
                 --exclude="ttt" \
  $FROMDIR2 $TODIR2
}