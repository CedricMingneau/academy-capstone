#!/bin/bash 
set -euxo pipefail 

#ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep aws_access_key | cut -d "=" -f 2 | awk '{$1=$1};1') 
#SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep aws_secret_access_key | cut -d "=" -f 2 | awk '{$1=$1};1') 
REGION="eu-west-1" 
#  DEFAULT_REGION="eu-west-1" 
ACCOUNT_ID="338791806049" 

aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${ACCOUNT_ID}".dkr.ecr."${REGION}".amazonaws.com 
#aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com 
docker push "${ACCOUNT_ID}".dkr.ecr."${REGION}".amazonaws.com/cedric_capstone:academy-capstone-winter-2022