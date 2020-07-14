# Writing charm interfaces

For Charms to communicate with one another charms utilise what are called Interfaces.

Interfaces are the spin which charms use to enable communication between relationships, if you read the [Charm Writing Guide](https://discourse.juju.is/t/draft-operator-charm-writing-guide/3101) then you will have seen some illustrations on how charms communicate with each other.

There are two components to Charm Interfaces:

- Clients
- Servers (TODO: Should this be servers??) (TODO: Check Naming)

Interfaces take a structure much like charms themselves, but taking on different roles. In the case of interfaces they are 'facilitators'. Making sure that the communication between two charms takes an expected (maybe standard) form.

As a case study, we can look at the MySQLClient charm. This charm uses a single file called `interface_mysql.py` which contains both the


## Importing dependencies into the charm

When adding interfaces you will have to make sure they are imported to the `lib` directory.

To do this run a symbolic link, similar to this:

`ln -s ../mod/interface-mysql lib/interface_mysql` ensure the folder is valid for Python, and contains a `__init__.py` file.
