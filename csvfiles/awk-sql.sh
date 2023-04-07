#!/bin/sh
# select * from table
# column -ts, EMP.csv   
# column -ts, DEPT.csv

# SELECT EMPNO, ENAME, SAL FROM EMP;
# awk -F, 'BEGIN{OFS="\t";}{print $1,$2,$6}' EMP.csv

# SELECT * FROM EMP WHERE SAL >= 3000;
# awk -F, '{if($6>=3000)print;}' EMP.csv

# SELECT COUNT(*) FROM EMP;
# awk -F, 'END{print NR}' EMP.csv #count

# SELECT AVG(SAL) FROM EMP;
# awk -F, '{sum+=$6;}END{print sum/NR}' EMP.csv #average

# SELECT SUM(SAL) FROM EMP;
# awk -F, '{sum+=$6;}END{print sum}' EMP.csv

# SELECT MAX(SAL) FROM EMP;
# awk -F, 'NR==2 {max=$6} NR>1 && $6>max {max=$6} END{print max}' EMP.csv #max

# SELECT MIN(SAL) FROM EMP;
# awk -F, 'NR==2 {min=$6} NR>1 && $6<min {min=$6} END{print min}' EMP.csv #min

# SELECT DEPTNO FROM EMP GROUP BY DEPTNO; --Distinct DEPTNO
# awk -F, '{a[$8]="";}END{for(i in a){print i;}}' EMP.csv
# awk -F, '{print $8}' EMP.csv | sort | uniq
# cut -d"," -f8 EMP.csv | sort | uniq

# CAUTION !! DO NOT use cat command to open file then pipe into awk or another command. IT’S VERY BAD USE OF CAT.
# $ cat EMP.csv | awk

# SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO;
# awk -F, '{a[$8]+=$6;}END{for(i in a){print i,a[i];}}' EMP.csv #sum

# SELECT DEPTNO, COUNT(*) FROM EMP GROUP BY DEPTNO;
# awk -F, '{a[$8]++;}END{for(i in a){print i,a[i];}}' EMP.csv #count

# SELECT DEPTNO, AVG(SAL) FROM EMP GROUP BY DEPTNO;
# awk -F, '{a[$8]+=$6;b[$8]++;}END{for(i in a){print i,a[i]/b[i];}}' EMP.csv #average

# NF Number of fields 
# awk -F, '{print NF}' EMP.csv | sort | uniq 

# awk -F, '{$9=$6*12;print;}' EMP.csv | column -ts[\ ]


# SELECT EMP.*,
# CASE WHEN SAL >= 2500 THEN 'GRADE-A'
#      WHEN SAL >= 1500 AND SAL <2500 THEN 'GRADE-B'
#      WHEN SAL < 1500 THEN 'GRADE-C'
# END AS EMP_GRADE
# FROM EMP;
# awk -F, '$6>=2500 {$9="GRADE-A"} $6>=1500 && $6<2500 {$9="GRADE-B"} $6<1500 {$9="GRADE-C"} {print}' EMP.csv | column -ts\ 


# SELECT EMPNO,ENAME,DEPTNO,
# ROW_NUMBER() OVER(PARTITION BY DEPTNO ORDER BY '') AS EMP_SERIAL
# FROM EMP;
# awk -F, '{pb[$8]++;print $1,$2,$8,pb[$8];}' EMP.csv | column -ts\ 


# SELECT
#       E.EMPNO,
#       E.ENAME,
#       E.DEPTNO,
#       D.DNAME
# FROM EMP E
# INNER JOIN DEPT D
# ON E.DEPTNO = D.DEPTNO;
awk -F, 'NR==FNR{key[$1]=$2;} $8 in key {print $1,$2,$8,key[$8]}' DEPT.csv EMP.csv | column -ts\ 


awk -F, 'NR==FNR{key[$1]=$2;} NR!=FNR{print $1,$2,$8,key[$8]}' DEPT.csv EMP.csv | column -ts\ 

