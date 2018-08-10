#!/bin/bash
set -e
set -o pipefail

echo ""
echo "Unseal vault in order to make it operational."
echo "This is usually done once but in case of a breach, vault admin could SEAL vault again to deny access to credential store for __ALL__ clients!"
echo "Make sure to set following env vars:"
echo "export KEYS=..."
echo "export ROOT_TOKEN=..."
echo "Run following command:"
echo "vault operator unseal $KEYS"

echo ""
echo "Login to credentials store (as cred. store owner/operator) using CLI binary:"
echo "vault login $ROOT_TOKEN"
echo ""

echo "Enable audit in vault..."
echo " vault audit enable file file_path=/vault/logs/vault_audit.log"