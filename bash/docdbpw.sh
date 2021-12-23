#!/bin/zsh

env=$2

if [ -z "$2" ]
then
    env="thor"
fi

db_pw=$(aws secretsmanager get-secret-value --secret-id marvel/$env/$1/DocDBCredentials | jq -r .SecretString | jq -r .Secret | jq -r .Password)

echo "$db_pw" | pbcopy
echo "Copied pw for $1 $env to clipboard"

mongo --host t-$1-docdb.app.thorhudl.com:27018 --username $1 --ssl --sslCAFile ~/.ssh/rds-combined-ca-bundle.pem --sslAllowInvalidCertificates --password $db_pw
