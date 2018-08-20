#!/bin/bash
set -e
set -o pipefail

APPLICATION_NAME=$1
OCP_NAMESPACE=$2

function run_k8s_auth_test {
    echo "Testing vault integration..."
    echo ""
    # Test vault login
    vault write auth/kubernetes/login role=${APPLICATION_NAME} jwt=$(oc serviceaccounts get-token default -n secret-management)
    echo ""
}

function run_spring_app_test {
    oc login -u developer -p developer
    oc project ${OCP_NAMESPACE}
    echo "Test spring application and it's integration with Vault"
    echo ""
    # Test service
    route=$(oc get route ${APPLICATION_NAME} -o jsonpath={.spec.host})

    curl http://$route/actuator/health 
    echo ""
    curl http://$route/secret
    echo "" 
    curl http://$route/secrets |jq
    echo ""

    curl http://$route/orders | jq
    echo ""

    curl -s -X POST http://$route/orders \
    -H 'content-type: application/json' \
    -d '{"customerName": "Lance", "productName": "Vault-Ent"}' | jq
    echo ""

    curl http://$route/orders | jq
    echo ""
    curl -s -X DELETE -w "%{http_code}" http://$route/orders | jq
    echo ""
}

function run_psql_test {
    psql -h 127.0.0.1 -U $POSTGRESQL_USER -q -d $POSTGRESQL_DATABASE -c 'SELECT 1'
}

function usage {
    echo " $0 my-app-name  name-of-my-ocp-namespace"
}


if [ -z "$1" ]
then
    echo "No argument supplied... Usage:"
    usage
    exit 1
fi

# run_k8s_auth_test
run_spring_app_test
#run_psql_test
echo "Done"
echo ""