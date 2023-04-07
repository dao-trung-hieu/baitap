#!/bin/sh

# select A, 
#        B, 
#        count(distinct C), 
#        sum(D),
#        sum(case when E>20 then E else 0 END) 
#   from test 
#  group by A,B
cat ./text.txt 
# newline
echo 1
awk ' NR<3{next}

  {i=$1 OFS $2
  D[i]+=$4}

  !A[i,$3]++{C[i]++}

  $5>20{E[i]+=$5}

  END{for(i in D)print i, C[i], D[i], E[i]+0}

' OFS='\t' ./text.txt