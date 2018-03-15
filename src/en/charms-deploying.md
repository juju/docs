Title: Deploying applications
TODO: Add 'centos' and 'windows' stuff to series talk
      Review whether Juju should go to the store when pointing to a local dir
        with non-existant charm. It did not for me but the old version of this
        doc said it should.
      Hardcoded: Ubuntu codenames
      Verify MAAS spaces example
      Bug tracking: https://bugs.launchpad.net/juju/+bug/1747998

# Deploying applications

The fundamental purpose of Juju is to deploy and manage software applications
in a way that is fast and easy. All this is done with the help of *charms*,
which are bits of code that contain all the necessary intelligence to do these
things. These charms can exist online (in the
[Charm Store](https://jujucharms.com/store)) or on your local file system
(previously downloaded from the store or written locally).

Charms use the concept of *series* analogous as to how Juju does with Ubuntu
series ('Trusty', 'Xenial', etc). For the most part, this is transparent as
Juju will use the most relevant charm to ensure things "just work". This makes
deploying applications with Juju fun and easy.

The default series can be configured at a model level, see
[Configuring models][models-config] for further details. In the absence of this
setting, the default is to use the series specified by the charm.

## Deploying from the Charm Store

Typically, applications are deployed using the online charms. This ensures that
you get the latest version of the charm. Deploying in this way is
straightforward:

```bash
juju deploy mysql
```

This will create a machine in your chosen backing cloud within which the MySQL
application will be deployed.

Assuming that the Xenial series charm exists and was used above, an equivalent
command is:

```bash
juju deploy cs:xenial/mysql
```

Where 'cs' denotes the Charm Store.

!!! Note:
    A used charm gets cached on the controller's database to minimize network
    traffic for subsequent uses.

### Channels

The charm store offers charms in different stages of development. Such stages
are called *channels*. Some users may want the very latest features, or be part
of a beta test; others may want to only install the most reliable software. The
channels are:

 - **stable**: (default) This is the latest, tested, working stable version of
   the charm.
 - **candidate**: A release candidate. There is high confidence this will work
   fine, but there may be minor bugs.
 - **beta**: A beta testing milestone release.
 - **edge**: The very latest version - expect bugs!

As each new version of a charm is automatically versioned, these channels serve
as pointers to a specific version number. It may be that after time a beta
version becomes a candidate, or a candidate becomes the new stable version.

By default you will get the 'stable' channel, but you can specify a channel
when using the `deploy` command:

```bash
juju deploy mysql --channel <channel_name>
```

In the case of there being no version of the charm specified for that channel,
Juju will fall back to the next 'most stable'; e.g. if you were to specify the
'beta' channel, but no charm version is set for that channel, Juju will try to
deploy from the 'candidate' channel instead, and so on. This means that
whenever you specify a channel, you will always end up with something that best
approximates your choice if it is not available.

See [Upgrading applications][charms-upgrading] for how charm upgrades work.

## Deploying a multi-series charm

Charms can be written to support more than one release of a given operating
system distro, such as the multiple Ubuntu releases shown below. See the
documentation on [Multi-series charms][deploying-multi-series-charms] to learn
more.

## Deploying from a local charm

It is possible to deploy applications using local charms. See
[Deploying charms offline][charms-offline-deploying] for further guidance.

## Configuring at deployment time

Deployed applications usually start with a sane default configuration. However,
for some applications it may be desirable (and quicker) to configure them at
deployment time. This can be done whether a charm is deployed from the Charm
Store or from a local charm. See [Application configuration][charms-config] for
more on this.

## Deploying to specific machines

The Juju operator can specify which machine (or container) an application is to
be deployed to. See
[Deploying to specific machines][deploying-to-specific-machines] for full
coverage of this topic.

## Deploying to spaces

Using spaces (see [Network spaces][network-spaces] for
details), the operator is able to create a more restricted network topology
for applications at deployment time. See
[Deploying to spaces][deploying-to-spaces] for more information.

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

Although we are working to have each application co-locatable without the
danger of conflicting configuration files and network configurations this work
is not yet complete.

While the `add-unit` command supports the `--to` option, you can elect not use
`--to` when doing an "add-unit" to scale out the application on its own node.

```bash
juju add-unit rabbitmq-server
```

This will allow you to save money when you need it by using `--to`, but also
horizontally scale out on dedicated machines when you need to.


<!-- LINKS -->

[models-config]: ./models-config.html
[charms-upgrading]: ./charms-upgrading.html
[charms-offline-deploying]: ./charms-offline-deploying.html
[charms-config]: ./charms-config.html
[network-spaces]: ./network-spaces.html
[deploying-multi-series-charms]: ./charms-deploying-advanced.html#multi--series-charms
[deploying-to-specific-machines]: ./charms-deploying-advanced.html#deploying-to-specific-machines
[deploying-to-spaces]: ./charms-deploying-advanced.html#deploying-to-spaces
