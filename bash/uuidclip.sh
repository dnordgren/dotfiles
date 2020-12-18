#!/bin/sh

# `sudo mv uuidclip /usr/local/bin`
# `sudo chmod +x /usr/local/bin/uuidclip`
uuid=$(uuidgen)
echo $uuid | tr -d '\n' | pbcopy # clip.exe in WSL
echo $uuid | tr -d
