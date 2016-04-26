#!/bin/sh

while read -r i
do
    echo '################################################################################'
    echo '#' $i
    echo '>' $(date -u +"%Y-%m-%dT%H:%M:%SZ")
    ab -n $1 -c $2 "$i"
    echo '<' $(date -u +"%Y-%m-%dT%H:%M:%SZ")
    # break
done < pages.txt
