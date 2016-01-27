#!/bin/bash

action=$1

local_portrait_path="portraits"
upload_path="vilmibm@tilde.town:/home/vilmibm/public_html/asciigallery"
remote_portrait_path="$upload_path/portraits/"
screenshot=00000001.png
final="$local_portrait_path/$(date --iso-8601=seconds -u).portrait"

function print () {
    echo "printing..." >&2
    # lpr $final.txt
}

function upload () {
    echo "uploading..." >&2
    jp2a --height=30 --width=60 --output=$final.html --html --colors --fill /tmp/shotsmall.jpg

    scp $final.html $remote_portrait_path

    if [ -z $(ls index.html 2>/dev/null) ]; then
        cp index.html index.html.bak
    fi

    cp index.top.html index.html

    for portrait in $(ls $local_portrait_path | egrep "html$"); do
        echo "<div class=\"portrait\">" >> index.html
        # TODO var for url
        echo "<iframe src=\"portraits/$portrait\"></iframe>" >> index.html
        echo "</div>" >> index.html
    done

    echo "</div></body></html>" >> index.html
    scp index.html $upload_path/
}

mplayer -vo png -frames 1 tv:// > /dev/null 2>/dev/null
convert $screenshot -gravity Center -crop 200x200+0+0 +repage /tmp/shotcrop.jpg > /dev/null
convert /tmp/shotcrop.jpg -scale 48x48 /tmp/shotsmall.jpg > /dev/null
jp2a --height=60 --width=80 --output=$final.txt --invert /tmp/shotsmall.jpg

cat $final.txt

if [ "$action" == "print" ]; then
    print
elif [ "$action" == "upload" ]; then
    upload
elif [ "$action" == "all" ]; then
    print
    upload
fi

rm $screenshot
rm /tmp/shotcrop.jpg
rm /tmp/shotsmall.jpg
