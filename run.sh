#!/bin/bash
client=0
server=0

while [[ "$#" -gt 0 ]]; do case $1 in
  -s|--server) server=1; shift;;
  -c|--client) client=1;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

if [ "$server" -eq 1 ]; then
  cd Server/
  rm -rf compiled/
  moonc -t compiled/ .
  lua compiled/main.lua
elif [ "$client" -eq 1 ]; then
  cd Client/
  moonc -t compiled/ .
  love compiled/
else
  exit 0
fi
