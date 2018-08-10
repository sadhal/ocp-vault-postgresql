#!/bin/bash
set -e
set -o pipefail


function vault_enable_database_secrets {
  echo "Enabling secret management for db in vault..."
  vault secrets enable database
  
}

function create_oc_project_for_databases {
  echo "Creating project for PostgreSQL. All databases will be deployed here. Other solutions should be considered..."
  oc new-project db-postgresql
}

export VAULT_SKIP_VERIFY=true
vault_enable_database_secrets
create_oc_project_for_databases


