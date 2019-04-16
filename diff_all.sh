#!/bin/sh

student=./tracker-project/tests/acceptance/student
s_results=./tracker-project_tests/student

mkdir -p $s_results

count=1

for i in $student/*.txt
do
  ./tracker-project/EIFGENs/tracker/W_code/tracker -b $i > $s_results/at$count.actual.txt
  ./oracle.exe -b $i > $s_results/at$count.expected.txt
  diff $s_results/at$count.actual.txt $s_results/at$count.expected.txt
  count=`expr $count + 1`
done

