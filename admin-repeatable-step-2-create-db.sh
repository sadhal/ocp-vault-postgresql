#!/bin/bash
set -e 
set -o pipefail

DATABASE_NAME=$1

function create_db {
  echo "Deploying new PostgreSQL instance in namespace db-postgresql as admin..."
  oc login -u admin -p admin
  oc project db-postgresql
  oc new-app --template=postgresql-persistent --name=${DATABASE_NAME} -p POSTGRESQL_DATABASE=backend -e POSTGRESQL_ADMIN_PASSWORD=somegeneratedpassword -p DATABASE_SERVICE_NAME=${DATABASE_NAME}
  echo "Done..."
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


create_db