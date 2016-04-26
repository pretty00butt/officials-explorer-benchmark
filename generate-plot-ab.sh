#!/bin/sh

log_directory=$1
if [ -z "$log_directory" ];then
    log_directory='log'
fi

# make plots
html=""
last=""

rm -f /tmp/ab-*.log
for i in $(ls -al log/ab*.ab| awk '{print $9}' | sort -n -t '-' -k 3)
do
    rn=$(basename $i .ab | awk -F'-' '{print $2}')
    cn=$(basename $i .ab | awk -F'-' '{print $3}')

    rpr=$(cat $i | grep 'Time per request:' | grep '(mean)' | awk -F':' '{print $2}' | awk '{print $1}')

    echo $cn $rpr >> /tmp/ab-$rn.log
done

for i in /tmp/ab-*.log
do
    rn=$(basename $i .log | awk -F'-' '{print $2}')
cat <<EOF > /tmp/n.plot
reset
set terminal png size 1000,1000

set size square 1,1

set title "$rn"
set xlabel "concurrency"

set ylabel "ms"
set yrange [0:2000]

set key reverse Left outside
set grid

set style data linespoints

plot "/tmp/ab-$rn.log" using 1:2 title "a", "" using 1:3 title "b", "" using 1:4 title "c", "" using 1:6 title "d", "" using 1:6 title "e", "" using 1:7 title "f"
EOF

gnuplot /tmp/n.plot > image/ab-$rn.png
done

exit 0
