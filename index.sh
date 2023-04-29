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
else
    echo -e "\nLets Start Our Damn Journey\n"
    tableOptions=("Create Table" "List Tables" "Drop Table" "Insert Table" "Select From Table" "Select Entire Table" "Update Table" "Delete From Table" "Delete Entire Table" )
    select opt in "${tableOptions[@]}"
    do
    case $opt in
        "Create Table")
            read -p "You choosed to create Table, Enter Table name: " tableName
            if [ "$(find . -type f -name "${tableName}")" ]; then
                echo "Table already exists"
            else
                touch $tableName
                read -p "Enter Number Of Fields: " tableFields
                fieldType=("int" "str")
                fieldKey=("pk" "notPK")
                for (( i=1; i<=$tableFields; i++ ))
                    do
                        if [ $i -eq 1 ];then
                            read -p "Enter Field Name # ${i}: " fieldName
                            echo  "${fieldName}:" >> ./${tableName}
                            echo "Enter Field Type # ${i}: "
                            while true;
                                    do 
                            select opt in "${fieldType[@]}"
                                do
                                
                                        case $opt in
                                            "int")
                                            echo  "int:" >> ./${tableName}
                                            break
                                            ;;
                                            *)
                                            echo "Cant Be Str"
                                            esac
                                    done
                                
                                break
                                done                            
                            echo "Enter Field Key # ${i}: "
                            select opt in "${fieldKey[@]}"
                                do
                                case $opt in
                                    "pk")
                                    echo  "pk:" >> ./${tableName}
                                    ;;
                                    "notPK")
                                    echo  "notPK:" >> ./${tableName}
                                esac
                                break
                                done
                        else
                            read -p "Enter Field Name # ${i}: " fieldName
                            sed -i "1s/.*/&${fieldName}:/" ./${tableName}
                            echo "Enter Field Type # ${i}: " 
                            select opt in "${fieldType[@]}"
                                do
                                case $opt in
                                    "int")
                                    sed -i "2s/.*/&int:/" ./${tableName}
                                    ;;
                                    "str")
                                    sed -i "2s/.*/&str:/" ./${tableName}
                                    ;;
                                    *) echo "invalid option $REPLY";;
                                esac
                                break
                                done
                            echo "Enter Field Key # ${i}: "
                            select opt in "${fieldKey[@]}"
                                do
                                case $opt in
                                    "pk")
                                    sed -i "3s/.*/&pk:/" ./${tableName}
                                    ;;
                                    "notPK")
                                    sed -i "3s/.*/&notPK:/" ./${tableName}
                                    ;;
                                    *) echo "invalid option $REPLY";;
                                esac
                                break
                                done          
            fi
                    done
                        fi            
            ;;
        "List Tables")
            ls -l .
            ;;
        "Drop Table")
            read -p "You choosed to drop database, Enter database name: " tableNameDrop
            rm ./${tableNameDrop}
            ;;
        "Insert Table")
        attributes=()
        #attributes=("id" "name" "age")
            read -p "You choosed to insert into database, Enter table name: " tableNameInsert
            tableFields=$(head -n 1 ${tableNameInsert} | tr ':' ' ' | wc -w)
           # tableFields= `awk -F: '{print NF}' ${tableNameInsert}`
            echo $tableFields
            for (( i=1; i<=$tableFields; i++ ))
                    do
                        attr=$(sed -n 1p ${tableNameInsert} | cut -d':' -f${i})
                        attributes+=("${attr}")
                    done
            echo "A"
            echo "${attributes[@]}"                    
            echo "Z"
            echo "Enter Column Number To Insert Into: " 
            #echo -e "\n" >> ./${tableNameInsert}
             echo -e -n "\n" >> ./${tableNameInsert}
            for(( i=0; i<$tableFields; i++ ))
                do
                select opt in "${attributes[@]}"
                do
                    case $opt in
                    "${attributes[i]}")
                        if [ $i -eq 0 ]; then
                        while true; do
                            read -p "Enter ${attributes[i]} Value: " value
                            if [[ $value =~ ^[0-9]+$ ]]; then

                                recordExist=$(awk -F: '{print $1}' $tableNameInsert | grep $value)
                                if [ "$recordExist" ] ; then
                                    echo "This Primary Key Already Exist"
                                else 
                                    echo -n "${value}:" >> ./${tableNameInsert}
                                    break
                                fi 
                            else
                                echo "Your Id Must Have Only Digits"
                            fi
                        done                      
                        else      
                        while true; do

                            read -p "Enter ${attributes[i]} Value: " value
                            valueType=$(sed -n 2p ${tableNameInsert} | cut -d':' -f$((i+1)))
                            echo $valueType
                            if [ "$valueType" == "int" ];then
                                    if [[ $value =~ ^[0-9]+$ ]]; then
                                        echo -n "${value}:" >> ./${tableNameInsert}
                                        break
                                    else 
                                        echo "Invalid FieldType"
                                    fi
                            else 
                                    if [[ $value =~ ^[a-zA-Z]+$ ]]; then
                                        echo -n "${value}:" >> ./${tableNameInsert}
                                        break
                                    else 
                                        echo -n "Invalid FieldType"
                                    fi
                                   
                            fi
                        done
                       #echo -n "${value}:" >> ./${tableNameInsert}
                        fi
                        break
                        
                    esac
                done

                done
