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
  cp -rf libs compiled/libs
  lua compiled/main.lua
elif [ "$client" -eq 1 ]; then

export LUA_PATH='/Users/cass/.luarocks/share/lua/5.1/?.lua;/Users/cass/.luarocks/share/lua/5.1/?/init.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/Cellar/luarocks/3.1.3/share/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;./?.lua;./?/init.lua'
export LUA_CPATH='/Users/cass/.luarocks/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so;./?.so'
export PATH='/Users/cass/.luarocks/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/MacGPG2/bin'
  
  cd Client/
  rm -rf compiled
  mkdir compiled/
  cp -rf media/ compiled/media 
  moonc -t compiled/ .
  love compiled/
else
  exit 0
fi
