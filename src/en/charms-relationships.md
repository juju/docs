# How do I define a relationship?

In order to define a relationship between two charms you must first define the
relation in each charms `metadata.yaml` file. Given a defined a server/client
role this document will explain how to define relationships using the examples
below with `foo-server` and `foo-client` charms. Since it's likely the server
_providing_ the majority of the data to the _client_ their metadata.yaml files
would look as such:


## foo-server

```yaml
name: foo-server
description: Something more than this
provides:
  server:
    interface: foo
```


## foo-client

```yaml
name: foo-client
description: Something more than this
requires:
  backend:
    interface: foo
```

Juju has two primary relation types, "Provides" and "Requires". In this case
the server charm is _providing_ "foo" as an interface. The client charm
_requires_ the "foo" interface to operate. This arrangement allows Juju to know
which charms can talk to which other charms.

The interface is an arbitrary name, in this case "foo".  There's a large list
of already defined interfaces, such as: mysql, http, mongodb, etc. If your
service provides
[one of these existing interfaces](http://manage.jujucharms.com/interfaces)
you'd want to consider implementing it. If not feel free to create a new one.


# How do I get/send data?

Once you've defined your metadata, you'll need to create a few
[new hooks](authors-charm-hooks.html#relation-hooks) the hook names are defined
in the linked documentation, but since you're _just_ sending the address
information we'll keep with a simple bash example of the implementation of each
hook.

So, we have two charms, `foo-server` and `foo-client`. `foo-server` provides
a "server" relation with the foo interface. `foo-client` requires a
"backend" relation with the foo interface. Relation hooks are named based on
the relation-name (not the interface name). These could both be called
server, but to illustrate that Juju matches on interface and not relation,
I've made the `foo-client` relation name be "backend".


## foo-server/hooks/server-relation-joined

```bash
#!/bin/bash
set -eux
relation-set hostname=`unit-get private-address`
```

This is a very basic example, where we're creating a relation key called
`hostname` and setting the value, using `unit-get` command, to the
private-address of the unit the charm is deployed to. This address will vary
from provider to provider, but it will always be reachable within a Juju
environment. You can set multiple keys by adding a space between each, for
example:

```bash
#!/bin/bash
relation-set hostname=`unit-get private-address` public-address=`unit-get public-address`
```

This will send two keys, `hostname` and `public-address` to whatever service
it's connected to.


## foo-client/hooks/backend-relation-changed

Notice the difference in file name, this is invoking the `relation-changed` hook
instead of `relation-joined`. Presumably the server is just giving the details
of where it lives, so the client charm needs to know where that address is. By
putting this in the relation-changed hook every time data on the relation is
updated the hook is called again.

```bash
#!/bin/bash
set -eux
server_address=`relation-get hostname`
if [ -z "$server_address" ]; then
  juju-log "No data sent yet"
  exit 0
fi
```


# If you've gotten this far, you have a $server_address, configure as you see fit

Now, there's a little more involved in this hook. Taking it line by line, the
first three are standard stuff. It's a bash charm and `set -eux` is there to
make sure the hook behaves as it should. The next line uses `relation-get`
which will read relation data from the connection. Now, everything in a Juju
environment is orchestrated asynchronously. So you're never 100% certain you'll
have data when you call `relation-get`. This is where the `if` block helps
resolve that. If there's nothing in "$server_address", ie we didn't get a
return value, the hook will simply exit. However, it's exiting with a zero
status so it won't crop up as an error in Juju.

This seems counter intuitive as we technically have a problem because we don't
have data. This situation should be seen as "We don't have data, yet". By
exiting zero, once the corresponding service actually sets the value, it'll
trigger the `relation-changed` hook again and we'll be able to read the value.
This is considered an example of an
[idempotency guard](authors-charm-hooks.html#writing-hooks) which are crucial
as you write hooks.
