The mysql interface is provided by the mysql charm, and is required by a number of charms currently in the Charm Store and elsewhere which would like to use or actually require a MySQL database.

<h2 id="heading--hook-implementation-relation-joined">Hook Implementation: relation-joined</h2>

<h3 id="heading--in-theory">In theory</h3>

When the mysql charm is notified of a “relation joined” event, it creates a database. String values are generated for the credentials needed to authenticate a connection to this database: the database name, a username and password. The mysql charm will also check the instance’s hostname and pass that value too, as well as a string containing “True” or “False” to indicate whether this unit is a slave.

A charm joining this relationship will typically have a relationship-joined hook which will wait to see when the mysql charm has set one of the expected values (all values are set simultaneously, so the availability of one indicates that all are available).

A charm joining this relationship may also request that the created database set an encoding. The default encoding is utf8 and so most charms do not need to request a change. To request the created database to use a different encoding, use relation-set in the db-relation-joined hook.

Implementation in `bash`:

```bash
#!/bin/bash
# db-relation-joined example

relation-set encoding=latin1
juju-log "db-relation-joined set encoding=latin1"
```

<h3 id="heading--in-practice">In practice</h3>

Upon relation joined, mysql sets the following:

-   database (string)
-   user (string)
-   password (string)
-   host (string)
-   slave (string)
-   encoding (optional string)

The corresponding `relation-joined` hook in any charm connecting to the mysql charm should fetch any or all of these values.

<h3 id="heading--reference-examples">Reference examples:</h3>

Implementation in `bash`:

```bash
#!/bin/bash
# db-relation-joined example

set -e # abort on error
set -x # trace execution

hostname=$(unit-get public-address)
juju-log "from host: $hostname"

# Check to see if 'database' has been set, and loop until it is
database=$(relation-get database)
if [ -z "$database" ] ; then
   exit 0
fi
juju-log "Joining database at $JUJU_REMOTE_UNIT"

# retrieve the remaining values which have been set by the mysql charm
user=$(relation-get user)
password=$(relation-get password)
host=$(relation-get private-address)
slave=$(relation-get slave)

# do something with these values
juju-log "Database acquired"
juju-log "database: $database username: $user host: $host"
```

<h2 id="heading--other-relation-hooks">Other relation hooks</h2>

The only other hook actually implemented for this interface by the mysql charm is relation-broken. This does not actually interact with connected charms using the interface, but performs some housekeeping for the mysql charm. However, this does not mean that other event driven hooks should not be created for requirer charms to do whatever they may need.
