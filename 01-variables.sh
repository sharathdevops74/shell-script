#!/bin/bash

DATE=$(date +%F:%H:%M:%S)
LOGDIR= /home/centos/shellscript-logs

SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE-log
USERID=$(id -u)
    if [ $USERID -ne 0 ]
    then 
    echo -e "$R ERROR: Please run this script with root acess $N"
   
    exit 1
    
    fi
    