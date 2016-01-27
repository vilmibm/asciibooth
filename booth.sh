#!/bin/bash

print=$1

screenshot=00000001.png
final=$(date --iso-8601=seconds -u).txt

mplayer -vo png -frames 1 tv:// > /dev/null 2>/dev/null
convert $screenshot -gravity Center -crop 200x200+0+0 +repage shotcrop.jpg > /dev/null
convert shotcrop.jpg -scale 48x48 shotsmall.jpg > /dev/null
jp2a --height=60 --width=80 --output=$final --invert shotsmall.jpg
cat $final

if [ ! -z $print ]
then
    lpr $final
fi
