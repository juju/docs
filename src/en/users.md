Title: User types

# User types

*This is in connection with the [Using Juju with multiple users][multiuser]
page. See that resource for background information.*

There are three kinds of Juju users: controller administrators, model owners,
and regular users. Each user, no matter the kind, is associated with a
controller. In particular, the namespace for users are controller-centric;
names can be duplicated across controllers.

Juju users are not related in any way to the localhost system users; they are
purely Juju constructs.

A *controller administrator* is a user who has access to the controller model.
This Juju user is called 'admin' and is set up as part of the controller
creation step. Practically, this set of users is comprised of the controller
creator and any user the creator/initial_admin has granted write access to the
'controller' model. There is no overarching "Juju administrator" since multiple
controllers, and therefore multiple administrators, are possible.

A *model owner* is the model creator; a user who has been designated as such
during model creation; or a user who has been granted the 'admin' permissions
to the model.

A *regular user* is one who is neither an administrator nor a model owner. Such
a user requires access to a model in order to do anything at the Juju level.
Note that although deemed "regular", such a user is far from ordinary since
they can marshal the vast resources of the backing cloud and deploy complex
applications.

## User abilities

The different Juju user types have different abilities based on permissions.
They are outlined below. For completeness, the abilities of system users and
newly-created users are also included.

### System users

Actions available to a system user and the corresponding Juju commands:

 - Access help (`help`)
 - List supported cloud types (`clouds`)
 - Show details on each cloud type (`show-cloud`)
 - Connect to a controller (`register`)
 - Add credentials (`add-credential` and `autoload-credentials`)
 - List credentials (`credentials`)
 - Create controllers (`bootstrap`)
 - Log in to a controller (`login`)

Once a system user has created a controller they are provided automatically, at
the Juju level, with an administrator of that controller and inherit all the
privileges of that user type (see below).

Since any system user can add credentials and create controllers, it is
conceivable that multiple controllers exist that use the same cloud resource
(public cloud account). Although this will work with Juju, it is a policy
decision as to whether this should be allowed.

### Newly-created users

A newly-created user is automatically granted login access to the controller.
Once logged in, the user is allowed to perform the following additional
actions:

 - List the user (`users`)
 - Show details for the user (`show-user`)
 - Log out of a controller (`logout`)

To do anything further the user must be granted some level of access to a model
or be given superuser access to the controller.

### Controller administrators

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

### Model owners

A model owner has the power to list users who have access to the model they own
(`users`) as well as upgrade their model (`upgrade-model`).

### Regular users

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
