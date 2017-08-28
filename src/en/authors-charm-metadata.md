Title: Charm metadata

# Charm metadata

The only file that must be present in a charm is `metadata.yaml`, in the root
directory. A metadata file must be a valid yaml dictionary, containing at least
the following fields:

  - `name` is the charm name, which is used to form the charm URL.
    - It can only contain `a-z`, `0-9`, and `-`; must start with `a-z`; must not
      end with a `-`; and may only end with digits if the digits are _not_
      directly preceded by a space. Stick with names like `foo` and `foo-bar-baz`
      and you needn't pay further attention to the restrictions.
  - `summary` is a one-line description of the charm.
  - `description` is a long-form description of the charm and its features.
  It will also appear in the juju GUI.
  - `tags` is a descriptive tag that is used to sort the charm in the store.



Here's a valid metadata file:

```yaml
    name: mongodb
    summary: An open-source document database, and the leading NoSQL database
    description: |
      MongoDB is a high-performance, open source, schema-free document- oriented
      data store that's easy to deploy, manage and use. It's network accessible,
      written in C++ and offers the following features:
      - Collection oriented storage
      - easy storage of object-style data
      - Full index support, including on inner objects
      - Query profiling
      - Replication and fail-over support
      - Efficient storage of binary data including large objects (e.g. videos)
      - Auto-sharding for cloud-level scalability (Q209) High performance,
      scalability, and reasonable depth of functionality are the goals for the
      project.
```

With only those fields, a metadata file is valid, but not very useful. Charms
for use in the [Charm Store](https://jujucharms.com/) should always set the
following fields as well, for categorization and display in the GUI:

  - `maintainer` is the name and email address for the main point of contact
  for the development and maintenance of the charm. The maintainer field
  should be in the format `Charm Author Name <author@email>`.

  - `maintainers` is a list of people who maintain the charm. Use the yaml
  sequence format when there are more than one person maintaining the project.

  - `tags` is a list containing one or more of the following:
     - analytics
     - big_data
     - ecommerce
     - openstack
     - cloudfoundry
     - cms
     - social
     - streaming
     - wiki
     - ops
     - backup
     - identity
     - monitoring
     - performance
     - audits
     - security
     - network
     - storage
     - database
     - cache-proxy
     - application_development
     - web_server

In almost all cases, only one tag will be appropriate. The categories help
keep the Charm Store organised.

![Juju Charm Store metadata Listing](./media/authors-metadata-display.png)

- `min-juju-version` Charms can declare the minimum Juju version the code is
compatible with. This is useful when the code uses features introduced in a
specific version of Juju. When supplied this value is the lowest version of
Juju controller that will run the charm.

[Storage](./developer-storage.md) can also be declared in a charm's metadata,
as such:

```yaml
storage:
  data:
    type: filesystem
    description: junk storage
    shared: false # not yet supported, see description below
    read-only: false # not yet supported, see description below
    minimum-size: 100M
    location: /srv/data
```

A metadata file defines the charm's
[relations](./authors-relations.html),
and whether it's designed for deployment as a
[subordinate service](./authors-subordinate-services.html).

  - `subordinate` should be set to true if the charm is a subordinate.
    If omitted, the charm will be presumed not to be subordinate.
  - `provides`, `requires`, and `peers` define the various relations the charm
    will participate in.
  - if the charm is subordinate, it must contain at least one `requires`
    relation with container scope.

`resources` allows you to add blobs that your charm can utilize.

```yaml
resources:
  example:
    type: file # "file" is the only type supported currently
    filename: example.tar.gz
    description: example resource
```

`payloads` allows you to register payloads such as LXD, KVM, and docker with
Juju. This lets the operator better understand the purpose and function of these
payloads on a given machine.

```yaml
payloads:
    monitoring:
        type: docker
    kvm-guest:
        type: kvm
```

`extra-bindings` represents an extra bindable endpoint that is not a relation.
These are useful when you want to have Juju provide distinct addresses for an
application on one or more spaces. For example, adding this section to a YAML
file for an application called "foo":

```yaml
extra-bindings:
  cluster:
  public:
```
Will permit you to deploy the charm using `--bind` to deploy on units that have
access to the "admin-api", "public-api", and "internal-api" spaces with a'
different network interface and address for each binding, using this:

```bash
juju deploy ~/path/to/charm/foo --bind "cluster=admin-api public=public-api internal-api"
```

And running `network-get cluster --primary-address` will return only the
address coming from the "admin-api" space.


Endpoint names are strings and must not match existing relation names from
the Provides, Requires, or Peers metadata sections. The values beside each
endpoint name must be left out (i.e. "foo": &lt;anything&gt; is invalid).

Other available fields are:

  - `series` is a list of series that the charm supports.
     - It can include code names of Ubuntu releases such as 'trusty' or
       'xenial'.
     - It can also include code names for non-Ubuntu series such as 'centos7'.
  - `terms` lists the terms the user must agree to before using the charm.
  - `min-juju-version` the minimum version of Juju this charm is compatible with.

Other field names should be considered to be reserved; please don't use any not
listed above to avoid issues with future versions of Juju.
