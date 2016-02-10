Title: Deploying services  

# Deploying Services

The fundamental point of Juju is that you can use it to deploy services through
the use of charms (the magic bits of code that make things just work). These
charms can be fetched from the charm store, stored in a local repository, or if
you are feeling clever, written by you. Just as there are different series of
Ubuntu ('precise', 'raring', etc), so there needs to be different series of
charms to take into account any subtle changes in the underlying OS. For the
most part you can forget about this, as Juju will always try to apply the most
relevant charm, so deploying can be straightforward and easy.


# Deploying from the Charm Store

In most cases, you will want to deploy charms by fetching them directly from the
Charm Store. This ensures that you get the relevant, up to date version of the
charm and "everything just works". To deploy a charm like this you can just
specify:

```bash
juju deploy mysql
```

Running this will do exactly what you expect - fetch the latest Juju charm for
the series you are running and then use the bootstrap environment to initiate a
new instance and deploy MySQL

Juju usefully supports a system of namespaces that means you can actually deploy
charms from a variety of sources. The default source is the charm store. The
above command is the same as running:

```bash
juju deploy cs:precise/mysql
```

which follows the format:

```nohighlight
<repository>:<series>/<service>
```


# Deploying from a local repository

There are many cases when you may wish to deploy charms from a local filesytem
source rather than the charm store:

- When testing charms you have written.
- When you have modified store charms for some reason.
- When you don't have direct internet access.

... and probably a lot more times which you can imagine yourselves.

Juju can be pointed at a local directory to source charms from using the
`--repository=<path/to/files>` switch like this:

```bash
juju deploy --repository=/usr/share/charms/ local:trusty/vsftpd
```

The `--repository`: switch can be omitted when shell environment defines
`JUJU_REPOSITORY` like so:

```bash
export JUJU_REPOSITORY=/usr/share/charms/
juju deploy local:trusty/vsftpd
```
You can also make use of standard filesystem shortcuts, if the environment
specifies the `default-series`.The following examples will deploy the trusty
charms in the local repository when default-series is set to trusty:

```bash
juju deploy --repository=. local:haproxy
juju deploy --repository ~/charms/ local:wordpress
```

The default-series can be specified in environments.yaml thusly:

```yaml
default-series: precise
```

The default-series can also be added to any bootstrapped environment with the
`set-env `:

```bash
juju set-env "default-series=trusty"
```

**Note:** Specifying a local repository makes Juju look there **first**, but if the relevant charm is not found in that repository, it will fall back to fetching it from the charm store. If you wish to check where a charm was installed from, it is listed in the `juju status` output.


# Deploying with a configuration file

Deployed services usually start with a sane default configuration. However, for
some services it is desirable (and quicker) to configure them at deployment
time. This can be done by creating a YAML format file of configuration values
and using the `--config=` switch:

```bash
juju deploy mysql --config=myconfig.yaml
```

There is more information on this, and other ways to configure services in the
[documentation for configuring services](./charms-config.html).

!!! Note: After Juju resolves a charm and its dependencies, it bundles them and deploys
them to a machine provider charm cache/repository (e.g. ~/.juju/charmcache).
This allows the same charm to be deployed to multiple machines repeatably and
with minimal network transfers.


# Deploying to specific machines and containers

Juju has native support for specifying which machine a charm should be deployed
to. This is useful for a few reasons. The most obvious reason is to save money
when deploying to a public cloud. Instead of having one machine per unit we can
consolidate services.

In this example we use the `--constraints` flag to fire up a bootstrap node with
4G of RAM so we can deploy other services to it by using the `--to` command:

```bash
juju bootstrap --constraints="mem=4G"
juju deploy --to 0 mysql
juju deploy --to 0 rabbitmq-server
```

As you can see from the example we've deployed mysql and rabbitmq-server "to"
node 0.

You can also deploy to containers:

```bash
juju deploy mysql --to 24/lxc/3
juju deploy mysql --to lxc:25
```

In the previous example we deployed MySQL to container #3 on machine #24.
Similarly the 2nd example deploys MySQL to a new container on machine #25.

The above examples show how to deploy to a machine where you know the machine's
identifier – in all deployments, machine 0 is always the bootstrap node so
the above example works nicely. Doing a `juju status` will show you a list of
all the machines and their machine numbers for you to decide what to deploy to.

It is also possible to deploy units using placement directives as --to arguments.
Placement directives are provider specific. For example:

```bash
juju deploy mysql --to zone=us-east-1a
juju deploy mysql --to host.mass
```
The first example deploys to a specified zone for AWS.
The second example deploys to a named machine in MAAS.

