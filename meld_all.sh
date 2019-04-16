#!/bin/sh

student=./tracker-project/tests/acceptance/student
s_results=./tracker-project_tests/student

mkdir -p $s_results

for i in $student/*.txt
do
  ./tracker-project/EIFGENs/tracker/W_code/tracker -b $i > $s_results/actual.$(basename $i)
  ./oracle.exe -b $i > $s_results/expected.$(basename $i)
  meld $s_results/expected.$(basename $i) $s_results/actual.$(basename $i)
done