#                echo -e -E "\n" >> ./${tableNameInsert}

                #echo -e "\n" >> ./${tableNameInsert}
                echo "You have Inserted New Record =) "
            ;;
        "Select From Table")       
            read -p "You choosed to Select From Table, Enter Table name: " tableName
            read -p "Enter Id To Search By: " id
            #awk '{print $0}' $tableName
            head -n 1 $tableName
            awk -F: '{print $1}' $tableName | grep $id           
            ;;
        "Select Entire Table")        
            read -p "You choosed to Select Entire Table, Enter Table name: " tableName
           # tail -n +4 $tableName
            awk '{print $0}' $tableName        
            ;;
        "Update Table")
            read -p "You choosed to Update Table, Enter Table name: " tableNameUpdate
            while true; do
                
            read -p "Enter Id To Search By & Update: " id
            record=$(awk -F: '{print $0}' $tableNameUpdate | grep $id)
            if ! [ "$record" ] ; then
                    echo "This Record Doesnt Exist"
            else 

                

                echo " The Record is ${record}"
                sed -i "/$id/d" $tableNameUpdate
                IFS=':' read -ra recordList <<< "$record"
                for i in "${recordList[@]}"; do
                    echo "$i"
                done
                echo $record
                attributes=()
                tableFields=$(head -n 1 ${tableNameUpdate} | tr ':' ' ' | wc -w)
                echo $tableFields
                for (( i=2; i<=$tableFields; i++ ))
                        do
                            attr=$(sed -n 1p ${tableNameUpdate} | cut -d':' -f${i})
                            attributes+=("${attr}")
                        done
                echo "${attributes[@]}"             
                echo "Enter Column Number To Update: " 
                for(( i=0; i<$tableFields-1; i++ ))
                    do
                    select opt in "${attributes[@]}"
                    do
                        case $opt in
                        "${attributes[i]}")
                        read -p "Enter ${attributes[i]} Value: " value
                        #echo "New Value Of ${attributes[i]} is ${value}"
                        recordList[i+1]=$value
                        echo ${recordList[i+1]}
                        #echo -n "${value}:" >> ./${tableNameInsert}
                            break
                            ;;
                        *) echo "Invalid option" ;;
                        esac
                    done
                    done
                    echo "${recordList[@]}"    
                    recordStr=$(echo "${recordList[*]}" | tr ' ' ':')
                    echo $recordStr
                    echo "${recordStr}" >> ./${tableNameUpdate}           
                    echo "You have Updated Your Record =) "       
                    break
            fi
            done
            ;;
        "Delete From Table")
            read -p "You choosed to Delete From Table, Enter Table name: " tableName
            read -p "Enter Id To Search By & Delete: " id
            sed -i "/$id/d" $tableName
            break
            ;;
        "Delete Entire Table")
            read -p "You choosed to Delete Entire Table, Enter Table name: " tableName
            head -n 3 $tableName > temp && mv temp $tableName
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac    
done 
fi
