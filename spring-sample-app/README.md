# mikrotjanst-chassi-rest-intern
Mikrotjänstchassi för OCP interna applikationer som erbjuder ett HTTP API


## Bakgrund
TODO: lägg till beskrivning

### Setup

```
minishift start
alternativt
oc login https://master.test.ocp.rsv.se:8443 --token=ditttokenfrånwebconsole
```
  
```
oc new-project myproject --admin=developer
oc login -u developer -p developer
```

#### Bygga applikation från ett repo på git.rsv.se

Skapa en `secret` i Openshift:  
```bash
oc secrets new-sshauth github-skv-sshkey --ssh-privatekey=/K/.ssh/id_rsa
```
Länka `builder`-systemkontot med hemligheten:
```bash
oc secrets link builder github-skv-sshkey
```

#### Projetktet myproject

Skapa applikationen från templaten.  
```bash
oc process -f openshift/minishift-application-template.yml -p APP_NAME=app-1 | oc create -f -
mvn -DskipTests=true clean install
oc start-build app-1-binary --follow --from-file=./target/vault-demo-with-postgresql-0.0.1-SNAPSHOT.jar
```


### Test

#### Enkel test med cURL
```bash
oc get routes
curl  http://den-skapade-routen/api
curl  http://den-skapade-routen/actuator/health
curl  http://den-skapade-routen/actuator/prometheus
```

#### Last med Gatling
TODO:
