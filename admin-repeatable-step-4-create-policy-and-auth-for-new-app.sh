#!/bin/bash
set -e
set -o pipefail

DATABASE_NAME=$1
OCP_NAMESPACE=$2

function write_policy_and_auth {
export VAULT_SKIP_VERIFY=true
    echo "Creating sample policy with name ${DATABASE_NAME} to be used by containerised applications from k8s."
    vault policy write ${DATABASE_NAME} vault/${DATABASE_NAME}.hcl
    vault write auth/kubernetes/role/${DATABASE_NAME} bound_service_account_names=default bound_service_account_namespaces=${OCP_NAMESPACE} policies=${DATABASE_NAME} ttl=1h
}

function usage {
    echo " $0 my-db-name my-ocp-namespace-for-app"
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
    capabilities = ["create", "read", "update", "delete", "list"] 
}
path "secret/application" { 
    capabilities = ["create", "read", "update", "delete", "list"]
}
path "sys/leases/renew" {
    capabilities = ["update"] 
}
path "sys/renew/*" {
    capabilities = ["update"] 
}
EOF
}

create_vault_policy_file > vault/${DATABASE_NAME}.hcl
write_policy_and_auth
echo "Done"