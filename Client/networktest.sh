#!/bin/bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  sudo killall lovet
  exit 0
}

rm -rf compiled/
moonc -t compiled/ .

for run in {1..2}
do
  lovet compiled/ &
done

while true ; do continue ; done

