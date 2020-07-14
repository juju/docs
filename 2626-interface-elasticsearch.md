## Motivation

Elastic Search is an impressive clustered full-text search database with an easy-to-use REST API. Documenting the interface allows API-compatible services to present themselves as Elastic Search to a Juju model. 

## Relation Data

| Key | Set by | Example values |
|------|-------|------|
| cluster-name* | provides | `full-text-search` |
| host | provides | `10.10.0.1`, `app.example.internal` |
| port | provides | `9200` | 

\* Some charms use `cluster_name`. New code should support both variants to maintain backwards compatibility with other charms.

## Conversation

|  | Unit involves | Event | 
|-------|---------|---|
| 1     | both      | Relation established
| 2     | provides      | relation-set cluster-name
| 2     | provides      | relation-set host
| 2     | provides      | relation-set port

## Peer conversation

TODO

## Typical endpoint names

provides
- `elasticsearch`

requires
- `elasticsearch`

## Links
- [charms requiring `elasticsearch`](https://jaas.ai/search?requires=elasticsearch)
- [charms providing `elasticsearch`](https://jaas.ai/search?provides=elasticsearch)
