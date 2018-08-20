#!/bin/bash
set -e
set -o pipefail

DATABASE_NAME=$1
USER=$2

function write_policy_and_auth {
export VAULT_SKIP_VERIFY=true
    echo "Creating sample policy with name ${DATABASE_NAME}-human to be used by devs, ops, sec-auditors from trusted network."
    vault policy write ${DATABASE_NAME}-human \
        vault/${DATABASE_NAME}-human.hcl

    vault write auth/userpass/users/${USER} \
        password="hemligt" \
        policies="${DATABASE_NAME}-human" \
        ttl=1h
}

function usage {
    echo " $0  my-db-name  userid"
}


if [ -z "$1" ]
then
    echo "No argument supplied... Usage:"
    usage
    exit 1
fi

function create_vault_policy_file {
    # template for policy file
cat <<EOF
path "database/creds/$DATABASE_NAME" {
    capabilities = ["read", "list"]
}
path "secret/$DATABASE_NAME" { 
    capabilities = ["read", "list"] 
}
path "sys/leases/renew" {
    capabilities = ["update"] 
}
path "sys/renew/*" {
    capabilities = ["update"] 
}
EOF
}

create_vault_policy_file > vault/${DATABASE_NAME}-human.hcl
write_policy_and_auth
echo "Done"