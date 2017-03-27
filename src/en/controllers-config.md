Title: General configuration options
TODO: Check accuracy of key table
      Make the table more space-efficient. Damn it's bulbous.


# Configuring controllers

A Juju controller is the management node of a Juju cloud environment. It houses
the database and keeps track of all the models in that environment.

Controller configuration consists of a collection of keys and their respective
values. An explanation of how to both view and set these key:value pairs is
provided below. Notable examples are provided at the end.


## Getting and setting values

You can display the current model settings by running the command:

```bash
juju controller-config
```

This will include all the currently set key values - whether they were set
by you, inherited as a default value or dynamically set by Juju. 

A key's value may be set for the current model using the same command:

```bash
juju controller-config auditing-enabled=true
```

It is also possible to specify a list of key-value pairs:
  
```bash
juju controller-config auditing-enabled=true set-numa-control-policy=false
```

!!! Note: Juju does not currently check that the provided key is a valid
setting, so make sure you spell it correctly.

To return a value to the default setting the `--reset` flag is used,
specifying the key names:
  
```bash
juju controller-config --reset auditing-enabled
```

## List of controller keys

The table below lists all the controller keys which may be assigned a value. Some
of these keys deserve further explanation. These are explored in the sections
below the table.

| Key                        | Type   | Default  | Valid values             | Purpose |
|:---------------------------|--------|----------|--------------------------|:---------|
api-port                     | string |          |                          | The port to use for connecting to the API
auditing-enabled             | bool   | false    | false/true               | Set whether auditing will be used. See [additional info below](#auditing).
ca-cert                      | string |          |                          | The full contents of certificate created and used by the controller
controller-uuid              | string |          |                          | The uuid of the controller
set-numa-control-policy      | bool   | false    | false/true               | Set whether... See [additional info below](#numa-control-policy).
state-port                   | string |          |                          | The port to use for connecting to the API

### Auditing

Auditing in a Juju controller is...
It is typically used to...
Valid settings include...

### Numa control policy

Numa control policy sets whether...
It is typically used to...
Valid settings include...
