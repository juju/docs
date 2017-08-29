Title: Exposing applications    


# Exposing applications

By design, Juju operates a very secure environment for deploying your
applications. Even if you have deployed applications, they won't be publicly
available unless you explicitly make them so. To allow public access to
applications, the appropriate changes must be made to the cloud provider
firewall settings. As the procedure for doing this varies depending on your
cloud, Juju helpfully abstracts this into a single command,
`juju expose <applicationname>`.

For example, you may have deployed a WordPress application using the relevant
charm. Once deployed, the application still cannot be accessed by the public,
so you would run:

```bash
juju expose wordpress
```

Juju will then take the steps necessary to adjust firewall rules and any other
settings to expose the application via its given address. This process may take
anything from a few moments to several minutes. You can check on the current
status of your applications by running:

```bash
juju status
```

This will return a status report similar to:

<!-- JUJUVERSION: 2.2.2-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status -->
```no-highlight
Model    Controller  Cloud/Region     Version  SLA
default  gce-test    google/us-east1  2.2.2    unsupported

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mariadb    10.1.26  active      1  mariadb    jujucharms    7  ubuntu
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mariadb/0*    active    idle   1        35.196.172.180          ready
wordpress/0*  active    idle   0        35.185.9.71     80/tcp

Machine  State    DNS             Inst id        Series  AZ          Message
0        started  35.185.9.71     juju-a9fb52-0  trusty  us-east1-b  RUNNING
1        started  35.196.172.180  juju-a9fb52-1  trusty  us-east1-c  RUNNING

Relation      Provides   Consumes   Type
cluster       mariadb    mariadb    peer
db            mariadb    wordpress  regular
loadbalancer  wordpress  wordpress  peer
```

As you can see in the above example, the `wordpress` app is marked as 'exposed'
in the Notes column, meaning that the application is running and available to
users via its public address of 104.196.177.186.

!!! Note:
    Exposing the application does not change any DNS or other settings 
    which may be necessary to get your application running as you expect.

# Unexposing an application

To return the firewall settings and make an application non-public again, you
simply need to run the `unexpose` command. For example:

```bash
juju unexpose wordpress
```
