#!/bin/bash
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
  echo "** Trapped CTRL-C"
  sudo killall lovet
  exit 0
}

moonc -t compiled/ .

for run in {1..2}
do
  love compiled/ &
done

while true ; do continue ; done

