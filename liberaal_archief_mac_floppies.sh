#!/bin/bash
#
# script to more or less automate the imaging of Macintosh formatted floppies 
# for Liberaal Archief
# author: Nastasia Vanderperren (PACKED vzw)
# script written for macOS and OS X systems
# prerequisites: ClamAV, kryoflux software, hfsutil, siegfried and bagit.py
# source: John Durno, http://journal.code4lib.org/articles/11986
#
#############################################################

# parameters
if [ $# == 0 ]
then # if there is no parameter
    echo "No arguments found." 
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
# create Apple DOS 400/800K sector image
dtc -p -fimage/$UI/$UI -i0 -fimage/$UI.img -i9 2>&1 | tee meta/image_$UI.log  
diskimage=image/$UI.img
rsync -a  $diskimage handlingcopy.img # create handling copy
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
hmount $handling > meta/hmount.txt # keep this until better way found to get this information
    hls -i -a -l -R > meta/index.txt
#    hcopy -m :* content/
humount

# maybe better this way: 
hdiutil attach -readonly $handling | sed -E 's/[[:space:]]+/ /g' > mount.txt # store information in helper txt file
# use the mount.txt file to split mounting location and device location in variables
mount_and_dev_string=$(<mount.txt)
dev_location=${mount_and_dev_string%%' '*}
mount_location=${mount_and_dev_string#*' '}
if [ ! -z "$mount_location" ]; then
    rsync -ra "$mount_location"/ content/ # copy files using rsync
fi
hdiutil detach "$dev_location"
rm mount.txt # delete helper txt file
echo "Done extracting files and folders!"

# to do: file characterization"
echo "Start characterizing the files of the disk..."
sf -hash md5 -z -csv content > meta/file_identification.csv  # creates also checksum for each file
echo "Done characterizing files!"

# scan the image
echo "Scanning the image"
freshclam -update # update virus database
clamscan -r --bell $handling content/ > meta/virusscan.txt
echo "Done scanning the image!"

# delete handlingcopy
rm $handling

# place everything in a bag
#echo "Creating BagIt for files..."
#cd ..
#bagit.py $UI
#echo "Done creating BagIt!"


echo "Done processing Macintosh floppy!"
echo -ne '\a'