The `add-unit` command also supports the `--to` option, so it's now possible to
specifically target machines when expanding service capacity:

```bash
juju deploy --constraints="mem=4G" openstack-dashboard
juju add-unit --to 1 rabbitmq-server
```

I should now have a second machine running both the openstack-dashboard service
and a second unit of the rabbitmq-server service:

```bash
juju status
```

Which results in the following

```yaml
    machines:
      "0":
        agent-state: started
        agent-version: 1.11.4
        dns-name: 10.5.0.44
        instance-id: 99a06a9b-a9f9-4c4a-bce3-3b87fbc869ee
        series: precise
        hardware: arch=amd64 cpu-cores=2 mem=4096M
      "1":
        agent-state: started
        agent-version: 1.11.4
        dns-name: 10.5.0.45
        instance-id: d1c6788a-d120-44c3-8c55-03aece997fd7
        series: precise
        hardware: arch=amd64 cpu-cores=2 mem=4096M
    services:
      mysql:
        charm: cs:precise/mysql-26
        exposed: false
        relations:
          cluster:
          - mysql
        units:
          mysql/0:
            agent-state: started
            agent-version: 1.11.4
            machine: "0"
            public-address: 10.5.0.44
      openstack-dashboard:
        charm: cs:precise/openstack-dashboard-9
        exposed: false
        relations:
          cluster:
          - openstack-dashboard
        units:
          openstack-dashboard/0:
            agent-state: started
            agent-version: 1.11.4
            machine: "1"
            public-address: 10.5.0.45
      rabbitmq-server:
        charm: cs:precise/rabbitmq-server-12
        exposed: false
        relations:
          cluster:
          - rabbitmq-server
        units:
          rabbitmq-server/0:
            agent-state: started
            agent-version: 1.11.4
            machine: "0"
            public-address: 10.5.0.44
          rabbitmq-server/1:
            agent-state: started
            agent-version: 1.11.4
            machine: "1"
            public-address: 10.5.0.45
```

These two features make it much easier to deploy complex services such as
OpenStack which use a large number of charms on a limited number of physical
servers.

As with deploy, the --to option used with `add-unit` also supports placement
directives. A comma separated list of directives can be provided to cater for 
the case where more than one unit is being added.

```bash
juju add-unit rabbitmq-server -n 4 --to zone=us-west-1a,zone=us-east-1b
juju add-unit rabbitmq-server -n 4 --to host1,host2,host3,host4
```

Any extra placement directives are ignored. If not enough placement directives
are supplied, then the remaining units will be assigned as normal to a new, clean
machine.


## Juju retry-provisioning

You can use the `retry-provisioning` command in cases where deploying services,
adding units, or adding machines fails. It allows you to specify machines which
should be retried to resolve errors reported with `juju status`.

For example, after having deployed 100 units and machines, status reports that
machines 3, 27 and 57 could not be provisioned because of a 'rate limit exceeded'
error. You can ask Juju to retry:

```bash
juju retry-provisioning 3 27 5
```


## Considerations

Charms are running without any separation, so its entirely possible for Charms
to stomp all over each others configuration files and try to bind to the same
network ports. We are working to containerize everything so that this does not
happen and every service is in its own container, but this work is not yet
complete.

While the "add-unit" command supports the `--to` option, you can elect not use
`--to` when doing an "add-unit" to scale out the service on its own node.

```bash
juju add-unit rabbitmq-server
```

This will allow you to save money when you need it by using --to, but also
horizontally scale out on dedicated machines when you need to.


## References and Examples

  - [ Scaling Down in the Cloud with Juju](http://www.jorgecastro.org/2013/07/31/deploying-wordpress-to-the-cloud-with-juju/)
  - [ Targeted Machine Deployment with Juju](http://javacruft.wordpress.com/2013/07/25/juju-put-it-there-please/)


# Selecting and enabling networks

Use the `networks` option to specify service-specific network
requirements. The `networks` option takes a comma-delimited list of
juju-specific network names. Juju will enable the networks on the
machines that host service units. This is different from the network
constraint which selects a machine that matches the networks, but does
not configure the machine to use them. For example, this commands deploys
a service to a machine on the "db" and "monitor" networks and enabled
them:

```bash
juju deploy --networks db,monitor mysql
```

**Note:** The `networks` option only recognises MAAS networks at this
time, and the environment must be bootstrapped with 1.20.0 or newer.
MAAS networks are not detected when Juju is upgraded to 1.20.0 or newer.
