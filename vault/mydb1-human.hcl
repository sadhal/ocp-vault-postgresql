path "database/creds/mydb1" {
    capabilities = ["read", "list"]
}
path "secret/mydb1" { 
    capabilities = ["read", "list"] 
}
path "sys/leases/renew" {
    capabilities = ["update"] 
}
path "sys/renew/*" {
    capabilities = ["update"] 
}
