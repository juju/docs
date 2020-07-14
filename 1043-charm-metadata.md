The only file that must be present in a charm is `metadata.yaml`, in the root directory. It must be a valid YAML dictionary.

This page covers the various fields that can be included. Some are required and many are optional.

<h2 id="heading--required-fields">Required fields</h2>

Every charm should have these fields declared.

Here's a minimal valid, metadata.yaml file:

``` yaml
name: mongodb
summary: A document database
description: A database that stores JSON-like data. 
```


###  `name`

The charm's name, which is used when `juju deploy` is called.

Charm names must:
  -   Contain only letters (`a-z`),  numbers (`0-9`), and hyphens (`-`)
  -   Start with `a-z`
  -   End with a letter or a number

Examples: 'foo' and 'foo-bar-baz'

### `summary`

A one-line description of the charm.

###  `description`

A longer description of the charm and its features. It will appear in the Juju GUI.

<h2 id="heading--charm-store-fields">Charm Store fields</h2>

Charms destined for the [Charm Store](https://jujucharms.com/store) should set the below three fields:

-   `maintainer`: The name and email address for the main point of contact for the development and maintenance of the charm. The maintainer field should be in the format `firstname lastname <author@email>`.

-   `maintainers`: A list of people who maintain the charm. Use the YAML sequence format if there are multiple people.

-   `tags`: A list of descriptive tags used for organisation purposes in the Charm Store. Choose from among the following:

    -   analytics
    -   big_data
    -   ecommerce
    -   openstack
    -   cloudfoundry
    -   cms
    -   social
    -   streaming
    -   wiki
    -   ops
    -   backup
    -   identity
    -   monitoring
    -   performance
    -   audits
    -   security
    -   network
    -   storage
    -   database
    -   cache-proxy
    -   application_development
    -   web_server

<h2 id="heading--miscellaneous-fields">Miscellaneous fields</h2>

### `display-name`

Displayed in the Charm Store and other user-facing areas.

###  `series`

A list of series that the charm supports. The first element of the list acts as the default series.

| Operating system* | Supported series | 
|---|---|
| Kubernetes | `kubernetes` |
| Ubuntu | `xenial`, `bionic`, `focal` (and other series code names) |
| CentOS | `centos7` |
| openSUSE | `opensuseleap` |
| MS Windows | `win2012`,  `win2012r2`, `win2012hv`, `win2012hvr2`, `win2016`, `win2016hv`, `win2016nano `, `win2019` | 


\* Not all clouds support all operating systems. For best support, use `kubernetes` or an Ubuntu series.

### `terms`

A list of the terms  the user must agree to before using the charm before a deployment will proceed.

###  `min-juju-version`

 The minimum Juju version running on the controller (machine agent) that this charm is compatible with.

## Relation fields

These fields define the charm's [relations](/t/implementing-relations-in-juju-charms/1051).

###  `provides`

Describes the relations that this charm provides for others.

### `requires`

Describes the relations that this charm consumes from other charms. Typically `requires` relations are essential for the correct functioning of the application.

### peers

Allows information to be exchanged between units of the same application. 

### `subordinate`

Indicates a [subordinate](/t/subordinate-applications/1053) charm (when set to 'true'). Subordinate applications must contain at least one `requires` relation with container scope.

<h2 id="heading--storage-field">Storage field</h2>

The `storage` field is used to declare information related to storage.

``` yaml
storage:
  data:
    type: filesystem
    description: junk storage
    shared: false # not yet supported, see description below
    read-only: false # not yet supported, see description below
    minimum-size: 100M
    location: /srv/data
```

See developer [Storage](/t/writing-charms-that-use-storage/1128) documentation for more information.

<h2 id="heading--resources-field">Resources field</h2>

The `resources` field allows one to add blobs that a charm can make use of.

``` yaml
resources:
  example:
    type: file
    filename: example.tar.gz
    description: example resource
  gitlab_image:
    type: oci-image
    description: |
      Image used for gitlab pod. Must use gitlab/gitlab-ce:12.0.12-ce.0 or older
      to use the mysql interface.
```

<h2 id="heading--payloads-field">Payloads field</h2>

Payloads provide a means for the charm author to get information from a deployed charm. This is especially useful in large and complex deployments. For instance, the author may want to check the status of some element of the deployment such as a Docker container.

Payloads are defined via the `payloads` field by assigning a class and type. A class defines the name of the payload and the type describes the nature of the payload. Both are author-defined and are not validated by Juju.

The most common types of payload are based on Docker, KVM, and LXD.

As an example, below, the following class/type pairs are defined: 'monitoring/docker', 'kvm- guest/kvm', and 'lxd-container/lxd':

``` yaml
payloads:
    monitoring:
        type: docker
    kvm-guest:
        type: kvm
    lxd-container:
        type: lxd
```

Payloads can be viewed using [juju list-payloads](./commands.md#list-payloads) and managed from the charm hook using the following commands:

-   payload-register
-   payload-unregister
-   payload-status-set

See the [Hook tools documentation](/t/hook-tools/1163#heading--payload-status-set) for further details on these payload commands.

<h2 id="heading--extra-bindings-field">Extra-bindings field</h2>

The `extra-bindings` field is associated with an extra bindable endpoint that is not used with relations. These are useful when you want to have Juju provide distinct addresses for an application on one or more spaces. For example, adding this field to a YAML file for an application called "foo":

``` yaml
extra-bindings:
  cluster:
  public:
```

Will permit you to deploy the charm using `--bind` to deploy on units that have access to the "admin-api", "public-api", and "internal-api" spaces with a different network interface and address for each binding, using this:

``` text
juju deploy ~/path/to/charm/foo --bind "cluster=admin-api public=public-api internal-api"
```

And running `network-get cluster --primary-address` will return only the address coming from the "admin-api" space.

Endpoint names are strings and must not match existing relation names from the Provides, Requires, or Peers metadata sections. The values beside each endpoint name must be left out (i.e. "foo": &lt;anything&gt; is invalid).

<!-- LINKS -->
