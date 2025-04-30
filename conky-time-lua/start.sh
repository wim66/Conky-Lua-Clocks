#!/bin/sh
killall conky
cd "$(dirname "$0")"
conky -c conky.conf
