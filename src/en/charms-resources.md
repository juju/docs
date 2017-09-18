Title: Resources
TODO:  Improve examples

# Juju Resources

A Juju *resource* is additional content/files that a charm needs in order to
run.

There are three ways to examine resources:

 1. Charm resources
 1. Application resources
 1. Unit resources

Each of these will be explained below.

Also see [Developer resources][developer-resources] in the Charm developer
guide.

## Charm resources

These are resources that the charm is defined with. They can be listed with the
`charm-resources` command. This will query the Charm Store by examining the
`metadata.yaml` file of the specified charm. The charm therefore does not need
to have been deployed in order to run the command. A controller is also not
strictly required but may be necessary in the case of private charms where
credentials need to be added for authentication.

Example:

```bash
juju charm-resources postgresql
```

Sample output:

```no-highlight
Resource  Revision
wal-e     0
```

## Application resources

These are resources that a deployed application is currently using across all
its units and are discoverable with the `resources` command. In contrast to the
`charm-resources` command, this command needs a controller (that it queries) as
well as deployed charm. An application gains resources via the
`attach-resource` command.

Example:

```bash
juju resources postgresql
```

Sample output:

```no-highlight
[Service]
Resource  Supplied by  Revision
wal-e     charmstore   0
```

Example (with the `--details` option):

```bash
juju resources svc --details
```

Sample output:

```no-highlight
[Units]
Unit  Resource  Revision  Expected
0     wal-e     -         0
```

## Unit resources

These are the resources that an individual unit (of an application) is
currently using.

Example:

```bash
juju resources postgresql/0
```

Sample output:

```no-highlight
No resources to display.
```

Above we see the case where there is an absence of active resources at the unit
level.


<!-- LINKS -->

[developer-resources]: developer-resources.html
