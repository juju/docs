Title: Creating and using bundles  

# Creating and using bundles

A bundle is a set of services with a specific configuration and their
corresponding relations that can be deployed together in a single step.
Instead of deploying a single service, they can be used to deploy an entire
workload, with working relations and configuration. The use of bundles allows
for easy repeatability and for sharing of complex, multi-service deployments.

Bundles are defined in text files, called “bundle files” or “deployer files”.
Each file may contain only one bundle.

## Using bundles

A bundle file can be used in two distinct ways. One is to use it locally,
deploying from your computer, which is useful to initially ensure it works and
for experimenting. After you are satisfied with the bundle, you can push it to
Launchpad where it will be available to you and others via the Charm Store.
If you simply want to download some you can
[search the store for bundles](https://jujucharms.com/q/?type=bundle)
too.

### Local import to Juju GUI

The easiest way to import a bundle into the GUI is by dragging the bundle file
from your desktop and dropping it on the GUI canvas.

<iframe style="margin-left: 20%;" class="youtube-player" type="text/html" width="420" height="350" src="//www.youtube.com/embed/oSPB_qjeEsg"></iframe>

A second way to import into the GUI is via the `Import` button on the GUI
masthead. After clicking the button you’ll be prompted to select the bundle
file. Once a file is selected the process is the same as the drag-and-drop
method.

### Local deploy via command-line

A bundle file can be deployed via the command-line interface by using the `juju
quickstart` tool.

The Juju quickstart tool can be installed on Ubuntu versions newer than 14.04 by
running the following command:

```bash
sudo apt-get install juju-quickstart
```

Always perform a "bundle proof" to check for possible errors before using it:

```bash
juju bundle proof ../path-your-bundle-name    # defaults to your current working directory
```

Then you can use the quickstart tool to deploy your bundle:

```bash
juju quickstart bundle.yaml
```


## Creating a bundle

The standard way to create a bundle is via the Juju GUI. When a set of services
are deployed and configured the bundle definition can be saved either by
clicking on the export icon on the Juju GUI masthead or via the keyboard
shortcut “shift-d”. This results in the creation of a file called “bundle.yaml”
that is saved in your “Downloads” directory as defined by your browser.

![Export button in the Juju GU](media/charm_bundles_export-bundle.png)

As an example, here is an environment with a MySQL service and a Wordpress
service with a relation between the two. The exported bundle file contains the
following data:

```yaml
series: trusty
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
support LXC and KVM.

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
as the Juju deployer will fail if a placement specification refers to a machine
other than "0", which is used to represent the bootstrap node.  Leaving the
machine specification out of your bundle tells Juju to place units on new
machines if no placement directives are given.

## Sharing your bundle with the community

Bundles are shared by putting a branch onto Launchpad with specific naming
which will then be pulled into the Charm Store. The branch must be constructed
and named according to the following rules.

1.  The branch name must be structured as:

    `lp:~<your launchpad id>/charms/bundles/<your bundle name>/bundle`

    A concrete example would be:

    `lp:~bac/charms/bundles/wiki/bundle`

1.  Inside the Bazaar branch, the following files are needed: `bundle.yaml`
    and `README.md`

1.  Proof the bundle to make sure it is valid. You can push them to your
    namespace, the Juju Charm store will automatically find your bundle and
    index it in the store. Ensure you are using your correct Launchpad id and a
    unique bundle name:

    ```bash
    juju bundle proof ../bundle-directory
    bzr push lp:~yourusername/charms/bundles/yourbundlename/bundle
    ```

    **Tip:** You should review the configuration options for the charms you are
    planning to use in a bundle, some of them generate passwords for services or
    might need configuration as a separate step. This may or may not be desirable
    for users, so if there are any extra steps required document them in your
    README.md file.

1.  Next file a bug against charms at
    [https://launchpad.net/charms/+filebug](https://launchpad.net/charms/+filebug).

    This is used to track the progress of your charm.

1.  Subscribe the charmers team by clicking "Subscribe someone else" on the right
    side of the launchpad page. This is important as it gets your charm in the
    review queue!

1.  Now you just need to attach your branch to the bug report, go to
    [your code page](https://code.launchpad.net/people/+me), find your branch,
    and click on it. Then click on "Link a bug report", and put in the number
    of the bug you filed.

Someone will come along and review your bundle for inclusion. If you need to
speak to a human, there are patch pilots in the Juju IRC channel (#juju on
Freenode) who can assist. You can also use the
[Juju mailing list](https://lists.ubuntu.com/mailman/listinfo/juju).


## Deploying a bundle from the charm store with the GUI

To deploy a bundle from the Charm Store using the GUI, first find the bundle
you wish to deploy via search or browsing the bundles to the left. To view
bundle details, click on the bundle in the left sidebar; a pane will slide out
containing the bundle details. You can then add the bundle to the canvas by
clicking the button on the upper-right of the pane.

Alternatively, you can add the bundle to the canvas without expanding the
detail pane by dragging the bundle onto the environment.

After the service is on the canvas it is in a ghost state. You should then
configure the service in the service inspector to the right of the screen and
then click the "Deploy" button.
