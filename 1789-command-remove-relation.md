**Usage:** `juju remove-relation [options] <application1>[:<relation name1>] <application2>[:<relation name2>] | <relation-id>`

**Summary:**

Removes an existing relation between two applications.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

An existing relation between the two specified applications will be removed. This should not result in either of the applications entering an error state, but may result in either or both of the applications being unable to continue normal operation. In the case that there is more than one relation between two applications it is necessary to specify which is to be removed (see examples). Relations will automatically be removed when using the `juju remove-application` command.

The relation is specified using the relation endpoint names, eg mysql wordpress, or mediawiki:db mariadb:db

It is also possible to specify the relation ID, if known. This is useful to terminate a relation originating from a different model, where only the ID is known.

**Examples:**

       juju remove-relation mysql wordpress
        juju remove-relation 4
In the case of multiple relations, the relation name should be specified at least once - the following examples will all have the same effect:

       juju remove-relation mediawiki:db mariadb:db
        juju remove-relation mediawiki mariadb:db
        juju remove-relation mediawiki:db mariadb
**See also:**

[add-relation](https://discourse.jujucharms.com/t/command-add-relation/1674), [remove-application](https://discourse.jujucharms.com/t/command-remove-application/1780)
