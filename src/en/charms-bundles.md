Title: Creating and using bundles  

# Creating and Using Bundles

A Bundle is a set of services with a specific configuration and their
corresponding relations that can be deployed together in a single step.
Instead of deploying a single service, they can be used to deploy an entire
workload, with working relations and configuration. The use of bundles allows
for easy repeatability and for sharing of complex, multi-service deployments.

## Using bundles

Bundles are defined in text files called “bundle files”. Each file may contain
only one bundle and there are two ways of using these files. The first is to 
export a bundle from the Juju GUI. This is as simple as clicking on the `Export`
button and saving the `bundle.yaml` file. With this file, you can easily import
your saved bundle to recreate the same deployments.

The second way of using bundle files is via the [Juju
Charm Store](https://jujucharms.com/q/?type=bundle). Bundles downloaded and installed
via the store have been edited, re-packaged and published as Zip archives.
These can be downloaded and installed manually or within the GUI via the 
'Store' button. 

You can also [publish](authors-charm-store.html) your own bundles via the
Charm Store, which is a great way to share your own deployments with other Juju
users.

## Deploying a bundle from the Charm Store with the GUI

To deploy a bundle from the Charm Store using the GUI, first find the bundle
you wish to deploy either search or by expanding the 'Featured searches' with a
click of the 'Show more' button. You can then select 'Bundles' to list
bundles within their own category. One useful feature of this list is that to
the right of each bundle you'll see icons representing each separate service 
embedded within the bundle, giving you a quick overview of a bundle's
complexity and potential resource requirements.

![Bundle resources in the Charm Store](media/juju2_gui_bundles_store.png)

Select a bundle to see further details; a new pane will display a preview of the
GUI's visual overview, previewing its services and connections. Further details,
such as how the bundle supports scaling, can be found below. Click 'Add to
canvas' to add the bundle. 

Before deploying the bundle, check the configuration of each service by
selecting them, making changes if necessary. Clicking on 'Deploy changes' will
activate your new bundle along with any changes you've made.   

### Local import to Juju GUI

When using the Juju GUI, the easiest way to import a previously exported bundle
is to drag the bundle file, usually called `bundle.yaml`, onto the GUI canvas.

You can also import the file using the 'Import' button located next to 
the 'Commit changes' button in the lower right corner of the GUI. After 
clicking 'Import' you’ll be prompted to select the bundle file. 

Once a file has been added, the GUI will briefly report `ChangeSet process`
followed by `ChangeSet complete`. The 'Commit changes' button will then update 
to show the number of outstanding changes that need to be committed to
activate your new bundle. Click on 'Commit changes' to review the deployment
summary followed by 'Deploy' to set those changes in motion. Alternatively,
click on 'Clear changes' to remove the bundle before it's activated.

### Local deploy via command-line

To check for errors on a bundle before using it, exported `bundle.yaml` files 
will need to be placed within their own directories, alongside a `README.md` 
text file (although this file can be empty for testing purposes). 
Bundles downloaded from the Juju store need to be unzipped into their
own directory too. You can then check for possible errors with the following
command:

```bash
charm proof directory-of-bundle/    # defaults to your current working directory
```

If no errors are detected, there will be no output from `charm proof` and you
can safely deploy your bundle. You can do this from the command-line with the 
`juju deploy` command:

```bash
juju deploy bundle.yaml
```

Unlike when you deploy a bundle via the Juju GUI, running `juju deploy` on the
command-line will not attempt to rename a new service if a service with the same name
already exists.

## Creating a bundle

The standard way to create a bundle is via the Juju GUI. When a set of services
are deployed and configured the bundle definition can be saved either by
clicking on the 'Export' button or via the keyboard shortcut “shift-d”. This 
results in the creation of a file called `bundle.yaml` that your browser will 
typically prompt you to save or open.

![Export button in the Juju GU](media/juju2_gui_bundles_export.png)

As an example, here is an environment with a MySQL service and a Wordpress
service with a relation between the two. The exported bundle file contains the
following data:

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

## Service constraints in a bundle

When defining a service in a bundle, it's common to set minimum constraints
against a charmed service, much like you would when deploying on the command
line. This is a simple key addition to the service definition, using the proper
constraint key/value pair as outlined in the
[Constraints](charms-constraints.html) documentation.

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

## Bundle placement directives

You can co-locate services using the placement directive key in the bundle.
Much like service constraints, it requires adding the placement key `to` in the
service definition.
Where supported by the cloud provider, it is also possible to isolate charms
by including the container format in the placement directive. Some clouds
support LXC.

For example:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
  num_units: 1
  to: lxc:wordpress/0
  annotations:
      "gui-x": "139"
      "gui-y": "168"
```

which will install the mysql service into an LXC container on the same machine
as the wordpress/0 unit. Or:

```yaml
mysql:
  charm: "cs:precise/mysql-27"
  num_units: 1
  to: lxc:1
  annotations:
      "gui-x": "139"
      "gui-y": "168"
```
which will install the mysql service into an LXC container on machine '1'.

## Machine specifications in a bundle

Bundles may optionally include a machine specification, which allows you to set
up specific machines and then to place units of your services on those machines
however you wish.  A machine specification is a YAML object with named machines
(integers are always used for names).  These machines are objects with three
possible fields: `series`, `constraints`, and `annotations`.

Note that the machine spec is optional.  If it is not included, solutions such
as the juju deployer will fail if a placement specification refers to a machine
other than "0", which is used to represent the bootstrap node.  Leaving the
machine specification out of your bundle tells Juju to place units on new
machines if no placement directives are given.

## Sharing your Bundle with the Community

After you have tested and deployed your bundle you need to publish it to share
it with people, this is covered in the
[Charm Store Publishing documentation](authors-charm-store.html). 

Someone will come along and review your bundle for inclusion. If you need to
speak to a human, there are patch pilots in the Juju IRC channel (#juju on
Freenode) who can assist. You can also use the
[Juju mailing list](https://lists.ubuntu.com/mailman/listinfo/juju).


