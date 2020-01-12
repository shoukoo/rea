#!/bin/bash

set -e

# install terraform 
if ! [ -x "$(command -v terraform)" ]; then
  echo "Run 'brew install terraform' to install terraform"
  exit 1
fi

if [ -z $AWS_ACCESS_KEY_ID ]; then
  echo "Please export AWS_ACCESS_KEY_ID"
  exit 1
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  echo "Please export AWS_SECRET_ACCESS_KEY"
  exit 1
fi



