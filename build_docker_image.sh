#!/bin/sh


REGION="eu-west-1" 
ACCOUNT_ID="338791806049" 

# docker build -t environment:academy-capstone-winter-2022 . 
docker build -t "${ACCOUNT_ID}".dkr.ecr.$REGION.amazonaws.com/cedric_capstone . 
