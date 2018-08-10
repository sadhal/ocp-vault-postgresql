# Work with remote database


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [Work with remote database](#work-with-remote-database)
	* [Enable port-forward on minishift](#enable-port-forward-on-minishift)
	* [Login to Vault](#login-to-vault)
	* [Generate credentials for postgresql](#generate-credentials-for-postgresql)
	* [Connect to postgresql using your client|cli](#connect-to-postgresql-using-your-clientcli)

<!-- /code_chunk_output -->


## Enable port-forward on minishift
In order to connect to our deployed postgresql database you should run following command in one terminal for the duration of test:
```bash
oc port-forward mydb1-1-kgwnc 5432:5432
```

## Login to Vault
As a developer, operator, security officer...  
I want to login to credential store using username/password (or some other enabled authentication backend like LDAP)
```bash
export VAULT_ADDR="https://$(oc get route vault -n secret-management -o jsonpath={.spec.host} --as=admin)"
export VAULT_SKIP_VERIFY=true
vault login -method="userpass" username="..."
```

## Generate credentials for postgresql
Read credentials from Vault. They are valid for 5 minutes (if ttl is not changed).  
```bash
vault read database/creds/mydb1
Key                Value
---                -----
lease_id           database/creds/mydb1/0919b0c2-5875-995c-5738-4173cbcca933
lease_duration     5m
lease_renewable    true
password           A1a-1rUzLBdhNjl7lU9R
username           v-userpass-mydb1-kxkqS8D8VULlLTrI9J3L-1533906891
```

## Connect to postgresql
### CLI
CLI how-to available at: https://blog.openshift.com/openshift-connecting-database-using-port-forwarding/

### Sequeler (client for linux)
![sequeler-new-connection](/assets/sequeler-new-connection.png)
<!-- pagebreak -->

![sequeler-orders-table](/assets/sequeler-orders-table.png)
