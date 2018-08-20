path "database/creds/mydb25" {
    capabilities = ["read", "list"]
}
path "secret/mydb25" { 
    capabilities = ["read", "list"] 
}
path "sys/leases/renew" {
    capabilities = ["update"] 
}
path "sys/renew/*" {
    capabilities = ["update"] 
}
