#!/bin/bash
set -e
set -o pipefail


echo "Run following command only if vault is not initialized!"
echo ""
echo "vault operator init -key-shares=1 -key-threshold=1"

echo "Take note of generated key and root token and export them as environment variables to unseal the vault."
echo "export KEYS=..."
echo "export ROOT_TOKEN=..."
