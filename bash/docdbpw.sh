#!/bin/zsh

env=$2

if [ -z "$2" ]
then
    env="thor"
fi

aws secretsmanager get-secret-value \
  --secret-id marvel/$env/$1/DocDBCredentials \
  | jq -r .SecretString | jq -r .Secret | jq -r .Password \
  | pbcopy

echo "Copied pw for $1 $env to clipboard"
