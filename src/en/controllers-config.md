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
api-port                     | integer | 17070    |                          | The port to use for connecting to the API
auditing-enabled             | bool   | false    | false/true               | Sets whether the controller will record auditing information
autocert-dns-name            | string |          |                          | Sets the DNS name of the controller. If a client connects to this name, an official certificate will be automatically requested. Connecting to any other host name will use the usual self-generated certificate.
autocert-url                 | string |          |                          | Sets the URL used to obtain official TLS certificates when a client connects to the API. By default, certificates are obtained from LetsEncrypt. A good value for testing is "https://acme-staging.api.letsencrypt.org/directory".
allow-model-access           | bool   |          |                          | Sets whether the controller will allow users to connect to models they have been authorized for even when they don't have any access rights to the controller itself.
ca-cert                      | string |          |                          | The certificate of the CA that signed the controller's CA certificate, in PEM format
controller-uuid              | string |          |                          | The key for the UUID of the controller
identity-public-key          | string |          |                          | Sets the public key of the identity manager
identity-url                 | string |          |                          | Sets the URL of the identity manager
mongo-memory-profile         | string | low      | low/default              | Sets whether mongo uses the least possible memory or the default mongo memory profile
set-numa-control-policy      | bool   | false    | false/true               | Sets whether numactl is preferred for running processes with a specific NUMA (Non-Uniform Memory Architecture) scheduling or memory placement policy for multiprocessor systems where memory is divided into multiple memory nodes
state-port                   | integer | 37017    |                          | The port to use for mongo connections

