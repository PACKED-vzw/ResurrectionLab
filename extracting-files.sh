#!/bin/bash

if [ $# == 0 ] 
then 
	echo "No arguments found."
	echo "Give a disk image: "
	read diskimage
else
	diskimage=$1
fi

rsync -a $diskimage handling.img
handling=handling.img
mkdir test
hdiutil attach -readonly $handling | sed -E 's/[[:space:]]+/ /g' > mount.txt
mount_and_dev_string=$(<mount.txt)
mount_location=${mount_and_dev_string#*' '}
dev_location=${mount_and_dev_string%%' '*}
echo $mount_location
echo $dev_location
rsync -ra "$mount_location" test/
hdiutil detach "$dev_location"
echo "Done"
