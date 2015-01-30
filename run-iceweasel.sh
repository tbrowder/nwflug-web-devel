#!/bin/bash

DOMAIN=mysite.org
CWD=`pwd`
DIR=$CWD/web-sites
FIL=$DIR/$DOMAIN/public/index.html

# execute
/usr/bin/iceweasel file://$FIL
