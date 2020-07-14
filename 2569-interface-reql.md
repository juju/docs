## Motivation

The `reql` interface is designed to allow communication with a [RethinkDB](https://rethinkdb.com/) database server. The database server provides the `reql` interface and database clients consume the `reql` interface.

> **Note:** This interface is a work-in-progress and is being developed for use with [this](https://github.com/katharostech/rethinkdb-charm) RethinkDB charm. The interface will change as we add features and determine best practices.

## Relation Data

|Key|Set by|Relation Type|Description| Example Value|
| --- | --- | --- | --- | --- |
| servers | provides | app | Space separated list of `server:port` | `13.233.556.81:3120 13.233.556.23:5123` |
| user | provides | app | The database user | `admin` |
| password | provides | app |The user password | `adf59305kghd80023kkjfhbubh` |

## Conversation

||Partner|Event|
| --- | --- | --- |
|1|both|Relation established|
|2|provides|relation-set servers|
|2|provides|relation-set user|
|2|provides|relation-set password|

## Example

All of the provided keys are application scoped which means that you have to use the new ( added in [Juju 2.7](https://discourse.jujucharms.com/t/juju-2-7-0-creating-a-new-usability-standard-for-infrastructure-automation/2294?u=zicklag) ) application-level relation get:

    TODO

## Typical endpoint names

provides

* `reql`

requires

* `rethinkdb`
* `reql`


## Links

* [charms requiring `reql` ](https://jaas.ai/search?requires=reql)
* [charms providing `reql` ](https://jaas.ai/search?provides=reql)
