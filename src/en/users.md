Title: User types and abilities
TODO:  bug tracking: https://bugs.launchpad.net/bugs/1808661
       bug tracking: https://bugs.launchpad.net/bugs/1808662

# User types and abilities

*This is in connection with the [Working with multiple users][multiuser] page.
See that resource for background information.*

There are three types of Juju users that we can speak of: controller
administrators, model owners, and regular users. Each user, no matter the kind,
is associated with one, and only one, controller.

A *controller administrator* is a user who has full access to the 'controller'
model. This set of users is comprised of the controller creator and any user
the latter user has granted 'superuser' access to the 'controller' model.
There is no overarching "Juju administrator" since multiple controllers, and
therefore multiple controller administrators, are possible. Nevertheless, this
user is usually what people refer to as "the admin".

A *model owner* has some specific administrative powers over a model. By
default, the owner is the model creator but an owner can also be explicitly
assigned during creation-time.

A *regular user* is one who is neither a controller administrator nor a model
owner. Such a user requires access to a model in order to do anything at the
Juju level.

!!! Note:
    The *operator* is a term used to refer to the actual person who is driving
    the Juju client.

The different Juju user types have different abilities based on permissions.
They are outlined below. For completeness, the abilities of system users and
newly-created users are also included.

## System users

Actions available to a system user and the corresponding Juju commands:

 - Access help (`help`)
 - List supported cloud types (`clouds`)
 - Show details on each cloud type (`show-cloud`)
 - Connect to a controller (`register`)
 - Add credentials (`add-credential` and `autoload-credentials`)
 - List credentials (`credentials`)
 - Create controllers (`bootstrap`)

Once a system user has created a controller they are provided automatically, at
the Juju level, with an administrator of that controller and inherit all the
privileges of that user type (see below).

Since any system user can add credentials and create controllers, it is
conceivable that multiple controllers exist that use the same cloud resource
(public cloud account). Although this will work with Juju, it is a policy
decision as to whether this should be allowed.

## Newly-created users

A newly-created user is automatically granted login access to the controller.
Once logged in, the user is allowed to perform additional actions:

 - Log in to a controller (`login`)
 - List the user (`users`)
 - Show details for the user (`show-user`)
 - Log out of a controller (`logout`)

To do anything further the user must be granted some level of access to a model
or be given superuser access to the controller.

## Controller administrators

Only a controller administrator (the "admin") has the power to perform these
actions (in the context of their controller):

 - Add users (`add-user`)
 - Disable users (`disable-user`)
 - Enable previously disabled users (`enable-user`)
 - Create models (`create-model`)
 - Grant user access to models (`grant`)
 - Revoke user access from models (`revoke`)
 - Remove models (`destroy-model`)
 - Remove the controller (`destroy-controller` or `kill-controller`)
 - Upgrade models (`upgrade-model`)
 - Manage controller backups (e.g. `create-backup`)

## Model owners

A model owner can list users who have access to the model (`users`), destroy
the model (`destroy-model`), and upgrade the model (`upgrade-model`).

## Regular users

The ability of a regular user depends on the model access rights ('read' or
'write') they have been granted.

For read-only access, the user can do the following:

 - List models (`models`)
 - List machines (`machines`)
 - Show the status (`status`)

For write access, the user can use Juju as an operator, beginning with the
following major actions:

 - Deploy applications (`deploy`)
 - Scale out applications (`add-unit`)


<!-- LINKS -->

[multiuser]: ./multiuser.md
