#!/bin/sh
year=$1
month=$2
day=$3
app=$4
date=$year-$month-$day

files=$(find ./csvfiles -type f -name "*.application.??????????.csv")
for i in $files
do
    echo $i
done