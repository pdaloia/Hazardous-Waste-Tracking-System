#!/bin/sh
student=./tracker-project/tests/acceptance/student
s_results=./student

mkdir -p $s_results

my_menu()
{
count=1
for i in "$student"/*.txt
do
  if test -f $i
  then
    echo "$count : `basename $i`"
    count=`expr $count + 1`
  fi
done
echo "h : Help / Display this menu
r : Clear the screen
q : Quit the program"
}

my_prg()
{
choice=$1
count=1
for i in "$student"/*.txt
do
  if test -f $i
  then
    if test $choice = $count 
    then
    ./tracker-project/EIFGENs/tracker/W_code/tracker -b $i > $s_results/actual.$(basename $i)
    ./oracle.exe -b $i > $s_results/expected.$(basename $i)
    meld $s_results/expected.$(basename $i) $s_results/actual.$(basename $i)
    count=`expr $count + 1`
    else
    count=`expr $count + 1`
    fi
  fi
done
}

my_menu
echo -n "Enter command: "
read mychoice
while test $mychoice != q && test $mychoice != Q
do
case $mychoice in
     [1-9]*) my_prg $mychoice;;  
     1[0-9]*) my_prg $mychoice;;
     2[0-9]*) my_prg $mychoice;;
     3[0-9]*) my_prg $mychoice;;
     4[0-9]*) my_prg $mychoice;;
     5[0-9]*) my_prg $mychoice;;  
     h|H) my_menu ;;
     r|R) clear ;;
     q|Q) exit 1 ;;
       *) echo "Invalid command" ;;
esac
my_menu
echo -n "Enter command: "
read mychoice
done
