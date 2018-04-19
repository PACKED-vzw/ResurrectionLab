#!/bin/bash
#
# script to more or less automate the imaging of Macintosh formatted floppies 
# for Liberaal Archief
# author: Nastasia Vanderperren (PACKED vzw)
# script written for macOS and OS X systems
# prerequisites: kryoflux software, hfsutil, siegfried and bagit.py
# source: John Durno, http://journal.code4lib.org/articles/11986
#
#############################################################

# parameters

if [ $# == 0 ]
then # if there is no parameter
    echo "No arguements found." 
    echo "Give a name to the floppy image: "
    read UI
else
    UI=$1  # this is the name you give to the image
fi

#create directory for the image and its metadata
echo "Creating folder structure for image and its metadata..."
mkdir $UI
cd $UI
    mkdir image content meta
echo "Done creating folder structure!"

# create an image of the files with the kryoflux
echo "Creating image with the kryoflux controller..."
dtc -p -fimage/$UI/$UI -i0 -fimage/$UI.img -i9 2>&1 | tee meta/image_$UI.log  # create Apple DOS 400/800K sector image
diskimage=image/$UI.img
cp $diskimage handlingcopy.img # create handling copy
handling=handlingcopy.img
echo "Done creating image!"

# create an MD5 checksum
echo "Creating md5 checksum..."
md5 $diskimage > meta/checksum.txt
echo "Done creating checksum!"

# identify the file system
echo "Identifying the file system..."
disktype $handling > meta/disktype.txt
echo "Done identifying the file system!"

# get the contents and structure of the files on the disk
echo "Extracting files and folders of image..."
hmount $handling > meta/hmount.txt
    hls -i -a -l -R > meta/index.txt
    hcopy -r :* content/
humount
echo "Done extracting files!"

# to do: file characterization"
echo "Start characterizing the files of the disk..."
sf -hash md5 -z -csv content > meta/file_identification.csv  # creates also checksum for each file
echo "Done characterizing files!"

# delete handlingcopy
rm $handling

# place everything in a bag
#echo "Creating BagIt for files..."
#cd ..
#bagit.py $UI
#echo "Done creating BagIt!"

echo "Done processing Macintosh floppy!"