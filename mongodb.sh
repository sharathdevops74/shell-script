#!/bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: please run the script with root access $N"
    exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ]
then 
    echo -e "$2....$R FAILURE  $N"
    exit 1
else 
    echo -e "$2....$G SUccess $N"

fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGFILE
VALIDATE $? "copied mongodb repo into yum.repos.d"

yum install mongodb-org -y   &>>$LOGFILE
VALIDATE $? "installing mogodb"

systemctl enable mongod   &>>$LOGFILE
VALIDATE $? "enable mongodb"

systemctl start mongod  &>>$LOGFILE
VALIDATE $? "Start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>>LOGFILE
VALIDATE $? " edited mongodb conf"

systemctl restart mongod    &>>$LOGFILE
VALIDATE $? "restarting mongodb"
