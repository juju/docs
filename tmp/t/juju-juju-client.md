(juju-juju-client)=
# `juju` (Juju client)

<!--HARRY SAYS: THIS DOC IS MISSING A LOT OF DETAIL-->

<!--<a id="client"></a>
## Client

The `juju` executable binary. Command-line client that {ref}`operators <5465md>` interact with. 

The client/server terminology originates from Juju's technical architecture. Running a Juju sub-command, such as `juju status`, involves connecting to a {ref}`controller <5465md>` {ref}`agent <5465md>`.

<a id="juju"></a>
## `juju`

The {ref}`client <5465md>` binary that {ref}`operators <5465md>` interact with on the command line.

-->


> See also:
> - {ref}`How to install and manage the client > `juju` <how-to-install-and-manage-the-client>`
> - {ref}``juju` commands <juju-cli-commands>`
> - {ref}``juju` environment variables <juju-environment-variables>`
<!--
> - {ref}`Credentials <5465md>`
-->


<!--The Juju CLI is the client for bootstrapping Juju controllers, creating Juju models, deploying applications and managing these entities.-->

`juju` is the main CLI {ref}`client <client>` of Juju that you can use to manage Juju controllers, whether as an administrator or as a regular user.

<!--This software connects to Juju controllers and is used to issue commands that deploy and manage application units running on cloud instances.-->

![machine](https://assets.ubuntu.com/v1/865acefc-juju-client-2.png)

**Contents:**

- [Directory](#heading--client-directory)
- [Backward compatibility](#heading--backward-compatibility)
- [Working locally](#heading--working-locally)
- [Environment variables](#heading--environment-variables)
- [Plugins](#heading--plugins)
- [Roadmap and releases](#heading--roadmap-and-releases)

<!--td {border: 1px solid #ccc;}br {mso-data-placement:same-cell;}-->


<a href="#heading--client-directory"><h2 id="heading--client-directory">Directory</h2></a>

The `juju` directory is located, on Ubuntu, at `~/.local/share/juju`.

Aside from things like a credentials YAML file, which you are presumably able to recreate, this directory contains unique files such as Juju's SSH keys, which are necessary to be able to connect to a Juju machine. This location may also be home to resources needed by charms or models.

```{note}

On Microsoft Windows, the directory is in a different place (usually `C:\Users\{username}\AppData\Roaming\Juju`).

```

<a href="#heading--backward-compatibility"><h2 id="heading--backward-compatibility">Backward compatibility</h2></a>

`juju` has been designed to be backward compatible and can talk to older or newer existing controllers if the controller and the client are on the same major version (2.x and 3.x). As such, performing simple commands can be achieved without upgrading the client. At the same time, it is always recommended to be up-to-date with the client and controller where possible.



<a href="#heading--working-locally"><h2 id="heading--working-locally">Working locally</h2></a>

<!-- should cover LXD as well as MicroK8s-->

In the case of the localhost cloud (LXD), the cloud is a local LXD daemon housed within the same system as the Juju client:

![machine](https://assets.ubuntu.com/v1/1f5ba83e-juju-client-3.png)

LXD itself can operate over the network and Juju does support this (`v.2.5.0`).


<a href="#heading--environment-variables"><h2 id="heading--environment-variables">Environment variables</h2></a>

You can also configure the Juju client using various environment variables. For more, see {ref}``juju` environment variables <juju-environment-variables>`.


<a href="#heading--plugins"><h2 id="heading--plugins">Plugins</h2></a>

The Juju client can be extended with plugins. For more, see {ref}`Plugins <plugin>`.

<a href="#heading--roadmap-and-releases"><h2 id="heading--roadmap-and-releases">Roadmap and releases</h2></a>

Each Juju release is accompanied by a set of release notes that highlight the changes and bug fixes for each release. For more, see  {ref}`Roadmap & Releases <roadmap--releases>`.



<!--NOTE: The following paragraphs have been copied here from https://discourse.charmhub.io/t/how-to-manage-the-juju-client/1083 .-->

<!--HARRY SAYS: JUJU SHOULDN'T CARE ABOUT THAT. BETTER DELETE.
<h2 id="heading--client-prerequisites">Client prerequisites</h2>

The Juju client expects that the running client OS is up to date with security updates.  
If the client OS is [Ubuntu](https://ubuntu.com/) then installing `distro-info` via `apt` is advised. `distro-info` provides the client updated supported [Ubuntu releases](https://releases.ubuntu.com/) that Juju doesn't know about when released, but can be run against.

-->


<br>

> <small>**Contributors:** @acsgn , @hpidcock , @tmihoc </small>