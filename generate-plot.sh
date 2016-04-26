#!/bin/sh

title=$(basename $(pwd))

log_directory=$1
if [ -z "$log_directory" ];then
    log_directory='log'
fi

# make plots
html=""
last=""
for i in log/*.log
do
    t=$(basename $i .log | awk -F'-' '{print $1}')
    rn=$(basename $i .log | awk -F'-' '{print $2}')
    cn=$(basename $i .log | awk -F'-' '{print $3}')

    if [ "${last}" != "$t" ];then
        if [ ! -z "${last}" ];then
            html="$html </div>"
        fi
        html="$html <div class='table-row'>"
        last=$t
    fi

    echo $t $rn $cn
    cat <<EOF > /tmp/n.plot
reset
set terminal png size 1000,1000

set size square 1,1


set xdata time
set timefmt "%Y-%m-%dT%H:%M:%SZ"
set format x "%H:%M:%S"
set xlabel "time"

set ylabel "%"
set yrange [0:150]

set title "$t-$rn-$cn"
set key reverse Left outside
set grid

set style data linespoints

plot "log/$t-$rn-$cn.log" using 1:2 title "cpu", "" using 1:3 title "mem"
EOF
    gnuplot /tmp/n.plot > image/$t-$rn-$cn.png
    html="$html <div class='table-cell'><img src='image/$t-$rn-$cn.png' /></div>"

    if [ $cn -eq 30 ] || [ $cn -eq 70 ];then
        html="$html </div>"
        html="$html <div class='table-row'>"
    fi
done

html="$html </div>"

html="$html <div class='table-row'>"
for i in image/ab-*.png
do
    html="$html <div class='table-cell'><img src='$i' /></div>"
done
html="$html </div>"

cat <<EOF > index.html
<style>
.table {display: table;}
.table-row {display: table-row;}
.table-cell {display: table-cell;}
.table-cell img {max-width: 400px;width: 100%;}
</style>
<h1>${title}</h1>

<h2>Target Pages</h2>
<pre>
$(cat pages.txt)
</pre>
<div class='table'>
${html}
</div>
EOF

exit 0
