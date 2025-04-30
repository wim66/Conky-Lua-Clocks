#!/bin/sh


killall conky
cd "$(dirname "$0")"
sleep

( set -x; conky -c conky.conf )



