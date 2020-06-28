#!/bin/sh
uuid=$(uuidgen)
echo $uuid | xargs | pbcopy
echo $uuid | xargs

