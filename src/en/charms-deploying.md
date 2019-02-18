Title: Deploying applications
TODO: Add 'centos' and 'windows' stuff to series talk
      Hardcoded: Ubuntu codenames
      Add complete precedence rules for choosing charm series
table_of_contents: True

# Deploying applications

The fundamental purpose of Juju is to deploy and manage software applications
in a way that is easy and repeatable. All this is done with the help of
*charms*, which are bits of code that contain all the necessary intelligence to
do these things. Charms can exist online (in the [Charm Store][charm-store]) or
on your local filesystem (previously downloaded from the store or written
locally).

This page collects together topics related to deploying applications:

 - [Deploying from the Charm Store][#deploying-from-the-charm-store]
 - [Deploying from a local charm][#deploying-from-a-local-charm]
 - [Relating deployed applications][#relating-deployed-applications]
 - [Exposing deployed applications][#exposing-deployed-applications]
 - [Deploying a multi-series charm][#deploying-a-multi-series-charm]
 - [Deploying a subordinate charm][#deploying-a-subordinate-charm]
 - [Deploying a Kubernetes charm][#deploying-a-Kubernetes-charm]
 - [Deploying from a charm bundle][#deploying-from-a-charm-bundle]
 - [Configuring at deployment time][#configuring-at-deployment-time]
 - [Deploying to LXD containers][#deploying-to-lxd-containers]
 - [Deploying to specific machines][#deploying-to-specific-machines]
 - [Deploying to specific availability zones][#deploying-to-specific-availability-zones]
 - [Deploying to network spaces][#deploying-to-network-spaces]
 - [Scaling out deployed applications][#scaling-out-deployed-applications]

!!! Note:
    A requirement for a deployment is that a controller has been created. See
    the [Creating a controller][controllers-creating] page for guidance.

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

The Charm Store offers charms in different stages of development. Such stages
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

## Deploying from a local charm

It is possible to deploy applications using local charms. See
[Deploying charms offline][charms-offline-deploying] for further guidance.

## Relating deployed applications

Many charms work in conjunction with other charms, such as a charm requiring a
database that another charm provides. In order to "marry" charms like this a
*relation* needs to be set up between them. The
[Managing relations][charms-relations] page provides details.

## Exposing deployed applications

Once an application is deployed changes need to be made to the backing cloud's
firewall to permit network traffic to contact the application. This is done
with the `expose` command.

Assuming the 'wordpress' application has been deployed (and a relation has been
made to deployed database 'mariadb'), we would expose it in this way:

```bash
juju expose wordpress
```

The below partial output from the `status` command informs us that the
'wordpress' application is currently exposed. In this case it is available via
its public address of 54.224.246.234:

```no-highlight
App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mariadb    10.1.36  active      1  mariadb    jujucharms    7  ubuntu  
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mariadb/0*    active    idle   1        54.147.127.19           ready
wordpress/0*  active    idle   0        54.224.246.234  80/tcp
```

Use the `unexpose` command to undo the changes:

```bash
juju unexpose wordpress
```

## Deploying a multi-series charm

Some charms support more than one series. It is also possible to force a charm
to deploy to a different series. See the documentation on
[Multi-series charms][deploying-multi-series-charms] to learn more.

## Deploying a subordinate charm

A *subordinate* charm is a charm that augments the functionality of another
regular charm, which in this context becomes known as the *principle* charm.
When a subordinate charm is deployed no units are created. This happens only
once a relation has been established between the principal and the subordinate.

## Deploying a Kubernetes charm

Kubernetes charms (`v.2.5.0`) can be deployed when the backing cloud is a
Kubernetes cluster. See page [Using Kubernetes with Juju][clouds-k8s] for an
overview.

## Deploying from a charm bundle

Complex installations requiring multiple charms can be achieved through the use
of a *bundle*. See page [Charm bundles][charms-bundles] for guidance.

## Configuring at deployment time

Deployed applications usually start with a sane default configuration. However,
for some applications it may be desirable (and quicker) to configure them at
deployment time. This can be done whether a charm is deployed from the Charm
Store or from a local charm. See [Configuring applications][charms-config] for
more on this.

## Deploying to LXD containers

Applications can be deployed directly to new LXD containers in this way:

```bash
juju deploy etcd --to lxd
```

Here, etcd is deployed to a new container on a new machine.

It is equally possible to deploy to a new container that, in turn, resides on a
pre-existing machine (see next section).

## Deploying to specific machines

You can specify which machine (or container) an application is to be deployed
to. See [Deploying to specific machines][deploying-to-specific-machines] for
full coverage of this topic.

## Deploying to specific availability zones

It is possible to dictate what availability zone (or zones) a machine must be
installed in. See
[Deploying to specific availability zones][deploying-to-specific-zones] for
details.

## Deploying to network spaces

Using network spaces you can create a more restricted network topology for
applications at deployment time. See
[Deploying to network spaces][deploying-to-network-spaces] for more
information.

## Scaling out deployed applications

A common enterprise requirement, once applications have been running for a
while, is the ability to scale out (and scale back) one's infrastructure.
Fortunately, this is one of Juju's strengths. The
[Scaling applications][charms-scaling] page offers in-depth guidance on the
matter.


<!-- LINKS -->

[controllers-creating]: ./controllers-creating.md
[charm-store]: https://jujucharms.com/store
[charms-upgrading]: ./charms-upgrading.md
[charms-offline-deploying]: ./charms-offline-deploying.md
[charms-config]: ./charms-config.md
[charms-scaling]: ./charms-scaling.md
[charms-bundles]: ./charms-bundles.md
[charms-relations]: ./charms-relations.md
[clouds-k8s]: ./clouds-k8s.md
[network-spaces]: ./network-spaces.md
[deploying-multi-series-charms]: ./charms-deploying-advanced.md#multi--series-charms
[deploying-to-specific-machines]: ./charms-deploying-advanced.md#deploying-to-specific-machines
[deploying-to-specific-zones]: ./charms-deploying-advanced.md#deploying-to-specific-availability-zones
[deploying-to-network-spaces]: ./charms-deploying-advanced.md#deploying-to-network-spaces

[#deploying-from-the-charm-store]: #deploying-from-the-charm-store
[#deploying-from-a-local-charm]: #deploying-from-a-local-charm
[#relating-deployed-applications]: #relating-deployed-applications
[#exposing-deployed-applications]: #exposing-deployed-applications
[#deploying-a-multi-series-charm]: #deploying-a-multi-series-charm
[#deploying-a-subordinate-charm]: #deploying-a-subordinate-charm
[#deploying-a-Kubernetes-charm]: #deploying-a-Kubernetes-charm
[#deploying-from-a-charm-bundle]: #deploying-from-a-charm-bundle
[#configuring-at-deployment-time]: #configuring-at-deployment-time
[#deploying-to-lxd-containers]: #deploying-to-lxd-containers
[#deploying-to-specific-machines]: #deploying-to-specific-machines
[#deploying-to-specific-availability-zones]: #deploying-to-specific-availability-zones
[#deploying-to-network-spaces]: #deploying-to-network-spaces
[#scaling-out-deployed-applications]: #scaling-out-deployed-applications
