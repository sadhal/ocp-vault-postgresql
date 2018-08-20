#!/bin/bash
set -e
set -o pipefail


echo "Enable username and password as authentication backend for humans communicating with vault."


function vault_enable_userpass_auth {
  echo "Enabling userpass auth backend..."
  vault auth enable userpass
}

vault_enable_userpass_auth

