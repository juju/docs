Title: Charm bundles
TODO:  Check more complex bundles after the release of 2.0
       Add example portraying bundle overlay
table_of_contents: True

# Charm bundles

Although charms can be deployed in isolation, they are typically used alongside
other charms in order to implement more complex solutions, whether it be as
simple as MediaWiki and a database, or as complex as a full OpenStack cloud. A
charm bundle, or just *bundle*, is an encapsulation of such a compound
deployment and includes all the associated relations and configurations that
the deployment requires. A huge plus is that a bundle is installed exactly like
a charm is: with the `deploy` command or via the GUI (see
[Adding bundles with the GUI][charms-bundles-gui]).

## Inside a bundle

A bundle is defined with a file in YAML format and is often called the "bundle
file". Here is a bundle file with "charm definitions" for MySQL and WordPress
with a relation between the two: 

```yaml
series: xenial
description: "A simple WordPress deployment."
applications:
  wordpress:
    charm: "cs:trusty/wordpress-5"
    num_units: 1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to:
      - "0"
  mysql:
    charm: "cs:trusty/mysql-57"
    num_units: 1
    annotations:
      "gui-x": "79.5"
      "gui-y": "-142"
    to:
      - "1"
relations:
  - - "wordpress:db"
    - "mysql:db"
machines:
  "0":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
  "1":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
```

## Deploying bundles

A bundle is deployed just like a regular charm is:

```bash
juju deploy wiki-simple
```

See the [Deploying applications][charms-deploying] page for details on the
`deploy` command.

To get a summary of the deployment steps (without actually deploying) a *dry
run* can be performed:

```bash
juju deploy --dry-run wiki-simple
```

Sample output:

```no-highlight
Located bundle "cs:bundle/wiki-simple-4"
Resolving charm: cs:trusty/mysql-55
Resolving charm: cs:trusty/mediawiki-5
Changes to deploy bundle:
- upload charm cs:mysql-55 for series trusty
- deploy application mysql on trusty using cs:mysql-55
- set annotations for mysql
- upload charm cs:trusty/mediawiki-5 for series trusty
- deploy application wiki on trusty using cs:trusty/mediawiki-5
- set annotations for wiki
- add relation wiki:db - mysql:db
- add unit mysql/0 to new machine 0
- add unit wiki/0 to new machine 1
```

!!! Note:
    The `--dry-run` option works only with bundles, and not with regular
    charms.

You can get the name of a bundle from the [Juju Charm Store][charm-store], just
as you would a charm. There, you can see icons representing each separate
application alongside the bundle's name. This gives you a quick overview of a
bundle's complexity and potential resource requirements.

![Bundle resources in the Charm Store](media/juju2_gui_bundles_store.png)

To get a bundle's name, select a bundle on the store and find the 'command
prompt' icon at the top of the pane. A field will contain the Charm Store URL
for the bundle, which you can also use to deploy:

```bash
juju deploy cs:bundle/wiki-simple-4
```

The `cs` signifies "charm store".

## Configuring bundles

Below we present two ways in which existing bundles can be tweaked for your
environment:

 * Setting charm constraints in a bundle
 * Setting charm configuration options in a bundle

### Setting charm constraints in a bundle

To make a bundle as reusable as possible, it's common to set minimum
constraints for its associated charms, much like you would when deploying
charms from the command line. This is done by including a `constraints` field
to a charm's definition.

For example, to add memory and CPU constraints to the 'mysql' charm:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  constraints:
    mem=2G
    cpu-cores=4
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

Refer to the [Using constraints][charms-constraints] page for in-depth coverage
of constraints.

### Setting charm configuration options in a bundle

When deploying an application, the charm you use will often support or even
require specific configuration options to be set. This is done by including an
`options` field to a charm's definition.

For example, to set the 'flavor' of the MySQL charm to 'percona':

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
creating a new bundle. This section presents the following methods:

 * Overlay bundles
 * Bundle placement directives
 * Machine specifications in a bundle
 * Recycling machines
 * Binding endpoints within a bundle
 * Bundles and charm resources

