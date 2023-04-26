#!/bin/bash
pwdBefore=$PWD
options=("Create Database" "List Database" "Drop Database" "Connect Database")
select opt in "${options[@]}"
do
    case $opt in
        "Create Database")
            read -p "You choosed to create database, Enter database name: " dbName
            if [ "$(find . -type d -name "${dbName}")" ]; then
                echo "Database already exists"
            else
                mkdir $dbName
            fi            
            ;;
        "List Database")
            ls -l .
            ;;
        "Drop Database")
            read -p "You choosed to drop database, Enter database name: " dbNameDrop
            rm -r ./${dbNameDrop}
            ;;
        "Connect Database")
            read -p "You choosed to connect database, Enter database name: " dbNameConnect
            if [ "$(find . -type d -name "${dbNameConnect}")" ]; then
                cd $dbNameConnect
            else 
                echo "Database not found 404"
            fi
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac    
done 
pwdAfter=$PWD
echo "We were in $pwdBefore"
echo "We are in $pwdAfter"
if [ $pwdBefore == $pwdAfter ]; then
    echo -e "\nGood Bye =)\n"