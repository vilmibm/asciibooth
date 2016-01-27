#!/bin/bash

action=$1

upload_path="vilmibm@tilde.town:/home/public_html/asciigallery/portraits/"
screenshot=00000001.png
final=$(date --iso-8601=seconds -u).portrait

function print () {
    echo "printing..." >&2
    # lpr $final.txt
}

function upload () {
    echo "uploading..." >&2
    jp2a --height=60 --width=100 --output=$final.html --html --colors --fill shotsmall.jpg
    scp $final.html $upload_path
}

mplayer -vo png -frames 1 tv:// > /dev/null 2>/dev/null
convert $screenshot -gravity Center -crop 200x200+0+0 +repage shotcrop.jpg > /dev/null
convert shotcrop.jpg -scale 48x48 shotsmall.jpg > /dev/null
jp2a --height=60 --width=80 --output=$final.txt --invert shotsmall.jpg

cat $final.txt

if [ "$action" == "print" ];
then
    print
elif [ "$action" == "upload" ];
then
    upload
elif [ "$action" == "all" ];
then
    print
    upload
fi

rm $screenshot
rm shotcrop.jpg
rm shotsmall.jpg
