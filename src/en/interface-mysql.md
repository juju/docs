# mysql interface

The mysql interface is provided by the mysql charm, and is required by a number
of charms currently in the Charm Store and elsewhere which would like to use or
actually require a MySQL database.

## Hook Implementation: relation-joined

### In theory

When the mysql charm is notified of a “relation joined” event, it creates a
database. String values are generated for the credentials needed to authenticate
a connection to this database: the database name, a username and password. The
mysql charm will also check the instance’s hostname and pass that value too, as
well as a string containing “True” or “False” to indicate whether this unit is a
slave.

A charm joining this relationship will typically have a relationship-joined hook
which will wait to see when the mysql charm has set one of the expected values
(all values are set simultaneously, so the availability of one indicates that
all are available).

### In practice

Upon relation joined, mysql sets the following:

  - database (string)
  - user (string)
  - password (string)
  - host (string)
  - slave (string)

The corresponding `relation-joined` hook in any charm connecting to the mysql
charm should fetch any or all of these values.

### Reference examples:

Implementation in `bash`:

    #!/bin/sh
    # db-relation-joined example
    
    set -ex # -x for verbose logging to juju debug-log
    juju-log "Joining database at $JUJU_REMOTE_UNIT"
    hostname=`unit-get public-address`
    juju-log "from host: $hostname"
    
    # Check to see if 'database' has been set, and loop until it is
    database=`relation-get database`
    if [ -z "$database" ] ; then
       exit 0
    fi
    # retrieve the remaining values which have been set by the mysql charm
    user=`relation-get user`
    password=`relation-get password`
    host=`relation-get private-address`
    slave=`relation-get slave`
    
    # do something with these values
    juju-log "Database acquired"
    juju-log "database: $database username: $user host: $host"
    

##  Other relation hooks

The only other hook actually implemented for this interface by the mysql charm
is relation-broken. This does not actually interact with connected charms using
the interface, but performs some housekeeping for the mysql charm. However, this
does not mean that other event driven hooks should not be created for requirer
charms to do whatever they may need.
