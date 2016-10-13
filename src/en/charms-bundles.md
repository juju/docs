Title: Using and Creating Bundles
Todo: Check more complex bundles after the release of 2.0

# Using and Creating Bundles

*Charms* are seldom deployed in isolation. Even
MediaWiki needs to be connected to a database. Instead, charms are mostly used
to model more complex deployments, potentially including many different
applications and connections. A *Bundle* is an encapsulation of this model, or 
an atomic self-contained part of it. It may be as simple as MediaWiki and a
database, or as complex as a full OpenStack cloud. But a bundle
encapsulates all the charms and their relationships and enables you to install
an entire working deployment just as easily as installing a single charm,
whether that's from the [Juju Charm Store][store]
or by importing a previously exported deployment yourself.

### Adding bundles from the command line

Bundles are deployed on the command line exactly like
[Charms](./charms-deploying.html), and use the same `deploy` command and
syntax:

```bash
juju deploy wiki-simple
```

You can get the name of a bundle from the 
[Juju Charm Store][store], just as you would a charm.
Unlike charms, bundles embed more than a single application, and you can
see icons representing each separate application alongside a bundle's name. This
gives you a quick overview of a bundle's complexity and potential resource
requirements.

![Bundle resources in the Charm Store](media/juju2_gui_bundles_store.png)

To get a bundle's name, select a bundle on the store and find the 'command
prompt' icon at the top of the pane. Alongside this will be a correctly
formatted `bundle` command, including the correct Charm Store URL for the
bundle, which you can also run to deploy your chosen bundle:

```bash
juju deploy cs:bundle/wiki-simple-0
```

## Adding bundles with the GUI

Bundles are just as easy to use and deploy within the
Juju GUI, and the process of adding them from the Charm Store is almost
identical to the way you add charms. 

From the GUI, open the Store and select the bundle you're interested in. A new
pane will display a preview of what the GUI's visual overview will look like
with the bundle installed, showing applications and connections. Further details,
such as how a bundle supports scaling, can be found below the preview. Click
'Add to canvas' to simply add the bundle. 

Before clicking on 'Commit changes' to activate your new bundle, review the
configuration of each application by selecting them and making any necessary
changes. Click on 'Commit changes' to review the deployment summary followed by
'Deploy' to set those changes in motion. Alternatively, click on 'Clear
changes' to remove the bundle before it's activated.

### Exporting and Importing bundles with the GUI

From the GUI, you can easily export and re-import the current model as a local
bundle, encapsulating your applications and connections into a single file. To 
do this, click on the 'Export' button, or use the keyboard shortcut “shift-d”.
This results in the creation of a file called `bundle.yaml` that your browser
will typically prompt you to save or open.

![Export button in the Juju GU](media/juju2_gui_bundles_export.png)

You can import a saved bundle by either dragging `bundle.yaml` onto your
browser canvas, or using the 'Import' button. After clicking 'Import' your
browser will prompt you to select a bundle file.

After a file has been added, the GUI will briefly report `ChangeSet process`
followed by `ChangeSet complete`. As with adding bundles from the store, you
may want to review the applications, connections and various configuration 
options before clicking on 'Commit changes' and 'Deploy' to activate your 
bundle.

### Local deploy via command line

After exporting a bundle from the GUI, you can also `deploy` the saved bundle
from the command line: 

```bash
juju deploy bundle.yaml
```
Unlike when you import and deploy a bundle with the Juju GUI, running `juju
deploy` on the command line will not attempt to rename a new application if an
application with the same name already exists.

From the command line, you can also check for errors in a bundle before
deploying it. Bundles downloaded from the Juju store need to be unzipped into
their own directory, and your own `bundle.yaml` files will need to be
accompanied by a `README.md` text file (although this file can be empty for
testing purposes). You can then check for possible errors with the
following command:

```bash
charm proof directory-of-bundle/
```
Note that if no directory is given, the command defaults to the current 
directory.

If no errors are detected, there will be no output from `charm proof` and you
can safely deploy your bundle. 

## Creating a bundle

A bundle is a set of applications with a specific configuration and their
corresponding relations that can be deployed together in a single step.
Instead of deploying a single application, they can be used to deploy an entire
workload, with working relations and configuration. The use of bundles allows
for easy repeatability and for sharing of complex, multi-application deployments.

As an example, here is a bundle file with a MySQL application and a Wordpress
application with a relation between the two: 

```yaml
series: xenial
services:
  wordpress:
    charm: "cs:trusty/wordpress-2"
    num_units: 1
    annotations:
      "gui-x": "339.5"
      "gui-y": "-171"
    to:
      - "0"
  mysql:
    charm: "cs:trusty/mysql-26"
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
definition, using the proper constraint key/value pair as outlined in the
['constraints' documentation][constraints-docs].

For example, to add memory and CPU constraints to a charm in a bundle, the
bundle file would have an additional `constraints` field with specific values:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
  num_units: 1
  constraints:
    - mem=2G
    - cpu-cores=4
  annotations:
      "gui-x": "139"
      "gui-y": "168"
```

## Machine specifications and bundle placement directives

Bundles may optionally include a machine specification, which allows you to set
up specific machines and then to place units of your applications on those machines
however you wish.  A machine specification is a YAML object with named machines
(integers are always used for names).  These machines are objects with three
possible fields: `series`, `constraints`, and `annotations`.

Note that the machine specification is optional.  Leaving the machine spec out
of your bundle tells Juju to place units on new machines if no placement
directives are given.

With machines specified, you can place and co-locate applications onto specific
machines using the placement key `to` in the application definition. For example:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
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

which will install the MySQL application on machine 0. You may also specify
multiple machines for placing multiple units of an application. For example:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
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

which will install one unit of the MySQL application on machine 0 and the other
on machine 1. Where supported by the cloud provider, it is also possible to
isolate charms by including the container format in the placement directive.
Some clouds support LXD. For example:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
  num_units: 1
  to:
    - "lxd:1"
  annotations:
      "gui-x": "139"
      "gui-y": "168"
```
which will install the MySQL application into an LXD container on machine '1'.

## Binding endpoints of applications within a bundle

You can configure more complex networks using [spaces](./network-spaces.html)
and deploy charms with binding, as described in [Deploying applications](./charms-deploying.html).
Bindings can also be specified for applications within a bundle. To do so,
add a section to the bundle's YAML file called `bindings`. For example:

```
...
mysql:
  charm: cs:xenial/mysql-53
  num_units: 1
  constraints: mem=4G
  bindings:
    server: database
    cluster: internal
...
```

This is the equivalent of deploying with:

```bash
juju deploy mysql --bind "server=database cluster=internal"
```

It is not currently possible to declare a default space in the bundle for all
application endpoints. The workaround is to list all endpoints explicitly.


## Sharing your Bundle with the Community

After you have tested and deployed your bundle you need to publish it to share
it with people, this is covered in the
[charm store documentation][store-docs]. 

Someone will come along and review your bundle for inclusion. If you need to
speak to a human, there are patch pilots in the Juju IRC channel (#juju on
Freenode) who can assist. You can also use the
[Juju mailing list][juju-list].


[store]: https://jujucharms.com/q/?type=bundle
[store-docs]: ./authors-charm-store.html
[juju-list]: https://lists.ubuntu.com/mailman/listinfo/juju
[constraints-docs]: ./charms-constraints.html
