#!/bin/bash
date_fmt=$(date +'%y%m%d')

# don't include trailing / on the database file or cp will copy contents rather than directory itself
cp -R $HOME/Databases/$1.dtBase2 $HOME/Downloads

zip_path=$HOME/Downloads/$1-$date_fmt.dtBase2.tar.gz
tmp_path=$HOME/Downloads/$1.dtBase2

tar czf $zip_path $tmp_path

rm -r $tmp_path

gpg_cmd="gpg --encrypt --sign -r derek@dereknordgren.com $zip_path"

echo "$gpg_cmd" | pbcopy
echo "Copied to clipboard: '$gpg_cmd'"
