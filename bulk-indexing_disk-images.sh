#!/bin/bash
#
# script om door alle folders te gaan en de files van disk images 
# te indexeren
# author: Nastasia Vanderperren (PACKED vzw)
#
################################################################

for folder in $1/*
do
    echo "$folder"
    cd "$folder"

    rsync -a $folder/image/*.img handling.img
    handling=handling.img
    hmount $handling
    hls -ialR > meta/index.txt
    humount
    rm $handling
    
    echo "Done indexing files and folders of $folder"

done