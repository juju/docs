(state-scenario)=
# State (Scenario)

> <small> {ref}`Scenario <scenario>` > State </small>


In the context of Scenario, State refers to a monolithic data structure representing all data that is available to a charm at runtime.
Simplifying somewhat, that information can be categorized depending on its source:
- data coming from the juju controller and mediated by hook tools
- data coming from the locally stored unit state (the unit state db)
- data coming from environment variables
- data coming from the workload and mediated by Pebble calls in the case of kubernetes charms

The State encapsulates all these types of data in a unified, immutable data structure.

More in detail, the information contained in State can be summarised as follows: in this table you can find
- the name of the State component 
- its type in Python (and a link to the reference doc, where available)
- the source of the data at runtime for that component, i.e. what part of the charm runtime this data is meant to mock
- whether the data is writeable by the charm during hook execution


| State component  |   type |                                    source                                      |  write |
|------------------|:------|:--------------------------------------------------------------------------------:|------:|
| `config` | Dict         |             **hook tool(s):**                          `config-get`              |     no |
| `relations`| List{ref}`[Relation <10621md>`]      |        **hook tool(s):**                `relation-{ref}`get\|set\|list\|ids]`         | no* |
| `networks`| List[Network]       |             **hook tool(s):**                         `network-get`              |  no |
| `unit_status`| StatusBase         |            **hook tool(s):**                      `status-[get\|set]`            |  yes |
| `app_status`| StatusBase         |            **hook tool(s):**                      `status-[get\|set]`            |  yes |
| `workload_version`| str         |            **hook tool(s):**                      `workload-version-set`            |  yes |
| `leader`| bool         |              **hook tool(s):**                          `is-leader`              |  no |
| `secrets`   | List[[`Secret` <10621md>`]     | **hook tool(s):** `secret-{ref}`get\|set\|grant\|revoke\|add\|ids\|info-get\|remove]` |  yes* |
| `deferred`  | List[[DeferredEvent <10621md>`]     |                             **local unit state db**                              |  yes |
| `stored_state` | List{ref}`[StoredState <10621md>`]   |                             **local unit state db**                              |  yes |
| `model` | Model          |                                   **envvars**                                    |  no |
| `unit_id`    | int    |                                   **envvars**                                    |  no |
| `containers` | List{ref}`[Container <10621md>`]    |                        **(kubernetes only:) Pebble API**                         |  yes |
 
```{note}

All data is readable according to the Juju access control rules: e.g. a follower unit cannot read its leader's unit databag, nor write any databag other than its own.

```

> See more: 
> - [hook tools](https://juju.is/docs/sdk/hook-tool)
> - [pebble](https://juju.is/docs/sdk/pebble)