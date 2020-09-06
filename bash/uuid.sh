#!/bin/sh
uuid=$(uuidgen)
echo $uuid | tr -d '\n' | pbcopy
echo $uuid | tr -d '\n'
