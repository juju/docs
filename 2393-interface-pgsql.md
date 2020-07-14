## Motivation

Applications often require the ability to store data persistently in relational database tables. The `pgsql` interface provides access to PostgreSQL instances. 

## Relation Data

| Key | Set by | Example values |
|------|-------|------|
| host | provides | `10.10.0.1` |
| port | provides | `5000` | 
| user | provides | `juju_abc` |
| password | provides | `AbCd0123` |
| schema_user | provides | `juju_abc` |
| schema_password | provides | `AbCd0123` |
| state | provides | `standalone` |
| version | provides | `10` | 
| database | requires | `app-db` |
| roles | requires | `comma,seperated,list` |
| extensions | requires | `comma,seperated,list` |

## Conversation

The requires side provides a database name. The provides side provides connection info for connecting to that database. The expectation is that providing charms will create the database and user account from scratch. 

| User | Controller | `postgresql` unit agent | `postgresql` charm code | `other` charm unit agent | `other` charm code | 
|--------|-----------------|------------------|-----------------|--------------|------|----------------|
| `juju relate postgresql:db other` | | |
| | Creates relation record in database |
| |  | Run `hooks/<relation>-relation-joined` | `relation-set version=<version> state=<state>`
| |  | |  | Run `hooks/<relation>-relation-joined` | `relation-set database=<database>`
| |  | Run `hooks/<relation>-relation-changed` | Create `<database> `, `relation-set host=<host> port=<port> user=<user> password=<password>` | | |
| | | | | Run `hooks/<relation>-relation-changed` | Retrieve connection info via `relation-get`, update the application's configuration files | 


<!---
| Step | Partner | Event | 
|-------|---------|---|
| 1 | both      | Relation established
| 2     | provides      | relation-set version
|      | provides      | relation-set state
| 3 | requires | relation-set  database
| 4     | provides      | relation-set host
|      | provides      | relation-set port
|      | provides      | relation-set user
|      | provides      | relation-set password
--->

## Typical endpoint names

provides
- `db` - postgresql
- `db-admin`- postgresql (provides an administrative user) 

requires
- [todo]

## Links
- [charms requiring `pgsql`](https://jaas.ai/search?requires=pgsql)
- [charms providing `pgsql`](https://jaas.ai/search?provides=pgsql)
