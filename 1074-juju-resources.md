<!--
Todo:
- Critical: Improve examples
-->

A Juju *resource* is additional content/files that a charm can make use of or may require in order to run.

There are three ways to examine resources:

1. Charm resources
1. Application resources
1. Unit resources

Each of these will be explained in turn.

Also see [Developer resources](/t/using-resources-developer-guide/1127) in the Charm writing guide.

<h2 id="heading--charm-resources">Charm resources</h2>

These are resources that the charm is defined with. They can be listed with the `charm-resources` command. This will query the Charm Store by examining the `metadata.yaml` file of the specified charm. The charm therefore does not need to have been deployed in order to run the command. A controller is also not strictly required but may be necessary in the case of private charms where credentials need to be added for authentication.

For example, to show the resources of the postgresql charm:

``` text
juju charm-resources postgresql
```

Sample output:

``` text
Resource  Revision
wal-e     0
```

<h2 id="heading--application-resources">Application resources</h2>

These are resources that a deployed application is currently using across all its units and are discoverable with the `resources` command. In contrast to the `charm-resources` command, this command needs a controller (that it queries) as well as a deployed charm.

For example, to show the resources of the postgresql application:

``` text
juju resources postgresql
```

Sample output:

``` text
[Service]
Resource  Supplied by  Revision
wal-e     charmstore   0
```

An application gains resources, typically by a charm developer, via the `attach-resource` command:

``` text
juju attach-resource postgresql wal-e=/home/ubuntu/resources/wal-e-upgrade.snap
```

Where the charm's `metadata.yaml` file contains the following stanza:

``` text
"resources":
  "wal-e":
    "type": "file"
    "filename": "wal-e.snap"
    "description": "WAL-E Snap Package"
```

<h2 id="heading--unit-resources">Unit resources</h2>

These are the resources that an individual unit (of an application) is currently using.

For example, to list the resources of unit 'postgresql/0':

``` text
juju resources postgresql/0
```

Sample output:

``` text
No resources to display.
```

Above we see the case where there is an absence of active resources at the unit level.

<!-- LINKS -->
