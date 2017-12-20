#!/bin/bash

# Get the shortened URL from git.io
# Don't print any output
shortened=$(curl --silent -i https://git.io -F "url=$1")

# Pull out just the line with the shortened URL
location=$(echo "$shortened" | grep 'Location: ')

# Parse out just the URL & trim whitespace with xargs
gitiourl=$(echo "$location" | cut -d ' ' -f 2 | tr -d '\n' | xargs)

# Print success message and copy URL to clipboard
echo "$gitiourl"
echo -n "$gitiourl" | pbcopy
