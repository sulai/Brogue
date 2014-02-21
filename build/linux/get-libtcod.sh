#!/usr/bin/env bash
cd `dirname $0`
wget -c http://doryen.eptalys.net/?file_id=48 -O libtcod-1.5.2-32.tar.gz
tar -C ../../src/ -xf libtcod-1.5.2-32.tar.gz
cp ../../src/libtcod-1.5.2/libtcod.so ../../bin/linux

