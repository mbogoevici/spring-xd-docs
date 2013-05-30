#! /bin/sh

# List the files, find the links and place each by itself on a line and extract the link names
LINKS=`find . -name "*.asciidoc" | xargs -n 1 -J0 cat 0 | perl -pe 's/(link:.*?)\[/\n$1\n/g' | grep -o link:.* | perl -pe 's/link://' | perl -pe 's/wiki\///' | sort | uniq`

for LINK in $LINKS
do
  FILE=`find . -name $LINK.asciidoc`
  if [ "$FILE" = '' ]; then
    echo "Couldn't find asciidoc file for link $LINK"
  fi
done

