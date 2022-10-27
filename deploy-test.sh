#!/bin/sh

echo 'Script started'
sh 'aws s3 ls'
echo $1
sh 'aws configure set aws_access_key_id $1'
sh 'aws configure set aws_secret_access_key $2'
//  sh 'aws configure set region us-east-1' 
sh 'aws s3 cp bermtec-0.0.1.zip s3://savvywork/lambda-test/'
echo "Stage 2 Yes"