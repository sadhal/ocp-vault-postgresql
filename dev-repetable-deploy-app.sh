#!/bin/bash
set -e
set -o pipefail

APPLICATION_NAME=$1
OCP_NAMESPACE=$2


function create_ocp_app {
    
    echo "Create new OCP project and asign developer as project admin..."
    # oc login -u admin -p admin
    # oc adm new-project ${OCP_NAMESPACE} --admin=developer

    echo "Deploy sample application as developer..."
    oc login -u developer -p developer
    oc project ${OCP_NAMESPACE}
    # oc create -f spring-sample-app/spring-sample-app.yml
    oc process -f spring-sample-app/minishift-application-template.yml -p APP_NAME=${APPLICATION_NAME} | oc create -f -
    
    # mvn -DskipTests=true clean install -f spring-sample-app/pom.xml
    mvn -DskipTests=true install -f spring-sample-app/pom.xml
    oc start-build ${APPLICATION_NAME}-binary --follow --from-file=./spring-sample-app/target/vault-demo-with-postgresql-0.0.1-SNAPSHOT.jar
}

function usage {
    echo " $0  name-of-my-awesome-application  my-ocp-namespace-for-app"
}


if [ -z "$1" ]
then
    echo "No argument supplied... Usage:"
    usage
    exit 1
fi

create_ocp_app
