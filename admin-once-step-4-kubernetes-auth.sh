#!/bin/bash
set -e
set -o pipefail


echo "Enable kubernetes as authentication backend for pods communication with vault."

function openshift_systemaccount_and_policy_for_vault {
  echo "Creating service account for Vault..."
  oc login -u admin -p admin
  oc project secret-management
  oc create sa vault-auth

  echo "Add policy to allow TokenReview requests from vault"
  oc adm policy add-cluster-role-to-user system:auth-delegator -z vault-auth
}

function vault_enable_kubernets_auth {
  echo "Get the JWT token for the servie account"
  reviewer_service_account_jwt=$(oc serviceaccounts get-token vault-auth)

  echo "Get the CA certificate for our cluster"
  pod=$(oc get pods -n $(oc project -q) | grep vault | awk '{print $1}')
  oc exec $pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt >> ca.crt

  echo "Enabling kubernetes auth backend..."
  vault auth enable kubernetes

  echo "Use the JWT token and CA certificate to create a kubernetes authentication configuration"
  vault write auth/kubernetes/config \
    token_reviewer_jwt=$reviewer_service_account_jwt \
    kubernetes_host=https://kubernetes.default.svc:443 \
    kubernetes_ca_cert=@ca.crt 
  rm ca.crt
}

# function vault_create_sample_policy_and_role {
#   echo "Creating sample policy with name 'backend'"
#   vault policy write backend vault/backend-policy.hcl 

#   echo "Creating sample role with name 'backend' bound to namespace 'secret-management'"
#   vault write auth/kubernetes/role/backend bound_service_account_names=default bound_service_account_namespaces=secret-management policies=backend ttl=2h
# }

export VAULT_SKIP_VERIFY=true
openshift_systemaccount_and_policy_for_vault
vault_enable_kubernets_auth
# vault_create_sample_policy_and_role

