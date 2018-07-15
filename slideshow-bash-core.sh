#!/bin/bash

qiv -films -T pic.jpg &

while true
do

  curl -u user:password 'https://cloud.viertel.me/remote.php/dav/files/user/directory/' -X PROPFIND > response.xml

  sed -i 's/d://g' response.xml

  xmllint --shell response.xml <<< `echo 'cat multistatus/response/href/text()'` | sed 's/ -------//g' | sed '1d' | sed '1d' | sed '1d' | sed '$ d' | sed '/^\s*$/d' > parsed.txt

  shuf parsed.txt > shuffled.txt

  rm parsed.txt

  sed -i 's/^/https:\/\/cloud.viertel.me/' shuffled.txt

  while read p; do
    timeout 60 bash -c "wget --user user --password password -O pic $p; cp pic pic.jpg"
    rm pic
  done < shuffled.txt

done
