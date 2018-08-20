path "database/creds/mydb25" {
    capabilities = ["read", "list"]
}
path "secret/mydb25" { 
    capabilities = ["create", "read", "update", "delete", "list"] 
}
path "secret/application" { 
    capabilities = ["create", "read", "update", "delete", "list"]
}
path "sys/leases/renew" {
    capabilities = ["update"] 
}
path "sys/renew/*" {
    capabilities = ["update"] 
}
