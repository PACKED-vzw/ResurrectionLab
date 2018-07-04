#!/bin/bash
#
# script om door alle folders te gaan en de files van disk images 
# te extracten
# author: Nastasia Vanderperren (PACKED vzw)
#
################################################################

for folder in $1/*
do
    echo $folder
    cd $folder
    rm -rf content
    mkdir content

    rsync -a $folder/image/*.img handling.img
    handling=handling.img
    hdiutil attach -readonly $handling | sed -E 's,[[:space:]]+, ,g' > mount.txt # store information in helper txt file
    # use the mount.txt file to split mounting location and device location in variables
    mount_and_dev_string=$(<mount.txt)
    dev_location=${mount_and_dev_string%%' '*}
    mount_location=${mount_and_dev_string#*' '}
    echo "dev location is: $dev_location"
    echo "mount location is: $mount_location"
    if [ ! -z "$mount_location" ]; then
        rsync -ra "$mount_location"/ content/ # copy files using rsync
        tree -DUN --si "$mount_location" > meta/index.txt # create index with last modified date and file size
    fi
    hdiutil detach "$dev_location"
    rm mount.txt # delete helper txt file
    rm $handling
    
    echo "Done extracting files and folders of $folder"

    echo "Start characterizing the files of the disk..."
    sf -hash md5 -z -csv content > meta/file_identification.csv  # creates also checksum for each file
    echo "Done characterizing files!"

done
