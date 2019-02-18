Title: Working with multiple users
TODO: Check the functionality of admin user access level. This currently appears to do nothing (not destroy models, nor backups) 

# Working with multiple users

Juju has an internal user framework that allows for the sharing of controllers
and models. To achieve this, a Juju user can be created, disabled, and have
rights granted and revoked. Users remote to the system that created a
controller can use their own Juju client to log in to the controller and manage
the environment based on the rights conferred. Multiple users can be
accommodated by the same Juju client.

Various categories of users can be defined based on the permissions they have
been granted. In turn, these permissions lead to certain abilities. See page
[User types and abilities][users] for an overview.

!!! Note:
    Juju users are not related in any way to the client system users.

## Creating users

There are two ways users are introduced into Juju:

 1. with the `bootstrap` command, which creates the initial controller
    administrator
 1. with the `add-user` command, which creates a generic user 
 
In the second case the user gets a password set up but in the first case the
user is left without one. This is why if such an admin tries to log out
(`logout`) before creating a password the command will fail and a warning will
be emitted. An admin should, therefore, create a password once the controller
is created:

```bash
juju bootstrap aws
juju change-user-password
```

In a Juju context, the term "credential" is related to the accessing of a
chosen backing cloud, and not to Juju users. See [Credentials][credentials] for
guidance.

### Creating a generic user

When the `add-user` command is used, a string of text is produced that encodes
information about the user and the controller. This string is supplied to the
intended operator who will use it to *register* the controller using their own
Juju client.

The user will be asked to enter an arbitrary (but hopefully meaningful) name to
the controller as well as create a password for themselves. The controller name
needs to be unique within the context of the client. The user's password is
stored on the controller.

!!! Important: 
    Controller registration (and any other Juju operations that involves
    communication between a client and a controller) necessitates the client be
    able to contact the controller over the network on TCP port 17070. In
    particular, if using a LXD-based cloud, network routes need to be in place
    (i.e. to contact the controller LXD container the client traffic must be
    routed through the LXD host).

To create user 'mat' a controller administrator uses the `add-user` command:

```bash
juju add-user mat
```

This will produce output similar to:

```no-highlight
User "mat" added
Please send this command to mat:
    juju register ME0TA21hdDAWExQxMC4xNDkuMTMzLjIwOToxNzA3MAQg7D-RDR8cnioqd7ctEoCjyDzaprK4wXodvfMBBrgBUKETDGx4ZC1iaW9uaWMtMQAA

"mat" has not been granted access to any models. You can use "juju grant" to grant access.
```

An administrator provides the command (manually) to the intended operator, who
will execute it:

```bash
juju register ME0TA21hdDAWExQxMC4xNDkuMTMzLjIwOToxNzA3MAQg7D-RDR8cnioqd7ctEoCjyDzaprK4wXodvfMBBrgBUKETDGx4ZC1iaW9uaWMtMQAA
```

Sample user session:


```no-highlight
Enter a new password: 
Confirm password: 
Enter a name for this controller [lxd-bionic-1]: lxd-bionic-1
Initial password successfully set for mat.

Welcome, mat. You are now logged into "lxd-bionic-1".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

The name of the original controller, in this case 'lxd-bionic-1', is offered as
a default controller name.

!!! Note:
    A user can be acted upon (e.g. granted permissions) prior to that user
    registering the controller.
    
## Logins and logouts

A user who has just registered a controller is automatically logged in to that
controller.

A user can log out at any time:

```bash
juju logout
```

To log in to a controller, the operator needs to specify both the user and the
controller:

```bash
juju login -u mat -c lxd-bionic-1
```

The following is a quick way to determine the current user (as well as the
current controller and model):

```bash
juju whoami
```

Example output:

```no-highlight
Controller:  lxd-bionic-1
Model:       <no-current-model>
User:        mat
```

## Disabling and re-enabling users

To immediately sever a user's communication with their controller the
`disable-user` command is employed. To re-establish communication the
`enable-user` command is used.

To disable the user 'mike':

```bash
juju disable-user mike
```

To re-enable:

```bash
juju enable-user mike
```

Disabled users are suppressed in the output to the `users` command unless the
`--all` option is used, whereby the output will show "disabled":

```no-highlight
Controller: cstack