!!! Note:
    Make sure you've added a brief explanation of what your bundle does within
    the `description` field of your bundle's YAML file. 

### Overlay bundles

The `--overlay` option can be used when you want to use a standard bundle but
keep **model-specific** configuration in a separate file. The overlay files
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

### Bundle placement directives

You can co-locate applications using the placement key `to` in the charm's
definition. When LXD is supported by the backing cloud it is also possible to
isolate charms by including the container format in the placement directive.

For example:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  to:
  - lxd:wordpress/0
  annotations:
    "gui-x": "139"
    "gui-y": "168"
```

This will install the MySQL application into a LXD container on the same
machine as the wordpress/0 unit. You can check the output from `juju status` to
see where each application has been deployed:

```no-highlight
Unit         Workload  Agent       Machine  Public address  Ports  Message
mysql/0      waiting   allocating  0/lxd/0                         waiting for machine
wordpress/0  waiting   allocating  0        10.1.110.193           waiting for machine
```

Alternatively, to install MySQL into a LXD container on machine '1', use the
following syntax:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  to:
  - lxd:1
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
  charm: "cs:trusty/mysql-57"
  num_units: 1
  to:
    - "0"
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
```

This will install the MySQL application on machine '0', which has been assigned
a specific series and a collection of constraints.

You may also specify multiple machines for placing multiple units of an
application. For example:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 2
  to:
    - "0"
    - "1"
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
  "1":
    series: trusty
    constraints: "arch=amd64 cpu-cores=4 cpu-power=500 mem=4096 root-disk=8192"
```

This will install one unit of the MySQL application on machine '0' and the
other on machine '1'. 

The output from `juju status` will show this deployment as follows:

```no-highlight
Unit         Workload  Agent       Machine  Public address  Ports  Message
mysql/0      waiting   allocating  0                               waiting for machine
mysql/1      waiting   allocating  1                               waiting for machine
wordpress/0  waiting   allocating  1                               waiting for machine
```

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
  charm: "cs:trusty/mysql-57"
  num_units: 1
  bindings:
    shared-db: database
    cluster: internal
```

This is equivalent to:

```bash
juju deploy cs:trusty/mysql-57 --bind "shared-db=database cluster=internal"
```

The following connects charm endpoints to specific spaces and includes a
default space, `default-space`, for any interfaces not specified:

```bash
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

Using a bundle file, the above deploy command can be mirrored with the
following:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  bindings:
    "": default-space
    db: db-space
    db-admin: admin-space
```

It is not currently possible to declare a default space in the bundle for all
application endpoints. The workaround is to list all endpoints explicitly.

### Bundles and charm resources

Bundles support charm resources (see [Using resources][developer-resources])
through the use of the `resources` field. For example, consider the following
charm's metadata.yaml file that specifies a resource:

```yaml
name: example-charm
summary: "example charm."
description: This is an example charm.
resources:
  example:
    type: file
    filename: example.zip
    description: "This charm needs example.zip to operate"
```

If this charm were to be used as part of a bundle, it might be desirable to use
a specific revision for the bundle. Revisions are specified in the bundle file
under the charm's field in the `applications` section:

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     example: 1
```

So the charm specifies that it requires a resource called `example` and the
bundle stipulates a revision of '1' of that resource (from the Charm Store).

The `resources` field can also specify a local path to a resource instead:

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     example: "./example.zip"
```

Local paths to resources can be useful, for example, in network restricted
environments where a Juju controller is unable to contact the Charm Store.

## Saving a bundle and next steps

If you have created your own bundle you will need to save it. In order to do
this you will need to use the Juju GUI. See
[Adding bundles with the GUI][charms-bundles-gui-exporting] for instructions.

!!! Note:
    A CLI tool for saving a bundle is currently under development.

Once the bundle is saved you can consider these
[Next steps][authors-charm-store-next-steps].


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
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
