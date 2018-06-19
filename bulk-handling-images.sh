#!/bin/bash
#
##############

for folder in $1/*
do
    cd $folder
    diskimage=image/*.img
    rsync -a $diskimage handling.img
    handling=handling.img

    # create an MD5 checksum
    echo "Creating md5 checksum..."
    md5 $diskimage > meta/checksum.txt
    echo "Done creating checksum!"

    echo "Identifying the file system..."
    disktype $handling > meta/disktype.txt
    echo "Done identifying the file system!"

    echo "Start characterizing the files of the disk..."
    sf -hash md5 -z -csv content > meta/file_identification.csv  # creates also checksum for each file
    echo "Done characterizing files!"

    # scan the image
    echo "Scanning the image"
    freshclam -update # update virus database
    clamscan -r --bell $handling content/ > meta/virusscan.txt
    echo "Done scanning the image!"

    rm $handling
    echo "Done $folder!"
done

echo "Done all folders!"