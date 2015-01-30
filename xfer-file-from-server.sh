#!/bin/bash

USAGE="Usage: $0 <files and dirs>"

KEYFILE=../amazon1.pem
SERVER='ubuntu@54.191.61.9'

if [[ -z $1 ]] ; then
  echo
  echo $USAGE
  echo
  echo "Transfers <single files or dirs> from the Amazon server: '$SERVER'."
  echo "Uses key file '$KEYFILE'."
  exit
fi

#scp -r -C -i $KEYFILE $@ ${SERVER}:

scp -i $KEYFILE ${SERVER}:$@ .
