USED SCRIPTS
============

## Fiwalk
fiwalk tells you which file system type is used and gives some file system statistics

```bash
for file in _directory-name_/*; do 
   fiwalk $file >> output.txt;  # create a new text file or append last line if text file already exists 
done
```

## mmls
mmls checks each partition of the file and tells you which partition type (filesystem) is used

```bash
for file in _directory-name_/*; do
   # print the name of the file
   echo $(basename $file) >> output.txt;
   mmls $file >> output.txt;
done
```

## Brunnhilde
brunnhilde analyses files and iso's: virusscan, tree, carving of files, and file identification (siegfried)

```bash
for file in _directory-name_; do
   # source destination basename
   # to enable hfs: --hfs --resforks
   brunnhilde.py -d $file _outputfolder_ `basename $file`;
done
``` 
     
