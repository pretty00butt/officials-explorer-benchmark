#!/bin/sh

(bash cpu-mem-log.sh 29065 | tee log/mysqld-$1-$2.log &)
(bash cpu-mem-log.sh  6768 | tee log/node-$1-$2.log &)

sleep 10

bash ab.sh $1 $2 | tee log/ab-$1-$2.ab

sleep 10

kill -9 $(ps aux | grep cpu-mem-log.sh | awk '{print $2}')

#bash generate-plot.sh
