#!/usr/bash

cnt=0

until [[ $STATUS -eq 1 ]]
do
	./fail.sh >> log.txt 2>&1
	STATUS=$?
	cnt=$(( cnt+1 ))
done

echo "It took $cnt times to fail"
