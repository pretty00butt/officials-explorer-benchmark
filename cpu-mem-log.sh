while sleep 1
do
    echo -n $(date -u +"%Y-%m-%dT%H:%M:%SZ") ""
    top -b -d 0 -n 1 | grep "$1" | awk '{print $9, $10}'
done
