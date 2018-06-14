Title: Deploying applications
TODO: Add 'centos' and 'windows' stuff to series talk
      Hardcoded: Ubuntu codenames
      Move commented section to a troubleshooting page

# Deploying applications

The fundamental purpose of Juju is to deploy and manage software applications
in a way that is fast and easy. All this is done with the help of *charms*,
which are bits of code that contain all the necessary intelligence to do these
things. Charms can exist online (in the [Charm Store][charm-store]) or on your
local filesystem (previously downloaded from the store or written locally).

Charms use the concept of *series* analogous as to how Juju does with Ubuntu
series ('Trusty', 'Xenial', etc). For the most part, this is transparent as
Juju will use the most relevant charm to ensure things "just work". The
default series can be configured at a model level, see
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
application will be deployed. However, if there is a machine present that lacks
an application then, by default, it will be used instead.

Assuming that the Xenial series charm exists and was used above, an equivalent
command is:

```bash
juju deploy cs:xenial/mysql
```

Where 'cs' denotes the Charm Store.

!!! Note:
    A used charm gets cached on the controller's database to minimize network
    traffic for subsequent uses.

A custom name, such as 'mysql1', can be assigned to the application by
providing an extra argument:

```bash
juju deploy mysql mysql1
```

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

The default channel is 'stable', but you can specify a different channel
easily. Here, we choose the 'beta' channel:

```bash
juju deploy mysql --channel beta
```

In the case of there being no version of the charm specified for that channel,
Juju will fall back to the next 'most stable'; e.g. if you were to specify the
'beta' channel, but no charm version is set for that channel, Juju will try to
deploy from the 'candidate' channel instead, and so on. This means that
whenever you specify a channel, you will always end up with something that best
approximates your choice if it is not available.

See [Upgrading applications][charms-upgrading] for how charm upgrades work.

## Deploying a multi-series charm

Some charms support more than one series. It is also possible to force a charm
to deploy to a different series. See the documentation on
[Multi-series charms][deploying-multi-series-charms] to learn more.

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

## Deploying to network spaces

Using network spaces the operator is able to create a more restricted network
topology for applications at deployment time. See
[Deploying to network spaces][deploying-to-network-spaces] for more
information.

## Scaling out

A common enterprise requirement, once applications have been running for a
while, is the ability to scale out (and scale back) one's infrastructure.
Fortunately, this is one of Juju's strengths. The
[Scaling applications][charms-scaling] page offers in-depth guidance on the
matter.


<!-- LINKS -->

[charm-store]: https://jujucharms.com/store
[models-config]: ./models-config.html
[charms-upgrading]: ./charms-upgrading.html
[charms-offline-deploying]: ./charms-offline-deploying.html
[charms-config]: ./charms-config.html
[charms-scaling]: ./charms-scaling.html
[network-spaces]: ./network-spaces.html
[deploying-multi-series-charms]: ./charms-deploying-advanced.html#multi--series-charms
[deploying-to-specific-machines]: ./charms-deploying-advanced.html#deploying-to-specific-machines
[deploying-to-network-spaces]: ./charms-deploying-advanced.html#deploying-to-network-spaces
