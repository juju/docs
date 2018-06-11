Title: Using and Creating Bundles
TODO:  Check more complex bundles after the release of 2.0
       Review required
       Refactor (e.g. advanced usage/information should go in a sub-page)
       Refactor (e.g. using vs creating)
       Add example portraying bundle overlay

# Using and Creating Bundles

*Charms* are seldom deployed in isolation. Even MediaWiki needs to be connected
to a database. Instead, charms are mostly used to model more complex
deployments, potentially including many different applications and connections.
A *Bundle* is an encapsulation of this model, or an atomic self-contained part
of it. It may be as simple as MediaWiki and a database, or as complex as a full
OpenStack cloud. But a bundle encapsulates all the charms and their
relationships and enables you to install an entire working deployment just as
easily as installing a single charm, whether that's from the
[Juju Charm Store][store] or by importing a previously exported deployment
yourself.

### Adding bundles from the command line

A bundle is deployed exactly like a charm:

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
    The `dry-run` option only works with bundles.

You can get the name of a bundle from the [Juju Charm Store][store], just as
you would a charm. Unlike charms, bundles embed more than a single
application, and you can see icons representing each separate application
alongside a bundle's name. This gives you a quick overview of a bundle's
complexity and potential resource requirements.

![Bundle resources in the Charm Store](media/juju2_gui_bundles_store.png)

To get a bundle's name, select a bundle on the store and find the 'command
prompt' icon at the top of the pane. Alongside this will be a correctly
formatted `bundle` command, including the correct Charm Store URL for the
bundle, which you can also run to deploy your chosen bundle:

```bash
juju deploy cs:bundle/wiki-simple-4
```

## Creating a bundle

A bundle is a set of applications with a specific configuration and their
corresponding relations that can be deployed together in a single step.
Instead of deploying a single application, they can be used to deploy an entire
workload, with working relations and configuration. The use of bundles allows
for easy repeatability and for sharing of complex, multi-application
deployments.

As an example, here is a bundle file with a MySQL application and a WordPress
application with a relation between the two: 

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

## Setting constraints in a bundle

To make your bundle as reusable as possible, it's common to set minimum
constraints against a charmed application, much like you would when deploying
charms from the command line. This is a simple key addition to the application
definition, using the proper constraint key/value pair as outlined on the
[Using constraints][charms-constraints] page.

For example, to add memory and CPU constraints to a charm in a bundle, the
bundle file would have an additional `constraints` field with specific values:

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

## Setting charm configurations options in a bundle

When deploying an application, the charm you use will often support or even
require specific configuration options to be set. These options can be set in
a bundle as a simple key addition to the application definition, using the
configuration key/value pair.
[See the documentation on application configuration][discover-config-options-docs]
to discover which options are available for the different charms.

For example, to set the flavor of the MySQL charm to Percona in a bundle, the
bundle file would have an additional `options` field with specific value:

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

## Overlay bundles

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

## Bundle placement directives

You can co-locate applications using the placement directive key in the bundle.
Much like application constraints, it requires adding the placement key `to` in
the application definition.  Where supported by the cloud provider, it is also
possible to isolate charms by including the container format in the placement
directive. Some clouds support LXD.

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

which will install the MySQL application into an LXD container on the same
machine as the wordpress/0 unit. You can check the output from `juju status` to
see where each application has been deployed:

```no-highlight
Unit         Workload  Agent       Machine  Public address  Ports  Message
mysql/0      waiting   allocating  0/lxd/0                         waiting for machine
wordpress/0  waiting   allocating  0        10.1.110.193           waiting for machine
```

Alternatively, to install the MySQL application into an LXD container on
machine '1', use the following syntax:

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

## Machine specifications in a bundle

Bundles may optionally include a machine specification, which allows you to set
up specific machines and then to place units of your applications on those
machines however you wish.  A machine specification is a YAML object with named
machines (integers are always used for names).  These machines are objects with
three possible fields: `series`, `constraints`, and `annotations`.

