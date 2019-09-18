<!--
Todo:
- Add 'centos' and 'windows' stuff to series talk
- Hardcoded: Ubuntu codenames
- Add complete precedence rules for choosing charm series
-->

The fundamental purpose of Juju is to deploy and manage software applications in a way that is easy and repeatable. All this is done with the help of *charms*, which are bits of code that contain all the necessary intelligence to do these things. Charms can exist online (in the [Charm Store](https://jujucharms.com/store)) or on your local filesystem (previously downloaded from the store or written locally).

This page collects together topics related to deploying applications:

- [Deploying from the Charm Store](#heading--deploying-from-the-charm-store)
- [Deploying from a local charm](#heading--deploying-from-a-local-charm)
- [Relating deployed applications](#heading--relating-deployed-applications)
- [Exposing deployed applications](#heading--exposing-deployed-applications)
- [Specifying a charm series](#heading--specifying-a-charm-series)
- [Deploying a subordinate charm](#heading--deploying-a-subordinate-charm)
- [Deploying a Kubernetes charm](#heading--deploying-a-kubernetes-charm)
- [Deploying from a charm bundle](#heading--deploying-from-a-charm-bundle)
- [Configuring at deployment time](#heading--configuring-at-deployment-time)
- [Deploying to LXD containers](#heading--deploying-to-lxd-containers)
- [Deploying to specific machines](#heading--deploying-to-specific-machines)
- [Deploying to specific availability zones](#heading--deploying-to-specific-availability-zones)
- [Deploying to network spaces](#heading--deploying-to-network-spaces)
- [Scaling out deployed applications](#heading--scaling-out-deployed-applications)
- [Trusting an application](#heading--trusting-an-application)

[note]
Before deploying an application a controller must first be created. See the [Creating a controller](/t/creating-a-controller/1108) page for guidance.
[/note]

<h2 id="heading--deploying-from-the-charm-store">Deploying from the Charm Store</h2>

Typically, applications are deployed using the online charms. This ensures that you get the latest version of the charm. Deploying in this way is straightforward:

``` text
juju deploy mysql
```

This will create a machine in your chosen backing cloud within which the MySQL application will be deployed. However, if there is a machine present that lacks an application then, by default, it will be used instead.

Assuming that the Xenial series charm exists and was used above, an equivalent command is:

``` text
juju deploy cs:xenial/mysql
```

Where 'cs' denotes the Charm Store.

[note]
A used charm gets cached on the controller's database to minimize network traffic for subsequent uses.
[/note]

A custom name, such as 'mysql1', can be assigned to the application by providing an extra argument:

``` text
juju deploy mysql mysql1
```

<h3 id="heading--channels">Channels</h3>

The Charm Store offers charms in different stages of development. Such stages are called *channels*. Some users may want the very latest features, or be part of a beta test; others may want to only install the most reliable software. The channels are:

-   **stable**: (default) This is the latest, tested, working stable version of the charm.
-   **candidate**: A release candidate. There is high confidence this will work fine, but there may be minor bugs.
-   **beta**: A beta testing milestone release.
-   **edge**: The very latest version - expect bugs!

As each new version of a charm is automatically versioned, these channels serve as pointers to a specific version number. It may be that after time a beta version becomes a candidate, or a candidate becomes the new stable version.

The default channel is 'stable', but you can specify a different channel easily. Here, we choose the 'beta' channel:

``` text
juju deploy mysql --channel beta
```

In the case of there being no version of the charm specified for that channel, Juju will fall back to the next 'most stable'; e.g. if you were to specify the 'beta' channel, but no charm version is set for that channel, Juju will try to deploy from the 'candidate' channel instead, and so on. This means that whenever you specify a channel, you will always end up with something that best approximates your choice if it is not available.

See [Upgrading applications](/t/upgrading-applications/1080) for how charm upgrades work.

<h2 id="heading--deploying-from-a-local-charm">Deploying from a local charm</h2>

It is possible to deploy applications using local charms. See [Deploying charms offline](/t/deploying-charms-offline/1069) for further guidance.

<h2 id="heading--relating-deployed-applications">Relating deployed applications</h2>

Many charms work in conjunction with other charms, such as a charm requiring a database that another charm provides. In order to "marry" charms like this a *relation* needs to be set up between them. The [Managing relations](/t/managing-relations/1073) page provides details.

<h2 id="heading--exposing-deployed-applications">Exposing deployed applications</h2>

Once an application is deployed changes need to be made to the backing cloud's firewall to permit network traffic to contact the application. This is done with the `expose` command.

Assuming the 'wordpress' application has been deployed (and a relation has been made to deployed database 'mariadb'), we would expose it in this way:

``` text
juju expose wordpress
```

The below partial output from the `status` command informs us that the 'wordpress' application is currently exposed. In this case it is available via its public address of 54.224.246.234:

``` text
App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mariadb    10.1.36  active      1  mariadb    jujucharms    7  ubuntu  
wordpress           active      1  wordpress  jujucharms    5  ubuntu  exposed

Unit          Workload  Agent  Machine  Public address  Ports   Message
mariadb/0*    active    idle   1        54.147.127.19           ready
wordpress/0*  active    idle   0        54.224.246.234  80/tcp
```

Use the `unexpose` command to undo the changes:

``` text
juju unexpose wordpress
```

<h2 id="heading--specifying-a-charm-series">Specifying a charm series</h2>

Charms generally support more than one series. If the target machine is of a different series it is possible to force a charm to deploy to it. See [Charms and series](/t/deploying-applications-advanced/1061#heading--charms-and-series) to learn more about this subject.

<h2 id="heading--deploying-a-subordinate-charm">Deploying a subordinate charm</h2>

A *subordinate* charm is a charm that augments the functionality of another regular charm, which in this context becomes known as the *principle* charm. When a subordinate charm is deployed no units are created. This happens only once a relation has been established between the principal and the subordinate.

<h2 id="heading--deploying-a-kubernetes-charm">Deploying a Kubernetes charm</h2>

Kubernetes charms (`v.2.5.0`) can be deployed when the backing cloud is a Kubernetes cluster. See page [Using Kubernetes with Juju](/t/using-kubernetes-with-juju/1090) for an overview.

<h2 id="heading--deploying-from-a-charm-bundle">Deploying from a charm bundle</h2>

Complex installations requiring multiple charms can be achieved through the use of a *bundle*. See page [Charm bundles](/t/charm-bundles/1058) for guidance.

<h2 id="heading--configuring-at-deployment-time">Configuring at deployment time</h2>

Deployed applications usually start with a sane default configuration. However, for some applications it may be desirable (and quicker) to configure them at deployment time. This can be done whether a charm is deployed from the Charm Store or from a local charm. See [Configuring applications](/t/configuring-applications/1059) for more on this.

<h2 id="heading--deploying-to-lxd-containers">Deploying to LXD containers</h2>

Applications can be deployed directly to new LXD containers in this way:

``` text
juju deploy etcd --to lxd
```

Here, etcd is deployed to a new container on a new machine.

It is equally possible to deploy to a new container that, in turn, resides on a pre-existing machine (see next section).

<h2 id="heading--deploying-to-specific-machines">Deploying to specific machines</h2>

You can specify which machine (or container) an application is to be deployed to. See [Deploying to specific machines](/t/deploying-applications-advanced/1061#heading--deploying-to-specific-machines) for full coverage of this topic.

<h2 id="heading--deploying-to-specific-availability-zones">Deploying to specific availability zones</h2>

It is possible to dictate what availability zone (or zones) a machine must be installed in. See [Deploying to specific availability zones](/t/deploying-applications-advanced/1061#heading--deploying-to-specific-availability-zones) for details.

<h2 id="heading--deploying-to-network-spaces">Deploying to network spaces</h2>

Using network spaces you can create a more restricted network topology for applications at deployment time. See [Deploying to network spaces](/t/deploying-applications-advanced/1061#heading--deploying-to-network-spaces) for more information.

<h2 id="heading--scaling-out-deployed-applications">Scaling out deployed applications</h2>

A common enterprise requirement, once applications have been running for a while, is the ability to scale out (and scale back) one's infrastructure. Fortunately, this is one of Juju's strengths. The [Scaling applications](/t/scaling-applications/1075) page offers in-depth guidance on the matter.

<h2 id="heading--trusting-an-application">Trusting an application</h2>

Some applications may require access to the backing cloud in order to fulfill their purpose. In such cases, the model's credential must be shared with the application, which can be done at deployment time. See section [Trusting an application with a credential](/t/deploying-applications-advanced/1061#heading--trusting-an-application-with-a-credential) to see how this works.
