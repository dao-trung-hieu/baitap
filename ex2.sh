#!/bin/sh
# take a date as an argument
year=$1
month=$2
day=$3
date=$year-$month-$day
app="application"
device="device"

# writes 1 csv file with columns “application”,”number of unique users”
files=$(find ./csvfiles -type f -name "*$app.$date*.csv")
for i in $files
do
    awk -F, '{print $1","$2}' $i >> ./csvfiles/$app-$date-total.csv
done

awk -F, '{i=$2} !A[i,$1]++{B[i]++} END{for(i in B)print i","B[i]}' ./csvfiles/$app-$date-total.csv > ./csvfiles/$app-$date-report.csv

# writes 1 csv file with columns “device”,”number of unique users"
files=$(find ./csvfiles -type f -name "*$device.$date*.csv")
for i in $files
do
    awk -F, '{print $1","$2}' $i >> ./csvfiles/$device-$date-total.csv
done

awk -F, '{i=$2} !A[i,$1]++{B[i]++} END{for(i in B)print i","B[i]}' ./csvfiles/$device-$date-total.csv > ./csvfiles/$device-$date-report.csv

# writes 1 csv file with columns “application”,“device” with all possible unique application
awk -F, '{print $1","$2}' ./csvfiles/$app-$date-total.csv | sort | uniq > ./csvfiles/$app-$date-unique.csv
awk -F, '{print $1","$2}' ./csvfiles/$device-$date-total.csv | sort | uniq > ./csvfiles/$device-$date-unique.csv

join -t, -a1 -a2 ./csvfiles/$app-$date-unique.csv ./csvfiles/$device-$date-unique.csv > ./csvfiles/$app-$device-$date-total.csv

awk -F, '{print $3","$2}' ./csvfiles/$app-$device-$date-total.csv | sort | uniq > ./csvfiles/$app-$device-$date-unique.csv

