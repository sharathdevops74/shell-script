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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash   &>>$LOGFILE
VALIDATE $? "settingup NPM source"

yum install nodejs -y   &>>$LOGFILE
VALIDATE $? "installing nodejs"

useradd roboshop   &>>$LOGFILE
mkdir /app       &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip   &>>$LOGFILE
VALIDATE $? "downloading catalogue artifact"

cd /app    &>>$LOGFILE
VALIDATE $? "moving into app directory"

unzip /tmp/catalogue.zip    &>>$LOGFILE
VALIDATE $? "unziping catalogue"

cd /app   &>>$LOGFILE
npm install &>>$LOGFILE
VALIDATE $? "installing dependencies"

cp /home/centos/shell-script/catalogue.service /etc/systemd/system/catalogue.service  &>>$LOGFILE
VALIDATE $? "copying catalogue.service"

systemctl daemon-reload 
VALIDATE $? " daemon-reloaded"

systemctl enable catalogue
VALIDATE $? "enabling catalogue"

systemctl start catalogue
VALIDATE $? "starting catalogue"

cp /home/centos/shell-script/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? " copying mongo repo"

yum install mongodb-org-shell -y
VALIDATE $? " installing mongo client"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js
VALIDATE $? "loading catalogue data into mongodb"