Note that the machine spec is optional. Leaving the machine spec out of your bundle
tells Juju to place units on new machines if no placement directives are given.

With machines specified, you can place and co-locate applications onto specific
machines using the placement key to in the application definition. For example:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  to:
    - "0
  annotations:
    "gui-x": "139"
    "gui-y": "168"
machines:
  "0":
    series: trusty
    constraints: "arch=amd64 cpu-cores=1 cpu-power=100 mem=1740 root-disk=8192"
```
which will install the MySQL application on machine 0. You may also specify
multiple machines for placing multiple units of an application. For example:

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
which will install one unit of the MySQL application on machine 0 and the other on
machine 1. 

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
deployment would use existing machines 1 and 2 for bundle machines 1
and 2 but use existing machine 4 for bundle machine 3 and existing
machine 5 for bundle machine 4:

```bash
juju deploy some-bundle --map-machines=existing,3=4,4=5
```

## Binding endpoints within a bundle

You can configure more complex networks using [spaces](./network-spaces.html)
and deploy charms with binding, as described in
[Deploying to spaces](./charms-deploying-advanced.html#deploying-to-network-spaces).
Bindings can also be specified for applications within a bundle. To do so,
add a section to the bundle's YAML file called `bindings`. For example:

```yaml
mysql:
  charm: "cs:trusty/mysql-57"
  num_units: 1
  bindings:
    shared-db: database
    cluster: internal
```

This is the equivalent of deploying with:

```bash
juju deploy cs:trusty/mysql-57 --bind "shared-db=database cluster=internal"
```

These bundles will need to be updated to be more specific about the
bindings required, allowing the operator to specify exactly which charm-defined
endpoints should end up in specific spaces.

The following `deploy` command connects charm endpoints to specific spaces and
includes a default space, `default-space`, for any interfaces not specified:

```bash
juju deploy --bind "default-space db=db-space db-admin=admin-space" mysql
```

Using the `binding` section in the bundle's YAML file, the above deploy
command can be mirrored in bundle format with the following:

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

## Bundles and Charm Resources

Charms can define [resources][charm-resources-docs]; bundles can be used to
constrain those resources to specific revisions or to specify local paths to
those resources. For example, the following charm's metadata.yaml file specifies
a resource:

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

If this charm were to be used as part of a bundle, it might be desirable to
specify a revision that is specific to the bundle. Revisions are specified in
the bundle's YAML file in the corresponding "applications" section.

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     example: 1
```

The `example-charm` charm specifies that it requires a resource called `example`
to operate; the bundle's "applications" section shown above specifies that its
bundle requires, from the charm store, revision 1 of that resource.

The resources section can also specify a local path to a resource:

```yaml
applications:
  example-charm:
   charm: "cs:example-charm"
   series: trusty
   resources:
     example: "./example.zip"
```

Local paths to resources can be useful in network restricted environments where
a Juju controller can not contact the charm store, for example.

## Sharing your Bundle with the Community

After you have tested and deployed your bundle you need to release it to share
it with people, this is covered in the
[charm store documentation][store-docs]. 

Someone will come along and review your bundle for inclusion. If you need to
speak to a human, there are patch pilots in the Juju IRC channel (#juju on
Freenode) who can assist. You can also use the
[Juju mailing list][juju-list].

!!! Note:
    Make sure you've added a brief explanation of what your bundle does within
    the `description` field of your bundle's YAML file. 


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
[store]: https://jujucharms.com/q/?type=bundle
[store-docs]: ./authors-charm-store.md
[juju-list]: https://lists.ubuntu.com/mailman/listinfo/juju
[charms-constraints]: ./charms-constraints.md
[discover-config-options-docs]: ./charms-config.md#discovering-application-configuration-options
[charm-resources-docs]: ./developer-resources.md
