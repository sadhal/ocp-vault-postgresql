#!/bin/bash
set -e
set -o pipefail

DATABASE_NAME=$1

function vault_enable_postgres_backend {
  echo "Create a database configuration with a superuser on database ${DATABASE_NAME}"
  vault write database/config/${DATABASE_NAME} \
    plugin_name=postgresql-database-plugin \
    allowed_roles="*" \
    connection_url="postgresql://postgres:somegeneratedpassword@${DATABASE_NAME}.db-postgresql.svc:5432/backend?sslmode=disable" \
    username="postgres" password="somegeneratedpassword"

  echo "Create a role which creates a PostgreSQL role with all permissions on database ${DATABASE_NAME}"
  vault write database/roles/${DATABASE_NAME} \
    db_name=${DATABASE_NAME}  \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\";GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\""  \
    default_ttl="1h"    max_ttl="100h"
}

function vault_add_generic_secrets {
  # TODO: remove?
  echo "Writing sample secret..."
  # Write a sample __generic secret__ for application with name ${DATABASE_NAME} for later retrieval
  #vault write secret/${DATABASE_NAME} password=pwd
  vault write secret/${DATABASE_NAME} password=pwd hemlighet1=sadmir hemlighet2=generiska-hemligheter-som-properties-i-spring-boot
}

function usage {
    echo " $0 my-db-name"
}


if [ -z "$1" ]
then
    echo "No argument supplied... Usage:"
    usage
    exit 1
fi

export VAULT_SKIP_VERIFY=true
vault_enable_postgres_backend
vault_add_generic_secrets

