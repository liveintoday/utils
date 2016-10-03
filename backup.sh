#! /bin/bash
set -e

BACKUP_DIR="/home/deepdu/backup"
TIME=$(date +"%Y-%m-%d_%H:%M:%S")
PWD=$(pwd)

function getTimeStr()
{
    name=$(basename $1)
    timeStr=$(echo $name | awk -F "_" '{
    if(NF>2){
        print $(NF-1) " " $(NF);
    }else{
        print "NULL";
    }
    }')

    if [ "$timeStr" = "NULL" ];then
        #timeStr=$(date +"%Y-%m-%d %H:%M:%S")
        timeStr="2000-01-01 00:00:00"
    fi

    #For debug
    #echo $timeStr "--->" $(date -d "$timeStr" +%s)
    
    echo $(date -d "$timeStr" +%s)
}


function cleanOld()
{
    
    recent=0
    recentFile=""
    for file in $BACKUP_DIR/*
    do
        if [[ $file =~ $1 ]];then
            time=$(getTimeStr $file)
            echo $file "-->" $time
            if [ $time -gt $recent ];then
                recent=$time
                recentFile=$file
            fi
        fi
    done
    
    echo "Recent version of $1 is $BACKUP_DIR/$recentFile"

    for file in $BACKUP_DIR/*
    do
        if [[ $file =~ $1 ]] && [ ! $file = $recentFile ];then
            echo "Clean old backup file : $file..."
            rm -rf $file
        fi
    done    
}



if [ $# -lt 1 ];then
    echo "============================================================="
    echo "Uage   : back up file or folder into default backup directory"
    echo "         backup.sh file/direcotry [suffix]"
    echo "Author : dujunlong[deepdu@126.com]"
    echo "Version: v0.1 [2016/10/3]"
    echo "============================================================="
    exit -1
fi

v=$1
TIME_SUFFIX=False
if [ $# -gt 1 ];then

    #if [ $2 = "True" ] || [ $2 = "False" ];then
    #    TIME_SUFFIX=$2
    #fi
    
    if [ $2 = "suffix" ];then
        TIME_SUFFIX=True
    fi

    if [ $2 = "clean" ];then
        cleanOld $v 
        exit 0
    fi
fi

if [ ! -d $BACKUP_DIR ];then
    echo "Direcotry for backup doesn't exist,just creat one..."
    mkdir $BACKUP_DIR
fi


echo "==================================="
echo "--Current directory: $PWD" 
echo "--tims: $TIME"

if [ -f $v ];then
    echo "Backup file: $v..."
    FILE_NAME=$(basename $v)
    
    if [ $TIME_SUFFIX = "Ture" ];then
        echo "Backup with time suffix!"
        cp $v $BACKUP_DIR/${FILE_NAME}_$TIME
    else
        echo "Backup without time suffix!"
        cp -f $v $BACKUP_DIR/
    fi

elif [ -d $v ];then
    if [ $v = "." ];then
        v=$(pwd)
    fi
    echo "Backup directory: $v..."
    
    #提取路径中的最后一级目录名!-->直接使用basename
    DIR_NAME=$(echo $v|awk -F "/" '{
    if($NF == ""){
        print $(NF-1);
    }else{
        print $NF;
    }
    }')

    if [ $TIME_SUFFIX = "True" ];then
        echo "Backup with time suffix!"
        cp -rf $v $BACKUP_DIR/${DIR_NAME}_$TIME
    else
        echo "Backup without time suffix!"
        cp -rf $v $BACKUP_DIR/
    fi

else
    echo "$v doesn't exist!"
    echo "==================================="
    exit -1
fi
echo "Finished backup $v!"
echo "==================================="
