#!/bin/sh

echo 'Script started'
sh 'aws s3 ls'
sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY'
sh 'aws configure set aws_secret_access_key $AWS_SECRET_KEY'
//  sh 'aws configure set region us-east-1' 
sh 'aws s3 cp bermtec-0.0.1.zip s3://bermtec28/lambdatest'
echo "Stage 2 Yes"