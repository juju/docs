*This page is concerned with using Juju charms offline. See the [Working offline](/t/working-offline/1072) page for background information.*

Clouds that do not enjoy a connection to the internet can nonetheless make use of charms provided that the **client** prepares local copies of them in advance. The client has the ability to point to a local charm during deployment. This passes the charm on to the controller. Recall that, by default, the **controller** manages the access and distribution of charms.

These instructions are concerned strictly with how to obtain local copies of Juju charms. In particular, they do not take into account:

-   how individual charms may be adversely affected when deployed in an offline context. For instance, some charms download files from internet-based sources (e.g. GitHub). In such cases, the charm must be appropriately modified prior to usage.
-   other required cloud ingredients such as operating system (or container) images.

There are also scenarios where the charms are **only** available locally, such as:

-   The charms are newly-written and have not been published online.
-   The charms exist online but they have been customized locally.

<h2 id="heading--maintaining-charms-locally-with-charm-tools">Maintaining charms locally with Charm Tools</h2>

For the situation when the charms are not already available locally, the steps described here involve both the installation of the Charm Tools software and the download of charms from the [Charm Store](https://jujucharms.com). These tasks are to be performed on an internet-connected system prior to being migrated to the internet-deprived network.

<h3 id="heading--installation-and-overview">Installation and overview</h3>

Charm Tools is add-on software that is useful for interacting with local charms. It is primarily meant for charm authors but it is also useful for just downloading charms from the Charm Store.

Local charms originating from the Store require some degree of maintenance (updating). Merely downloading a charm once will allow the charm to get stale. To update a charm, simply overwrite the existing charm directory by downloading it to the same location.

See [Charm Tools](/t/charm-tools/1180) for information on installation as well as for command syntax and general usage.

<h3 id="heading--storing-a-charm-locally">Storing a charm locally</h3>

Storing a charm locally involves downloading the charm to the local filesystem. This is done by means of the Charm Tools `pull` command.

For example, to download the mysql charm and put its files under the `~/charms/mysql` directory:

``` text
charm pull mysql ~/charms/mysql
```

Now that the Charm Tools and the desired charms are available the administrative system can be placed in the offline environment.

<h3 id="heading--deploying-from-a-local-charm">Deploying from a local charm</h3>

After having created a [Juju controller](/t/controllers/1111), deploy from a local charm by supplying the path to the charm's directory when invoking the `juju deploy` command.

To deploy the previously downloaded mysql charm:

```text
juju deploy ~/charms/mysql
```

To deploy vsftpd while specifying the series (you do not have to specify the series if the local charm contains a series declaration):

```text
juju deploy ~/charms/vsftpd --series trusty
```

A default series can be configured at the model level:

```text
juju model-config -m mymodel default-series=trusty
```

[note]
Charms hosted on the Charm Store always have an implied series.
[/note]

See the [Deploying applications](/t/deploying-applications/1062) page for a comprehensive treatment of the `juju deploy` command and [Configuring models](/t/configuring-models/1151) for more details on model level configuration.

The `juju status` command shows how a charm was installed. Below, MySQL was installed from a local charm and PostgreSQL came from the Charm Store:

```text
App         Version  Status  Scale  Charm       Store       Rev  OS      Notes
mysql       5.7.20   active      1  mysql       local       326  ubuntu  
postgresql  9.5.10   active      1  postgresql  jujucharms  164  ubuntu  
```

<h3 id="heading--ignoring-files">Ignoring files</h3>

When deploying a local charm the files comprising the charm need to be uploaded to the controller. This is done by first archiving the charm's directory so that a single file is transported. Some of the files, however, may not need to be sent. Indeed, some files may even cause an error to be thrown. To overcome this, starting in `v.2.5.3`, it is possible to ignore certain files. The idea is based on [gitignore][git-docs-gitignore] files.
 
Juju starts with a [default set][default-ignore-rules] of ignore rules and appends the contents of a possible `.jujuignore` file present in the charm root directory. Take note of the [ignore syntax][syntax-ignore].


<!-- LINKS -->

[git-docs-gitignore]: https://git-scm.com/docs/gitignore
[default-ignore-rules]: https://github.com/juju/charm/blob/v6/charmdir.go#L20-L39
[syntax-ignore]: https://github.com/juju/charm/pull/271/commits/2ed83967f1668fae235d9a4dbb610ee63532f735
