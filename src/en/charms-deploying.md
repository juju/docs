Title: Deploying applications
TODO: Add 'centos' and 'windows' stuff to series talk
      Downloading charms is shabby. See https://git.io/vwNLI . I therefore
        ommitted the "feature" of specifying a download dir
      Review whether Juju should go to the store when pointing to a local dir
        with non-existant charm. It did not for me but the old version of this
        doc said it should.
      Needs explanation of resources (esp. in the local/offline charms sections).

# Deploying applications

The fundamental point of Juju is that you can use it to deploy applications through
the use of charms (the magic bits of code that make things just work). These
charms can exist in the [Charm Store](https://jujucharms.com/store) or on the
file system (previously downloaded from the store or written locally).

Charms use the concept of *series* analogous as to how Juju does with Ubuntu
series ('trusty', 'xenial', etc). For the most part, this is transparent as
Juju will use the most relevant charm to ensure things "just work". This makes
deploying applications with Juju fun and easy.


## Deploying from the charm store

Typically, applications are deployed using the online charms. This ensures that
you get the latest version of the charm. To deploy in this way:

```bash
juju deploy mysql
```

This will create a machine and use the latest online MySQL charm (for your
default series) to deploy a MySQL application.

!!! Note: The default series can be configured at a model level (see
[Configuring models](./models-config.html)). In the absence of this setting,
the default is to use the series specified by the charm.

Assuming that the Xenial series charm exists and was used above, an equivalent
command is:

```bash
juju deploy cs:xenial/mysql
```

Where 'cs' denotes the charm store.

!!! Note: A used charm gets cached on the controller's database to minimize
network traffic for subsequent uses.

### Channels

The charm store offers charms in different stages of development. Such stages
are called *channels*.

Channels offer a way for charm developers, and the users of charms, to manage
and offer charms at various stages of development. Some users may want the very
latest features, or be part of a beta test; others may want to only install the
most reliable software. The channels are:

 - **stable**: (default) This is the latest, tested, working stable version of the charm.
 - **candidate**: A release candidate. There is high confidence this will work fine, but there may be minor bugs.
 - **beta**: A beta testing milestone release.
 - **edge**: The very latest version - expect bugs!

As each new version of a charm is automatically versioned, these channels serve
as pointers to a specific version number. It may be that after time a beta
version becomes a candidate, or a candidate (hopefully) becomes the new stable
version.

By default you will get the 'stable' channel, but you can specify a channel
when using the `deploy` command:


```bash
juju deploy mysql --channel <channel_name>
```

In the case of there being no version of the charm specified for that
channel, Juju will fall back to the next 'most stable'; e.g. if you were to
specify the 'beta' channel, but no charm version is set for that channel, Juju
will try to deploy from the 'candidate' channel instead, and so on. This means
that whenever you specify a channel, you will always end up with something that
best approximates your choice if it is not available.


#### Charm upgrades

Because the pointer can fluctuate among revisions it is possible that during a
charm upgrade the channel revision is different than the revision of a
currently deployed charm. The following rules apply:

- If a channel revision is older, downgrade the deployed charm to that revision
- If a channel revision is newer, upgrade the deployed charm to that revision

Channels can be specified with the `upgrade-charm` command. For example:

```bash
juju upgrade-charm mysql --channel edge
```


## Deploying a multi-series charm

Charms can be created that support more than one release of a given operating
system distro, such as the multiple Ubuntu releases shown below. It is not
possible to create a charm to support multiple distros, such as one charm for
both Ubuntu and CentOS. Supported series are added to the charm metadata like
this:

```
name: mycharm
summary: "Great software"
description: It works
maintainer: Some One <some.one@example.com>
categories:
   - databases
series:
   - trusty
   - xenial
provides:
   db:
     interface: pgsql
requires:
   syslog:
     interface: syslog
```

The default series for the charm is the first one listed. So, in this example,
to deploy `mycharm` on `trusty`, all you need is:

```bash
juju deploy mycharm
```

You can specify a different series using the `--series` flag:

```bash
juju deploy mycharm --series xenial
```

You can force the charm to deploy using an unsupported series using the
`--force` flag:

```bash
juju deploy mycharm --series yakkety --force
```

Here is a more complete example showing a new machine being added that uses
a different series than is supported by our `mycharm` example and then forcing
the charm to install:

```bash
juju add-machine --series yakkety
Machine 1 added.
juju deploy mycharm --to 1 --force
```

It may be required to use `--force` when upgrading charms. For example, in a
case where an application is initially deployed using a charm that supports
`precise` and `trusty`. If a new version of the charm is released that only
supports `trusty` and `xenial` then it will be allowed to upgrade applications
deployed on `precise`, but only using `--force-series`, like this:

```bash
juju upgrade-charm mycharm --force-series
```


## Deploying from a local charm

To deploy applications using local charms, you may specify the path to the charm
directory.
For example, to deploy vsftpd from a local filesystem:

```bash
juju deploy ~/charms/vsftpd --series trusty
```

Local charms may not have a specific declared series (charms fetched from the
store always have an implied series). You do not have to specify the series
if the charm contains a series declaration, or if you have specified a
default series in the model configuration. For example:

```bash
juju model-config -m mymodel default-series=trusty
```

See [Configuring models](./models-config.html) for more details on model level
configuration.

See [Addendum: local charms](#addendum:-local-charms) below for further
explanation of local charms and how they can be managed.


## Deploying with a configuration file

Deployed applications usually start with a sane default configuration. However,
for some applications it is desirable (and quicker) to configure them at
deployment time. This can be done by creating a YAML format file of
configuration values and using the `--config=` switch:

```bash
juju deploy mysql --config=myconfig.yaml
```

See [application configuration](./charms-config.html) for more on this.


## Deploying to specific machines and containers

It is possible to specify which machine or container an application is to be
deployed to. One notable reason is to reduce costs when using a public cloud;
applications can be consolidated instead of dedicating a machine per application
unit.

Below, the `--constraints` option is used to create an LXD controller with
enough memory for other applications to run. The `--to` option is used to
specify a machine:

```bash
juju bootstrap --constraints="mem=4G" lxd lxd-controller
juju deploy mysql
juju deploy --to 0 rabbitmq-server
```

Here, MySQL is deployed as the first unit (in the 'default' model) and so ends
up on machine '0'. Then Rabbitmq gets deployed to machine '0' as well.

Applications can also be deployed to containers:

```bash
juju deploy mysql --to 24/lxd/3
juju deploy mysql --to lxd:25
```

Above, MySQL is deployed to existing container '3' on machine '24'. Afterwards,
a MySQL application is deployed to a new container on machine '25'.

The above examples show how to deploy to a machine where you know the machine's
identifier. The output to `juju status` will provide this information.

It is also possible to deploy units using placement directives as `--to`
arguments. Placement directives are provider specific. For example:

```bash
juju deploy mysql --to zone=us-east-1a
juju deploy mysql --to host.mass
```

The first example deploys to a specified zone for AWS. The second example
deploys to a named machine in MAAS.

The `add-unit` command also supports the `--to` option, so it's now possible to
specifically target machines when expanding application capacity:

```bash
juju deploy --constraints="mem=4G" openstack-dashboard
juju add-unit --to 1 rabbitmq-server
```

There should now be a second machine running both the openstack-dashboard
application and a second unit of the rabbitmq-server application. The
`juju status` command will show this.

These two features make it much easier to deploy complex applications such as
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
are supplied, then the remaining units will be assigned as normal to a new,
clean machine.


## Deploying to spaces

More complex networks can be configured using spaces.  Spaces group one or more
routable subnets with common ingress and egress rules to give the operator much
better and finer-grained control over all networking aspects of a model and its
application deployments.

See the [How to configure more complex networks using spaces][spaces] for
details on creating and listing spaces.

When deploying a charm or a bundle, you can specify a space using the `--bind`
argument following the `juju deploy` command.

When deploying an application to a target with multiple spaces, the operator
must specify which space to use - ambiguous bindings will result in a
provisioning failure. The following, for example, will deploy the 'mysql'
application to the 'db-space' space:

```bash
juju deploy mysql --bind db-space
```

For finer control, the `--bind` argument can also be used to specify how
specific charm-defined endpoints are connected to specific spaces, including a
default option for any interfaces not specified:

```bash
juju deploy --bind "db:db-space db-admin:admin-space default-space" mysql
```

For information on building bundles with bindings, see [Using and Creating
Bundles][creatingbundles].

Both the `add-machine` and `deploy` commands allow the specification of a
spaces constraint using the `--constraints` argument:

```bash
juju add-machine --constraints spaces=db-space
```

The spaces constraint allows you to select an instance for the new machine or
unit, connected to one or more existing spaces. Both positive and negative
entries are accepted, the latter prefixed by "^", in a comma-delimited list.
For example, given the following:

```
--constraints spaces=db-space,^storage,^dmz,internal
```

Juju will provision instances connected to (with IP addresses on) one of the
subnets of both db-space and internal spaces, and NOT connected to either the storage
or dmz spaces.

For more information regarding constraints in general, see "juju help
constraints" and to learn about `extra-bindings`, which provide a way to
declare an extra bindable endpoint that is not a relation, see [Charm
metadata][metadata].


## Juju retry-provisioning

You can use the `retry-provisioning` command in cases where deploying
applications, adding units, or adding machines fails. It allows you to specify
machines which should be retried to resolve errors reported with `juju status`.

For example, after having deployed 100 units and machines, status reports that
machines '3', '27' and '57' could not be provisioned because of a 'rate limit
exceeded' error. You can ask Juju to retry:

```bash
juju retry-provisioning 3 27 57
```


## Considerations

Although we are working to have each application co-locatable without the danger
of conflicting configuration files and network configurations this work is not
yet complete.

While the `add-unit` command supports the `--to` option, you can elect not use
`--to` when doing an "add-unit" to scale out the application on its own node.

```bash
juju add-unit rabbitmq-server
```

This will allow you to save money when you need it by using `--to`, but also
horizontally scale out on dedicated machines when you need to.


## Selecting and enabling networks

Use the `networks` option to specify application-specific network requirements.
The `networks` option takes a comma-delimited list of Juju-specific network
names.
Juju will enable the networks on the machines that host application units. This
is different from the network constraint which selects a machine that matches
the networks, but does not configure the machine to use them. For example, this
commands deploys an application to a machine on the "db" and "monitor" networks
and enables them:

```bash
juju deploy --networks db,monitor mysql
```


## Addendum: local charms

This is further explanation of offline/local charms.

There are times when it may not be possible to use the charms located in the
official Charm Store. Such cases include:

- The backing cloud may be private and not have internet access.
- The charms may not exist online. They are newly-written charms.
- The charms may exist online but they have been customized locally.

!!! Note: Although this method will ensure that the charms themselves are
available on systems without outside internet access, there is no guarantee
that a charm will work in a disconnected state. Some charms will attempt to pull
code from sources on the internet such as GitHub.

### Using Charm Tools

Charm Tools is a set of tools that can be useful when using locally stored
charms.

See [Charm Tools](./tools-charm-tools.html) for more information.

#### Installation

Users of Ubuntu 14.04 (Trusty) will need to first add a PPA:

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt update
```

Install the software:

```bash
sudo apt install charm-tools
```

#### Usage

Charm commands are called with `charm <subcommand>`.

The command `charm-help` is used to view the available subcommands. Each
subcommand has its own help page, which is accessible by adding either the `-h`
or `--help` option:

```bash
charm add --help
```

When downloading charms, they end up in a directory with the same name as the
charm. It is therefore a good idea to work from a central directory. For
example, to download the MySQL and the WordPress charms:

```bash
mkdir ~/charms
cd ~/charms
charm pull nfs
charm pull vsftpd
```

[spaces]: ./network-spaces.html
[creatingbundles]: ./charms-bundles.html#binding-endpoints-of-applications-within-a-bundle
[metadata]: ./authors-charm-metadata.html
