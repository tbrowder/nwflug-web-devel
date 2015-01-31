#!/bin/bash

#$CMD $URL/httpd-2.4.12.tar.bz2.sha1
#https://dl.dropboxusercontent.com/u/18447611/CompuTech/CompuTech-2015/src/httpd-2.4.12.tar.bz2.sha1

URL=https://dl.dropboxusercontent.com/u/18447611/CompuTech/CompuTech-2015/src
CMD='wget'

FILS="\
apr-1.5.1.tar.bz2 \
apr-util-1.5.4.tar.bz2 \
httpd-2.4.12.tar.bz2 \
openssl-1.0.2.tar.gz \
pcre2-10.00.tar.bz2 \
"

for f in $FILS ; do
  $CMD $URL/$f
done
