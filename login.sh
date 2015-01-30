#!/bin/bash

USAGE="Usage: $0 go"

KEYFILE=../amazon1.pem
SERVER='ubuntu@54.191.61.9'

if [[ -z $1 ]] ; then
  echo
  echo $USAGE
  echo
  echo "Login to the Amazon server: '$SERVER'."
  echo "Uses key file '$KEYFILE'."
  exit
fi

ssh -i $KEYFILE $SERVER
