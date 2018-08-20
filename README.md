# Vault integration with OpenShift and Spring Cloud

This repository demonstrates how to deploy HashiCorps Vault on OpenShift and leverage service accounts with Spring Cloud to claim database credentials dynamically from the Vault.
This work is inspired by the work of [natronq](https://github.com/natronq/openshift-vault) and [Openshift crew](https://blog.openshift.com/vault-integration-using-kubernetes-authentication-method/).


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [Vault integration with OpenShift and Spring Cloud](#vault-integration-with-openshift-and-spring-cloud)
	* [Getting started](#getting-started)

<!-- /code_chunk_output -->



## Getting started

1. As admin, setup Vault and Openshift by running commands named `admin-once-step-*`. Make sure to export env vars as recommended by script output.

    ```bash
    $ ./admin-once-step-1-deploy-vault.sh
    $ ./admin-once-step-2-init-vault.sh    ## I recommend to save output in a file for later use if necessary
    $ ./admin-once-step-3-unseal-vault.sh  ## I recommend to save output in a file for later use if necessary
    $ ./admin-once-step-4-kubernetes-auth.sh
    $ ./admin-once-step-5-enable-database.sh
    $ ./admin-once-step-6-enable-userpass-auth.sh
    ```

2. As admin, run scripts that should be used for repeatable tasks.

    ```bash
    $ dbname=mydb1                     ## name of your spring application and database
    $ ocpnamespace=spring-app-1        ## name of ocp project where your app will be deployed
    $ developer=sadmir                 ## userid of developer allowed to credentials
    $ ./admin-repeatable-step-1-login-vault.sh
    $ ./admin-repeatable-step-2-create-db.sh $dbname
    $ ./admin-repeatable-step-3-write-config-for-postgresql-in-vault.sh $dbname
    $ ./admin-repeatable-step-4-create-policy-and-auth-for-new-app.sh $dbname $ocpnamespace
    $ ./admin-repeatable-step-5-create-policy-and-auth-for-dev.sh $dbname $developer
    ```

3. As developer, deploy sample application, scale out and in to verify creation of short lived psql credentials and revoking of them.  
   Revoking of db credentials should be denied, see vault audit log. Try to change policy to enable permission for revoking of db credentials?

    ```bash
    $ ./dev-deploy-app.sh $dbname $ocpnamespace
    ```

4. Test the integration with simple end-to-end test

    ```bash
    $ ./test.sh
    ```

5. Test the integration manually

    Follow instructions in [dev-test.md](dev-test.md) for manual tests.