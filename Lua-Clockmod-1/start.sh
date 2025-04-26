#!/bin/sh


killall conky
cd "$(dirname "$0")"
sleep 1
echo "\nstarting conky's\n"

( set -x; conky -c Lua-Clock1.conf )
echo "\nexiting"


