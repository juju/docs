## Motivation

The `mysql` interface is designed to allow communication with a [MySQL](https://mysql.com/) database server, or one of its API-compatible descendants such as [Percona XtraDB Cluster](https://www.percona.com/software/mysql-database/percona-xtradb-cluster). The database server _provides_ the `mysql` interface and database clients _require_ it.



## Relation Data

|Key|Set by|Relation Type|Description| Example Value|
| --- | --- | --- | --- | --- |
| database | provides | app | Database name  | wp_data
| user | provides | app | User account with write access to the database | user
| password | provides | app | Password for user | A$#20kdsh2~!
| host | provides | app | Database hostname | `10.50.0.50`, `mysql_1.example.org`
| port | provides | app | Database port. <br><br>When not set, requirers should default to 3306.  | `5000`
| encoding | requires | app | Text encoding that the provider should create the database with.<br><br> When not set, the provider defaults to `utf-8`. | `latin-1`, `utf-8`

## Conversation

||Partner|Event|
| --- | --- | --- |
| 1 | both | Relation established |
| 2 | requires | relation-set encoding (optional, defaults to utf-8) |
| 3 | provides | relation-set database |
| 3 | provides | relation-set user |
| 3 | provides | relation-set password |
| 3 | provides | relation-set host |
| 3 | provides | relation-set port |
| 3 | provides | relation-set slave |

## Typical endpoint names

provides

* `db`

requires

* `mysql`
* `db`


## Links

* [`juju-relation-mysql`](https://github.com/johnsca/juju-relation-mysql/) code repository
* [charms requiring `mysql` ](https://jaas.ai/search?requires=mysql)
* [charms providing `mysql` ](https://jaas.ai/search?provides=mysql)
