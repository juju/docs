(endpoint)=
# Endpoint

In Juju, an **endpoint** is a struct defined in an {ref}`application <application>`'s {ref}`charm <charm>`'s `metadata.yaml` / (since Charmcraft 2.5) `charmcraft.yaml` consisting of 
- a name (charm-specific), 
- a role (one of `provides`, `requires` = 'can use', or `peers`), and 
- an interface 

whose purpose is to help define a {ref}`relation (integration) <relation-integration>`.

For example, the MySQL application deployed from the `mysql` charm has an endpoint called `mysql` with role `provides` and interface `mysql` and this can be used to form  a {ref}`non-subordinate <5462md>` relation with WordPress. 

> See more: [GitHub | `mysql-operator` > `metadata.yaml`](https://github.com/canonical/mysql-operator/blob/2bd2bcc65590937dab18d1d9b0fe21a445557bb6/metadata.yaml#L35), [Charmhub | `mysql`](https://charmhub.io/mysql/integrations#mysql)

All charms have an implicit (not in their `metadata.yaml` / `charmcraft.yaml`) endpoint with name `juju-info`, role `provides`, and interface `juju-info` which can be used to form {ref}`subordinate <5462md>` relations with subordinate charms that have an explicit endpoint with name `juju-info`, role `requires`, and interface `juju-info` (e.g., [`mysql-router`](https://charmhub.io/mysql-router/integrations#juju-info)).