#!/bin/bash
set -e 
set -o pipefail

echo "Create project for credentials store with name secret-managment..."
oc new-project secret-management

echo "Deploying Vault..."
oc adm policy add-scc-to-user anyuid -z default
oc create configmap vault-config --from-file=vault-config=./vault/vault-config.json
oc create -f ./vault/vault.yml
oc create route reencrypt vault --port=8200 --service=vault

echo "Done deploying vault..."
echo ""
echo "Run following commands __manually!__ in order to setup your shell for rest of commands."
echo ""
echo 'export VAULT_ADDR="https://$(oc get route vault -o jsonpath={.spec.host})"'
echo "export VAULT_SKIP_VERIFY=true"
echo ""
