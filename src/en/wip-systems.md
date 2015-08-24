Title: How to configure Juju to manage multiple environments

# The Juju Environment System

Experimental in version 1.25, the Juju Environment System (JES) enables new 
features for managing environments and controlling access to them through user 
identities.

## Enabling the Juju Environment System feature flag

In order to use the multiple environment features of the Juju Environment System 
(JES), you need to enable a development feature flag:

```bash
export JUJU_DEV_FEATURE_FLAGS=jes
```

This should be the default behaviour with Juju 1.26.

This environment variable is needed to bootstrap the environment. It is also
needed for the 'environment' and 'system' subcommands to be used.

An existing Juju environment cannot be upgraded to one where the feature flag
is set. The feature flag enables early access in a testing capacity and it is
not expected that production deployments will use any feature flags.

## Juju systems and environments

A Juju Environment System (JES), also sometimes shortened to 'Juju System',
describes the environment that runs and manages the Juju API servers and the
underlying database.

This initial environment is also called the 'system environment' 
(or 'bootstrap environment'), and is what is
created when the bootstrap command is used.  This System environment is a
normal Juju environment that just happens to have machines that manage Juju.

In order to keep a clean separation of concerns, it is considered best
practice to create additional environments for real workload deployment.

Services can still be deployed to the System environment, but it is generally
expected that these services are more for management and monitoring purposes,
like Landscape and Nagios.


## Creating environments in a Juju System

The `juju system create-environment` command will create a new empty
environment that has the current user as the owner. These secondary
environments are called 'hosted environments', as they are hosted within a
Juju System. When creating an environment, the user will need to specify cloud
credentials.

These credentials can be specified either through command line options, a yaml
formatted configuration file, or as environment variable that the cloud
provider defines. These are the same values that you would use to bootstrap an
environment.

```bash
juju system create-environment test
```
... should return output of the form:

```no-highlight
created environment "test"
staging (system) -> test
```

When the environment has been created, it becomes the current environment. A
new environment has no machines, and no services, so running:

```bash
juju status
```
...will return:

```no-highlight
environment: test
machines: {}
services: {}
```

## Destroying environments

Due to the different behaviour of destroying environments verses destroying
systems, the `destroy-environment` command is being deprecated in favour of
the following three commands:

- juju environment destroy
- juju system destroy
- juju system kill

### `juju environment destroy`

Destroying a hosted environment does not impact the primary state server
environment in any way.  Until Juju gains the capability of more fine grained
permissions, any user that has access to the environment can destroy it.  If
there are any blocks in the environment, this call will fail. There is no
`--force` option for a hosted environment.

### `juju system destroy`

Only system administrators can call this command. A system administrator is
someone who has access to the state server environment (the first environment
created during bootstrap).

Destroying a Juju System has more impact if there are other hosted
environments. By default, the `juju system destroy` command will fail if there
are hosted environments.

The admin can pass a flag to indicate that all the hosted environments should
also be destroyed.

If there are blocks on any environment, this command will fail.  If the API
server is not accessible, this command will fail.

### `juju system kill`

This command's primary use case is to deal with the situation where the remote
API server is not accessible, and replaces the older `juju destroy-environment 
--force` command.

The command will first attempt to destroy all the environments through the
API, but will fall back to destroying the machines using direct cloud provider
calls if the API is not accessible.

If there were hosted environments running that had cloud machines allocated to
it, and the API server was not accessible, the machines will need to be
manually reclaimed through the cloud provider's tools.

## Creating additional users

When creating a Juju system that is going to be used by more than one person,
it is good practice to create users for each individual that will be accessing
the environments.

Users are managed within the Juju system using the 'juju user' command. This
allows the creation, listing, and disabling of users. When a juju system is
initially bootstrapped, there is only one user.  Additional users are created
as follows:

```bash
$ juju user add bob "Bob Brown"
user "Bob Brown (bob)" added
server file written to /current/working/directory/bob.server
```

This command will create a local file "bob.server". The name of the file is
customisable using the --output option on the command. This 'server file'
should then be sent to Bob. Bob can then use this file to login to the Juju
system.

The server file contains everything that Juju needs to connect to the API
server of the Juju system. It has the network address, server certificate,
username and a randomly generated password.

## Logging in to someone else's system

Juju needs to have a name for the system when Bob calls the login command.
This is used to identify the system by name for other commands, like switch.

When Bob logs in to the system, a different random password is generated and
cached locally. This does mean that this particular server file is not usable
a second time. If Bob does not want to change the password, he can use the
--keep-password flag.

```bash
$ juju system login --server=bob.server staging
cached connection details as system "staging"
-> staging (system)
```

Bob can then list all the environments within that system that he has access
to:

```bash
$ juju system environments
NAME  OWNER  LAST CONNECTION
```

The list could well be empty.

## Collaboration with other users

Bob wants to collaborate with Mary on this environment. A user for Mary needs
to exist in the system before Bob is able to share the environment with her.

```bash
$ juju environment share mary
ERROR could not share environment: user "mary" does not exist locally: user "mary" not found
```

Bob gets the system administrator to add a user for Mary, and then shares the
environment with Mary.

```bash
$ juju environment share mary
$ juju environment users
NAME        DATE CREATED    LAST CONNECTION
bob@local   5 minutes ago   just now
mary@local  57 seconds ago  never connected
```

When Mary has used her credentials to connect to the Juju system, she can see
Bob's environment.

```bash
$ juju system environments
NAME  OWNER      LAST CONNECTION
test  bob@local  never connected
```

Mary can use this environment.

```bash
$ juju system use-environment test
mary-server (system) -> bob-test
```

The local name for the environment is by default 'owner-name', so since this
environment is owned by 'bob@local' and called 'test', for Mary the environment
is called 'bob-test'.

