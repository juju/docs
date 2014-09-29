# Charm metadata

The only file that must be present in a charm is `metadata.yaml`, in the root
directory. A metadata file must be a valid yaml dictionary, containing at least
the following fields:

  - `name` is the charm name, which is used to form the charm URL.
    - It must contain only `a-z`, `0-9`, and `-`; must start with `a-z`; must not end
      with a `-`; and may only end with digits if the digits are _not_ directly
      preceded by a space. Stick with names like `foo` and `foo-bar-baz` and you
      needn't pay further attention to the restrictions.
  - `summary` is a one-line description of the charm.
  - `description` is a long-form description of the charm and its features.
  It will also appear in the juju GUI.
  - `tags` is a descriptive tag that is used to sort the charm in the store.



Here's a valid metadata file:

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

With only those fields, a metadata file is valid, but not very useful. Charms
for use in the [Charm Store](https://jujucharms.com/) should always set the
following fields as well, for categorization and display in the GUI:

  - `maintainer` is the name and email address for the main point of contact
  for the development and maintenance of the charm. Or, at least, it should be:
  in frequent practice, it's just a name. Please update your charms as you get
  the opportunity.
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

Finally, a metadata file defines the charm's [relations](./authors-interfaces.html),
and whether it's designed for deployment as a
[subordinate service](./authors-subordinate-services.html).

  - `subordinate` should be set to true if the charm is a subordinate. If omitted, the charm will be presumed not to be subordinate.
  - `provides`, `requires`, and `peers` define the various relations the charm will participate in.
  - if the charm is subordinate, it must contain at least one `requires` relation with container scope.

Other field names should be considered to be reserved; please don't use any not
listed above to avoid issues with future versions of Juju.
