#!/bin/sh
# take a path as an argument
path=$1
log_file="./mylog.log"
# check for .git directory
folders=$(find $path -type d -exec test -e '{}'/.git \; -print)
#  minimun size of directory, 1mb = 1048576 bytes
min_size=1048576
for i in $folders
do
    start_time=$(date +%s)
    size=$(du -sb $i | cut -f1)
    if [ $size -gt $min_size ]
    then
        echo $i $size kb
    fi
    end_time=$(date +%s)
    runtime=$((end_time-start_time))
    echo "take $runtime seconds to print $i" >> $log_file
done










