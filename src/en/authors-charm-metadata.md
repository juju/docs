Title: Charm metadata

# Charm metadata

The only file that must be present in a charm is `metadata.yaml`, in the root
directory. It must be a valid YAML dictionary.

This page covers the various fields that can be included. Some are required and
many are optional.

## Required fields

Every charm should have these fields declared:

  - `name`: The charm name, which is used to form the charm URL.
    - The following criteria are applied:
          - Contains only characters `a-z`, `0-9`, and `-`
          - Must start with `a-z`
          - Must not end with a `-`
          - May only end with digits if the digits are _not_ directly preceded by a space.
    - Simple examples: 'foo' and 'foo-bar-baz'.
  - `summary`: A one-line description of the charm.
  - `description`: A longer description of the charm and its features. It will
    appear in the Juju GUI.

Here's a minimal, but valid, metadata file:

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

## Charm Store fields

Charms destined for the [Charm Store][charm-store] should set the below three
fields:

  - `maintainer`: The name and email address for the main point of contact
  for the development and maintenance of the charm. The maintainer field
  should be in the format `firstname lastname <author@email>`.

  - `maintainers`: A list of people who maintain the charm. Use the YAML
  sequence format if there are multiple people.

  - `tags`: A list of descriptive tags used for organisation purposes in the
    Charm Store. Choose from among the following:

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

## Miscellaneous fields

  - `series`: A list of series that the charm supports.
     - Supports Ubuntu code names (e.g. 'trusty', 'xenial') or CentOS release
       names (e.g. 'centos7').
     - The top-most entry acts as the default series.
  - `terms`: A list of the terms the user must agree to before using the charm.
  - `min-juju-version`: The minimum Juju version running on the controller
    (machine agent) that this charm is compatible with.
  - `provides`, `requires`, and `peers`: Define the charm's
    [relations][authors-relations].
  - `subordinate`: Indicates a
    [subordinate][authors-subordinate] charm (set to 'true'). Such a charm must
    contain at least one `requires` relation with container scope.

## Storage field

The `storage` field is used to declare information related to storage.

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

See developer [Storage][developer-storage] documentation for more information.

## Resources field

The `resources` field allows is used to add blobs that your charm can utilize.

```yaml
resources:
  example:
    type: file # "file" is the only type supported currently
    filename: example.tar.gz
    description: example resource
```

## Payloads field

Payloads provide a means for the charm author to get information from a
deployed charm. This is especially useful in large and complex deployments. For
instance, the author may want to check the status of some element of the
deployment such as a Docker container.

Payloads are defined via the `payloads` field by assigning a class and type. A
class defines the name of the payload and the type describes the nature of the
payload. Both are author-defined and are not validated by Juju.

The most common types of payload are based on Docker, KVM, and LXD.

As an example, below, the following class/type pairs are defined:
'monitoring/docker', 'kvm- guest/kvm', and 'lxd-container/lxd':

```yaml
payloads:
    monitoring:
        type: docker
    kvm-guest:
        type: kvm
    lxd-container:
        type: lxd
```

Payloads can be viewed using [juju list-payloads][list-payloads] and managed
from the charm hook using the following commands:

- payload-register
- payload-unregister
- payload-status-set

See the [Hook tools documentation][hook-payloads] for further details on these
payload commands. 

## Extra-bindings field

The `extra-bindings` field is associated with an extra bindable endpoint that
is not used with relations. These are useful when you want to have Juju provide
distinct addresses for an application on one or more spaces. For example,
adding this field to a YAML file for an application called "foo":

```yaml
extra-bindings:
  cluster:
  public:
```

Will permit you to deploy the charm using `--bind` to deploy on units that have
access to the "admin-api", "public-api", and "internal-api" spaces with a
different network interface and address for each binding, using this:

```bash
juju deploy ~/path/to/charm/foo --bind "cluster=admin-api public=public-api internal-api"
```

And running `network-get cluster --primary-address` will return only the
address coming from the "admin-api" space.

Endpoint names are strings and must not match existing relation names from
the Provides, Requires, or Peers metadata sections. The values beside each
endpoint name must be left out (i.e. "foo": &lt;anything&gt; is invalid).


<!-- LINKS -->

[authors-subordinate]: ./authors-subordinate-applications.md
[authors-relations]: ./authors-relations.md
[charm-store]: https://jujucharms.com/store
[developer-storage]: ./developer-storage.md
[hook-payloads]:./reference-hook-tools.md#payload-status-set
[list-payloads]:./commands.md#list-payloads
