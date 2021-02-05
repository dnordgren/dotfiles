#!/bin/bash
date_fmt=$(date +'%y%m%d')

# $1 : database name
# $2 : database path
#    : ~/Databases/<db>.dtBase2
#    : ~/Library/Application\ Support/DEVONthink\ 3/Inbox.dtBase2

# don't include trailing / on the database file or cp will copy contents rather than directory itself
cp -R "$2" $HOME/Downloads

zip_path=$HOME/Downloads/$1-$date_fmt.dtBase2.tar.gz
tmp_path=$HOME/Downloads/$1.dtBase2

tar czf $zip_path $tmp_path

rm -r $tmp_path

gpg_cmd="gpg --encrypt --sign -r derek@dereknordgren.com $zip_path"

echo "$gpg_cmd" | tr -d '\n' | pbcopy
echo "Copied to clipboard: '$gpg_cmd'"

