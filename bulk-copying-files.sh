#!/bin/bash

for folder in $1/*
do
    echo $folder
    cd $folder
    name=${PWD##*/}
    echo "$name"
    doel=/Volumes/Storage/ResLab/processing/"$name"
    mkdir $doel
    rsync -ra content/ $doel
done