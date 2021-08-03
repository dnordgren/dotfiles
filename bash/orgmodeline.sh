#!/bin/sh
org_mode_line="-*- mode: org -*-"
echo $org_mode_line | xargs | pbcopy
echo $org_mode_line | xargs
