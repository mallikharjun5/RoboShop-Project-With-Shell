#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-090908868bc302a71"      # REPLACE WITH YOUR SECURITY GROUP ID

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids
    $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances
    [0].InstanceId' --output text)

    # GET PRIVATE IP
    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].
        PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].
        PublicIpAddress' --output text)
    fi

    echo "$instance: $IP"

done