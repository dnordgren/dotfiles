#!/bin/sh
date_fmt=$(date +'%y%m%d')
hour_fmt=$(date +'%H%M')

echo "$date_fmt-$hour_fmt " | tr -d '\n' | pbcopy

