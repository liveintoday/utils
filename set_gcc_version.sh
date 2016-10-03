#! /bin/bash

set -e
#set -x

function showVersion()
{
    echo "Currently:"
    echo "--GCC version:"
    echo "  "$(gcc --version)
    echo "--G++ version:"
    echo "  "$(g++ --version)
}

if [ $# -lt 1 ];then
    echo "=============================================="
    echo "Uage   : set_gcc_version VersionNumber"
    echo "         Version Number could be 4.9/5.3/5.4"
    echo "Author : dujunlong[deepdu@126.com]"
    echo "Version: v0.1 [2016/10/3]"
    echo "=============================================="
    showVersion
    exit -1
fi

v=$1
GCC_HOME=/usr/bin
GCC_PRIVATE=/usr/local/gcc-5.3/bin

function removeLink()
{
    echo "Removing original GCC link..."
    rm $GCC_HOME/gcc
    rm $GCC_HOME/g++
}

echo "=============================================="
showVersion
echo "=============================================="
if [ $v == "5.3" ];then
    removeLink
    ln -s $GCC_PRIVATE/gcc $GCC_HOME/gcc
    ln -s $GCC_PRIVATE/g++ $GCC_HOME/g++
elif [ $v == "4.9" ];then
    removeLink
    ln -s $GCC_HOME/gcc-4.9 $GCC_HOME/gcc
    ln -s $GCC_HOME/g++-4.9 $GCC_HOME/g++
elif [ $v == "5.4" ];then
    removeLink
    ln -s $GCC_HOME/gcc-5 $GCC_HOME/gcc
    ln -s $GCC_HOME/g++-5 $GCC_HOME/g++
else
    echo "***Version Not Surpported!***"
    echo "=============================================="
    exit -1
fi
echo "Finished setting GCC version to $v"
echo "=============================================="
