#!/usr/bin/gnuplot

reset
set terminal png size 1000,1000

set size square 1,1


set xdata time
set timefmt "%Y-%m-%dT%H:%M:%SZ"
set format x "%H:%M:%S"
set xlabel "time"

set ylabel "%"
set yrange [0:500]

set title "Load"
set key reverse Left outside
set grid

set style data linespoints

plot "node.log" using 1:2 title "cpu", "" using 1:3 title "mem"
