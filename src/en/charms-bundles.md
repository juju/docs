Title: Charm bundles
TODO:  Give an example of setting up a subordinate

# Charm bundles

Although charms can be deployed in isolation, they are typically used alongside
other charms in order to implement more complex solutions, whether it be as
simple as MediaWiki and a database, or as complex as an OpenStack cloud. A
charm bundle, or just *bundle*, is an encapsulation of such a compound
deployment and includes all the associated relations and configurations that
the deployment requires. A huge plus is that a bundle is installed exactly like
a charm is: with the `deploy` command or via the GUI (see
[Adding bundles with the GUI][charms-bundles-gui]).

The [Bundle reference][reference-bundle] page provides the structure of a
bundle file and defines all its properties.

## Inside a bundle

Here is a simple bundle file that features the MySQL and WordPress applications
with a relation between the two: 

```yaml
description: "A simple WordPress deployment."
series: xenial
applications:
  wordpress:
    charm: "cs:wordpress-5"
    num_units: 1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to: 0
  mysql:
    charm: "cs:mysql-57"
    num_units: 1
    annotations:
      "gui-x": "79.5"
      "gui-y": "-142"
    to: 1
relations:
  - - "wordpress:db"
    - "mysql:db"
machines:
  "0":
    constraints: cores=1 mem=1740 root-disk=8192
  "1":
    constraints: cores=2 mem=2048 root-disk=8192
```

### Kubernetes bundles

A Kubernetes bundle differs from a standard bundle in the following ways:

 - key 'bundle' is given the value of 'kubernetes'
 - key 'num_units' is replaced by key 'scale'
 - key 'to' is replaced by key 'placement'

The value of 'placement' is a key=value pair and is used as a Kubernetes node
selector.

For example:

```no-highlight
bundle: kubernetes
applications:
  mariadb:
    charm: cs:~juju/mariadb-k8s
    scale: 2
    constraints: mem=1G
    options:
        dataset-size: 70%
    storage:
      database: 20M,mariadb-pv
  gitlab:
    charm: cs:~juju/gitlab-k8s
    placement: foo=bar
    scale: 1
relations:
  - - gitlab:mysql
    - mariadb:server
```

## Deploying bundles

A bundle is deployed just like a regular charm is:

```bash
juju deploy wiki-simple
```

See the [Deploying applications][charms-deploying] page for details on the
`deploy` command.

To get a summary of the deployment steps (without actually deploying) a dry
run can be performed:

```bash
juju deploy --dry-run wiki-simple
```

!!! Note:
    The `--dry-run` option works only with bundles, not with regular charms.

You can get the name of a bundle from the [Juju Charm Store][charm-store], just
as you would a charm. There, you can see icons representing each separate
application alongside the bundle's name. This gives you a quick overview of a
bundle's complexity and potential resource requirements.

