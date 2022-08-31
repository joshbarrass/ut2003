#!/bin/bash

GAMEDIR="$1"
cd "$GAMEDIR"

rm AutoRun.exe AutoRun.inf linux_installer.sh Setup.exe
find -type f -name "*.uz2" -exec "$GAMEDIR/System/ucc-bin" decompress {} \&\& rm {} \;
