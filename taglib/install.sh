#!/usr/bin/sh
echo "Start downloading taglib-1.12.tar.gz"
if [ -f ./taglib-1.12.tar.gz ]
then 
    echo "File already exists"
else
    wget https://taglib.org/releases/taglib-1.12.tar.gz
    if [ -f ./taglib-1.12.tar.gz ]
    then 
        echo "Download complete."
    else
        echo "Download failed exit!"
        exit 1
    fi 
fi
echo "Unzip the compressed file."
tar -zxvf taglib-1.12.tar.gz
if [ ! -d ./taglib-1.12 ]
then 
    echo "Unzip archive failed exit!"
    exit 2
else
    echo "The installation is complete."
fi