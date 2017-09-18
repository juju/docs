Title: Resources

# Resources

A *resource* is additional content/files that a charm needs in order to run.

Juju has 3 levels of understanding for what a resource is:

 1. Charm resources
 1. Application resources
 1. Unit resources

Each of these will be looked at below.

## Charm resources

These are resources that the charm is defined with. They can be listed with the
`charm-resources` command. This will query the Charm Store by examining the
`metadata.yaml` file of the specified charm. The charm therefore does not need
to have been deployed in order to run the command. A controller is also not
strictly required but may be necessary in the case of private charms where
credentials need to be added for authentication.

Example:

```bash
juju charm-resources cs:a-charm
```

Sample output:

```no-highlight
Resource  Revision
music     1
website   2
```

## Application resources

These are resources that a deployed application is currently using across all
its units and are discoverable with the `resources` command. In contrast to the
`charm-resources` command, this command needs a controller (that it queries) as
well as deployed charm. An application gains resources via the
`attach-resource` command.

Example:

```bash
juju resources svc
```

Sample output:

```no-highlight
[Service]
Resource  Supplied by  Revision
openjdk   charmstore   7
rsc1234   charmstore   15
website   upload       -
website2  Bill User    2012-12-12T12:12

[Updates Available]
Resource  Revision
openjdk   10
```

Example:

```bash
juju resources svc --details
```

Sample output:

```no-highlight
[Units]
Unit  Resource  Revision          Expected
5     alpha     10                15
5     beta      2012-12-12T12:12  2012-12-12T12:12
5     charlie   2011-11-11T11:11  2012-12-12T12:12 (fetching: 2%)
10    alpha     10                15 (fetching: 15%)
10    beta      -                 2012-12-12T12:12
10    charlie   2011-11-11T11:11  2012-12-12T12:12 (fetching: 9%)
```

## Unit resources

These are the resources that an individual unit (of an application) is
currently using.

Example:

```bash
juju resources svc/0
```

Sample output:

```no-highlight
[Unit]
Resource  Revision
rsc1234   15
website2  2012-12-12T12:12
```