![Bundle resources in the Charm Store](https://assets.ubuntu.com/v1/053466a1-juju2_gui_bundles_store.png)

To get a bundle's name, select a bundle on the store and find the 'command
prompt' icon at the top of the pane. A field will contain the Charm Store URL
for the bundle, which you can also use to deploy:

```bash
juju deploy cs:bundle/wiki-simple-4
```

The `cs` signifies "charm store".

Bundles can also be deployed by referring to a local bundle file (if it
exists). We'll see this in the [Creating bundles][#creating-bundles] section.

## Configuring bundles

Below we present two ways in which existing bundles can be customised for your
environment:

 - Setting application constraints
 - Setting application configuration options

### Setting application constraints

To make a bundle as reusable as possible, it's common to set minimum
constraints for its associated charms, much like you would when deploying
charms from the command line. This is done by including a `constraints` field
to a charm's definition.

For example, to add memory and CPU constraints to MySQL:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  constraints: mem=2G cores=4
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

Here we show how to co-locate applications along with constrained LXD
containers on a single machine:

```yaml
applications:
  wordpress:
    charm: "cs:wordpress-5"
    num_units: 1
    constraints: mem=1G cores=1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to: lxd:0
  mysql:
    charm: "cs:mysql-57"
    num_units: 1
    constraints: mem=2G cores=2
    annotations:
      "gui-x": "79.5"
      "gui-y": "-142"
    to: lxd:0
relations:
  - - "wordpress:db"
    - "mysql:db"
machines:
  "0":
    series: xenial
    constraints: "arch=amd64 mem=4G cores=4"
```

Refer to the [Using constraints][charms-constraints] page for in-depth coverage
of constraints.

### Setting application configuration options

When deploying an application, the charm you use will often support or even
require specific configuration options to be set. This is done by including an
`options` field to the application.

For example, to set the "flavor" of MySQL to 'percona':

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  options:
    flavor : percona
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

Values for options and annotations can also be read from a file. For binary
files, such as binary certificates, there is an option to base64-encode the
contents. A file location can be expressed with an absolute or relative (to the
bundle file) path. For example:

```yaml
applications:
  my-app:
    charm: some-charm
    options:
      config: include-file://my-config.yaml
      cert: include-base64://my-cert.crt
```

See section
[Discovering application configuration options][discover-config-options]
to learn about a charm's options.

## Creating bundles

Bundles can continue to be modified to the point that you are effectively
creating a new bundle. This section presents the following topics:

 - Using local charms
 - Overlay bundles
 - Bundle placement directives
 - Machine specifications in a bundle
 - Recycling machines
 - Binding endpoints within a bundle
 - Bundles and charm resources
 - Setting up subordinate charms

### Using local charms

To integrate a local charm into a bundle a local bundle file, say
`bundle.yaml`, will be needed and where the `charm` field points to the
directory of the charm in question. Here is an example:

```yaml
series: xenial
applications:
  mysql:
    charm: "/home/ubuntu/charms/mysql"
    num_units: 1
    constraints: mem=2G cores=4
```

The bundle can then be deployed by using the file as the argument instead of a
bundle name:

```bash
juju deploy bundle.yaml
```

### Overlay bundles

The `--overlay` option can be used when you want to use a standard bundle but
keep model-specific configuration in a separate file. The overlay files
constitute bundles in their own right. The "overlay bundle" can specify new
applications, change values, and also specify the removal of an application in
the base bundle.

An application is removed from the base bundle by defining the application name
in the application section, but omitting any values. Removing an application
also removes all the relations for that application.

If a machines section is specified in an overlay bundle it replaces the
corresponding section of the base bundle. No merging of machine information is
attempted. Multiple overlay bundles can be specified and they are processed in
the order they appear on the command line.

For example:

```bash
juju deploy wiki-simple --overlay ~/model-a/wiki-simple.yaml
```

Tutorial [Using the aws-integrator charm][tutorial-k8s-aws] provides an
example of how an "overlay" is used.

### Bundle placement directives

You can co-locate applications by using the `to` key. When LXD is supported by
the backing cloud it is also possible to isolate charms by including the
container format in the placement directive.

For example:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: ["lxd:wordpress/0"]
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

This will install the MySQL application into a LXD container on the same
machine as the 'wordpress/0' unit.

Alternatively, to install MySQL into a LXD container on machine '1', use the
following syntax:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: ["lxd:1"]
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

### Machine specifications in a bundle

Bundles may optionally include a machine specification, which allows you to set
up specific machines and then to place application units on those machines
however you wish. This is done by including a `machines` field at the root of
the bundle file and then defining machines based on an integer. These machines
are objects with three possible fields: `series`, `constraints`, and
`annotations`. Finally, these machines are referred to in a charm's definition
by using the placement key `to`. For example:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  to: 0
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: arch=amd64 cores=1 mem=1740 root-disk=8192
```

This will install the MySQL application on machine '0', which has been assigned
a specific series and a collection of constraints.

You may also specify multiple machines for placing multiple units of an
application. For example:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 2
  to: 0, 1
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: arch=amd64 cores=1 mem=1740 root-disk=8192
  "1":
    series: trusty
    constraints: arch=amd64 cores=4 mem=4096 root-disk=8192
```

This will install one unit of the MySQL application on machine '0' and the
other on machine '1'. 

### Recycling machines

To have a bundle use a model's existing machines, as opposed to creating new
machines, the `--map-machines=existing` option is used. In addition, to specify
particular machines for the mapping, comma-separated values of the form
'bundle-id=existing-id' can be passed where the bundle-id and the existing-id
refer to top level machine IDs.

For example, consider a bundle whose YAML file is configured with machines 1,
2, 3, and 4, and a model containing machines 1, 2, 3, 4, and 5. The following
deployment would use existing machines 1 and 2 for bundle machines 1 and 2 but
use existing machine 4 for bundle machine 3 and existing machine 5 for bundle
machine 4:

```bash
juju deploy some-bundle --map-machines=existing,3=4,4=5
```

### Binding endpoints within a bundle

Generally, you can configure more complex networks using
[Network spaces][network-spaces] and deploy charms with a binding, as described
in [Deploying to spaces][deploying-to-network-spaces]. However, the same can
also be achieved with a bundle and is done by including a `bindings` field to a
charm's definition. For example:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  bindings:
    shared-db: database
    cluster: internal
```

This is equivalent to:

```bash
juju deploy cs:mysql-57 --bind "shared-db=database cluster=internal"
```

The following connects application endpoints to specific spaces and includes a
default space, `default-space`, for any interfaces not specified:

```bash
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

Using a bundle file, the above deploy command can be mirrored with the
following:

```yaml
mysql:
  charm: "cs:mysql-57"
  num_units: 1
  bindings:
    "": default-space
    db: db-space
    db-admin: admin-space
```

It is not currently possible to declare a default space in the bundle for all
endpoints. The workaround is to list all endpoints explicitly.

### Bundles and charm resources

Bundles support charm resources (see [Using resources][developer-resources])
through the use of the `resources` key. Consider the following charm
`metadata.yaml` file that includes a resource called `pictures`:

```yaml
name: example-charm
summary: "example charm."
description: This is an example charm.
resources:
  pictures:
    type: file
    filename: pictures.zip
    description: "This charm needs pictures.zip to operate"
```

It might be desirable to use a specific resource revision in a bundle:

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     pictures: 1
```

So here we specify a revision of '1' from the Charm Store.

The `resources` key can also specify a local path to a resource instead:

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     pictures: "./pictures.zip"
```

Local resources can be useful in network restricted environments where the
controller is unable to contact the Charm Store.

### Setting up subordinate charms

To set up a subordinate charm simply do not use the placement key `to` and do
not specify any units with the `num_units` key. The vital part with a
subordinate is to create the relation between it and the principle charm under
the `relations` element.

## Comparing a bundle to a model

To compare a model's configuration to that of a bundle the `diff-bundle`
command is used.

Consider, for example, a model that has the below output to the `status`
command:

```no-highlight
Model  Controller  Cloud/Region         Version  SLA          Timestamp
docs   lxd         localhost/localhost  2.5.0    unsupported  05:22:22Z

App        Version  Status   Scale  Charm      Store       Rev  OS      Notes
haproxy             unknown      1  haproxy    jujucharms   46  ubuntu  
mariadb    10.1.37  active       1  mariadb    jujucharms    7  ubuntu  
mediawiki  1.19.14  active       1  mediawiki  jujucharms   19  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports   Message
haproxy/0*    unknown   idle   2        10.86.33.28     80/tcp  
mariadb/0*    active    idle   1        10.86.33.192            ready
mediawiki/0*  active    idle   0        10.86.33.19     80/tcp  Ready

Machine  State    DNS           Inst id        Series  AZ  Message
0        started  10.86.33.19   juju-dbf96b-0  trusty      Running
1        started  10.86.33.192  juju-dbf96b-1  trusty      Running
2        started  10.86.33.28   juju-dbf96b-2  bionic      Running

Relation provider  Requirer              Interface     Type     Message
haproxy:peer       haproxy:peer          haproxy-peer  peer     
mariadb:cluster    mariadb:cluster       mysql-ha      peer     
mariadb:db         mediawiki:db          mysql         regular  
mediawiki:website  haproxy:reverseproxy  http          regular
```

Now say we have a bundle file `bundle.yaml` with these contents:

```yaml
applications:
  mediawiki:
    charm: "cs:mediawiki-5"
    num_units: 1
    options:
      name: Central library
  mysql:
    charm: "cs:mysql-55"
    num_units: 1
    options:
      "binlog-format": MIXED
      "block-size": 5
      "dataset-size": "512M"
      flavor: distro
      "ha-bindiface": eth0
      "ha-mcastport": 5411
      "max-connections": -1
      "preferred-storage-engine": InnoDB
      "query-cache-size": -1
      "query-cache-type": "OFF"
      "rbd-name": mysql1
      "tuning-level": safest
      vip_cidr: 24
      vip_iface: eth0
relations:
  - - "mediawiki:db"
    - "mysql:db"
```

Comparison of the currently active model with the bundle can be achieved in
this way:

```bash
juju diff-bundle bundle.yaml
```

This produces an output of:

```yaml
applications:
  haproxy:
    missing: bundle
  mariadb:
    missing: bundle
  mediawiki:
    charm:
      bundle: cs:mediawiki-5
      model: cs:mediawiki-19
    series:
      bundle: ""
      model: trusty
    options:
      name:
        bundle: Central library
        model: null
  mysql:
    missing: model
machines:
  "0":
    missing: bundle
  "1":
    missing: bundle
  "2":
    missing: bundle
relations:
  bundle-additions:
  - - mediawiki:db
    - mysql:db
  model-additions:
  - - haproxy:reverseproxy
    - mediawiki:website
  - - mariadb:db
    - mediawiki:db
```

This informs us of the differences in terms of applications, machines, and
relations. For instance, compared to the model, the bundle is missing
applications 'haproxy' and 'mariadb', whereas the model is missing 'mysql'.
Both model and bundle utilise the 'mediawiki' application but they differ in
terms of configuration. There are also differences being reported in the
'machines' and 'relations' sections. We'll now focus on the 'machines' section
in order to demonstrate other features of the `diff-bundle` command.

We can extend the bundle by including a bundle overlay. Consider an overlay
bundle file `changes.yaml` with these machine related contents:

```yaml
applications:
  mediawiki:
    to: 2
  mysql:
    to: 3
machines:
  "2":
    series: trusty
    constraints: arch=amd64 cores=1
  "3":
    series: trusty
    constraints: arch=amd64 cores=1
```

Here, by means of the `--overlay` option, we can add this extra information to
the comparison, effectively inflating the configuration of the bundle:

```bash
juju diff-bundle bundle.yaml --overlay changes.yaml
```

This changes the 'machines' section of the output to:

```yaml
machines:
  "0":
    missing: bundle
  "1":
    missing: bundle
  "2":
    series:
      bundle: trusty
      model: bionic
  "3":
    missing: model
```

The initial comparison displayed a lack of all three machines in the bundle. By
adding machines '2' and '3' in the overlay the output now shows machines '0'
and '1' as missing in the bundle, machine '2' differs in configuration, and
machine '3' is missing in the model.

As with the `deploy` command, there is the ability to map machines in the
bundle to those in the model. Below, the addition of `--map-machines=2=0,3=1`
makes, for the sake of the comparison, bundle machines 2 and 3 become model
machines 0 and 1, respectively:

```bash
juju diff-bundle bundle.yaml --overlay changes.yaml --map-machines=2=0,3=1
```

The 'machines' section now becomes:

```yaml
machines:
  "2":
    missing: bundle
```

The bundle shows as only missing machine 2 now, which makes sense.

The target bundle can also reside within the online Charm Store. In that case
you would simply reference the bundle name, such as 'wiki-simple':

```bash
juju diff-bundle wiki-simple
```

## Saving a bundle

If you have created your own bundle you will probably want to save it. This is
done with the `export-bundle` command, which exports a single model
configuration.

For example, to export the currently active model into file `mymodel.yaml`:

```bash
juju export-bundle --filename mymodel.yaml
```

You can also use the Juju GUI to save a bundle. See
[Adding bundles with the GUI][charms-bundles-gui-exporting] for instructions.

Once the bundle is saved you can consider these
[Next steps][authors-charm-store-next-steps].


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
[#creating-bundles]: #creating-bundles
[charm-store]: https://jujucharms.com/q/?type=bundle
[authors-charm-store-next-steps]: ./developer-getting-started.md#next-steps
[juju-list]: https://lists.ubuntu.com/mailman/listinfo/juju
[charms-constraints]: ./charms-constraints.md
[discover-config-options]: ./charms-config.md#discovering-application-configuration-options
[charm-resources-docs]: ./developer-resources.md
[network-spaces]: ./network-spaces.md
[deploying-to-network-spaces]: ./charms-deploying-advanced.md#deploying-to-network-spaces
[developer-resources]: ./developer-resources.md
[charms-bundles-gui]: ./charms-bundles-gui.md
[charms-bundles-gui-exporting]: ./charms-bundles-gui.md#exporting-and-importing-bundles-with-the-GUI
[tutorial-k8s-aws]: ./tutorial-k8s-aws.md
[reference-bundle]: ./reference-bundle.md
