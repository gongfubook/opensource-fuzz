#!/usr/bin/sh
echo "Start downloading taglib-1.12.tar.gz"
if [ -f ./libaio-libaio-0.3.113.zip ]
then 
    echo "File already exists"
else
    wget https://pagure.io/libaio/archive/libaio-0.3.113/libaio-libaio-0.3.113.zip
    if [ -f ./libaio-libaio-0.3.113.zip ]
    then 
        echo "Download complete."
    else
        echo "Download failed exit!"
        exit 1
    fi 
fi
echo "Unzip the compressed file."
unzip libaio-libaio-0.3.113.zip
if [ ! -d ./libaio-libaio-0.3.113 ]
then 
    echo "Unzip archive failed exit!"
    exit 2
else
    echo "The installation is complete."
fi