Name    Display name  Access     Date created    Last connection
admin*  admin         superuser  2018-12-12      just now
mike                  login      17 minutes ago  never connected (disabled)
```

## Changing user passwords

A user is prompted to set a password when registering a controller. This
password can subsequently be changed either by the user himself or by a
controller admin. For the user, it is simply a matter of running:

```bash
juju change-user-password
```

The admin user supplies the name of the user whose password is to be changed:

```bash
juju change-user-password mike
```

Then simply follow the prompts to enter and confirm a new password.

## Re-generating a lost registration string

If the original registering token fails to work or is lost a new token can be
generated by a controller admin. This is done through the use of the `--reset`
option in conjunction with the `change-user-password` command. For example, to
generate a new token for 'jon':

```bash
juju change-user-password jon --reset
```

The previous token will be invalidated, and the user should register with the
new token.

## Managing models in a multi-user context

In this section we go over the various ways models can be managed in a
multi-user context. Subtopics include:

 - Providing model ownership during model creation
 - Model access
 - Controller access

### Providing model ownership during model creation

The model creator becomes, by default, the model owner. However, the creation
process does allow for owner designation. To add model 'staging' and designate
user 'neo' as the owner:

```bash
juju add-model --owner=neo staging
```

See the [Adding a model][models-adding] page for the basics on adding models.

### Model access

A controller admin uses the `grant` command to give a user 'read', 'write', or
'admin' access to a model: 

 - `read`: A user can view the state of a model (e.g. `models`, `machines`, and
   `status`)
 - `write`: In addition to 'read' abilities, a user can modify/configure models
   (e.g. `model-config` and `model-defaults`).
 - `admin`: In addition to 'write' abilities, a user can perform model upgrades
   (`upgrade-model`) and connect to machines via `juju ssh`. Makes the user an
   effective model owner. See [Machine authentication][machine-auth] for how
   to connect to machines.

Here we give 'bob' write access to model 'genesis':

```bash
juju grant bob write genesis
```

Current model access for a user can be viewed by specifying the user with the
`models` command. Here we inspect the access enjoyed by user 'mat':

```bash
juju models --user mat
```

Sample output:

```no-highlight
Controller: lxd-bionic-1

Model            Cloud/Region         Status     Access  Last connection
admin/euphoric*  localhost/localhost  available  read    never connected
```

Notice how the model name is prepended with the remote user's name, which is
the 'owner' of the model.

Access can be viewed on a per-model basis by using the `show-model` command.
Here we query model 'mara':

```bash
juju show-model mara
```

Partial output:

```no-highlight
 users:
    admin:
      display-name: admin
      access: admin
      last-connection: never connected
    jim:
      access: write
      last-connection: never connected
    pete:
      access: admin
      last-connection: never connected
```

### Controller access

A controller actually refers to a special kind of model that acts as the
nucleus for each cloud environment. In addition to the three levels of model
access, three further levels of access can be applied to a controller:

 - `login`: the standard access level, enabling a user to log in to a
   controller.
 - `add-model`: in addition to login access, a user can add and remove models.
 - `superuser`: makes a user an effective controller administrator.

The command syntax for controller access is the same as for model access, only
without the need to specify a model. As usual, with no controller specified via
the `-c` option, the current controller is the assumed target.

Here we give 'jim' the 'add-model' permission:

```bash
juju grant jim add-model
```

Current controller access for all users registered to a controller can be
viewed with the `users` command. Example output:

```no-highlight
Controller: azure-1

Name    Display name  Access     Date created  Last connection
admin*  admin         superuser  2018-12-14    just now
bob                   login      1 hour ago    50 minutes ago
jim                   add-model  2018-12-14    58 minutes ago
```

In addition, a controller admin can use the `show-user` command to get
controller access on a per-user basis, in addition to other information on the
user.

## Revoking access

The `revoke` command is used by a controller administrator to demote a user's
access to the next lowest level. That is, if a user has 'write' access to a
model and 'read' is revoked then both 'read' and 'write' are removed. This
works similarly for controller access. If a user has 'superuser' access and
'add-model' is revoked then both 'add-model' and 'superuser' are removed.

If user 'bob' has 'write' access to model 'gotcha', use the following to remove
all access to this model:

```bash
juju revoke bob read gotcha
```

Confirm this action with `juju models --user bob`.

If user 'jim' has 'superuser' access to controller 'waves', use the following
to leave the user with just 'login' access:

```bash
juju revoke -c waves jim add-model
```

Confirm this action with `juju show-user --user jim`.

As usual, if a controller is not specified (`-c`) the default controller is the
currently active one.

## Next steps

To explore using Juju with multiple users consider the following tutorials:

 - [Multi-user basic setup][tutorial-multiuser-basic]
 - [Multi-user external setup][tutorial-multiuser-external]


<!-- LINKS -->

[users]: ./users.md
[machine-auth]: ./machine-auth.md
[users-external]: ./users-external.md
[credentials]: ./credentials.md
[models-adding]: ./models-adding.md
[tutorial-multiuser-basic]: ./tutorial-multiuser-basic.md
[tutorial-multiuser-external]: ./tutorial-multiuser-external.md
