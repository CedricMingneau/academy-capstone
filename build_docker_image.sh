#!/bin/sh


AWS_ACCESS_KEY = cat ~/.aws/credentials | grep aws_access_key | cut -d "=" -f 2 | awk '{$1=$1};1'
AWS_SECRET_ACCESS_KEY = cat ~/.aws/credentials | grep aws_secret_access_key | cut -d "=" -f 2 | awk '{$1=$1};1'

docker build . --build-arg AWS_ACCESS_KEY=$AWS_ACCESS_KEY --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY