Title: Juju and users
TODO: User abilities, especially owners and regular users


# Juju users

Juju has the capacity to manage multiple users. This section covers this
overall feature.


## Introduction

There are 3 kinds of Juju users: controller administrators, model owners, and
regular users. Each user, no matter the kind, is associated with a controller.
In particular, the namespace for users are controller-centric; names can be
duplicated across controllers.

Juju users are not related in any way to the localhost system users; they are
purely Juju constructs.

A *controller administrator* is a user who has access to the given controller's
'admin' model. This Juju user is called 'admin' and is set up as part of the
controller creation step. Practically, this set of users is comprised of the
controller creator and any user the creator/initial_admin has granted write
access to the 'admin' model. Thus, there is no overarching "Juju administrator"
since multiple controllers, and therefore multiple administrators, are
possible.

A *model owner* is the model creator or a user who has been designated as such
during the model creation process.

A *regular user* is one who is neither an administrator nor a model owner. Such a
user requires access to a model in order to do anything at the Juju level. Note
that although deemed "regular", such a user is far from ordinary since they can
marshall the vast resources of the backing cloud and deploy complex services.


## User abilities

The different Juju user types have different abilities based on permissions.
They are outlined below. For completeness, the abilities of system (localhost)
users are also included.

Actions available to a system user:

    - Access general help (`juju help`)
    - List supported cloud types (`juju list-clouds`)
    - Show details on each cloud type (`juju show-cloud`)
    - Register with a controller (`juju register`)
    - Add credentials (`juju add-credential` and `juju autoload-credentials`)
    - List cloud credentials (`juju list-credentials`)
    - Create controllers (`juju bootstrap`)

Once a system user has created a controller they are provided automatically, at
the Juju level, with an administrator of that controller and inherit all the
privileges of that user type (see below).

Since any system user can add credentials and create controllers, it is
conceivable that multiple controllers exist that use the same cloud resource
(public cloud account). Although this will work with Juju, it is a policy
decision on the part of those who use Juju as to whether this should be
allowed.

See [Controllers](./controllers.html) for information on controllers.

**Administrators**<br/>
Only an administrator has the power to perform these actions (in
the context of their controller):

    - Add users (`juju add-user`)
    - Disable users (`juju disable-user`)
    - Enable previously disabled users (`juju enable-user`)
    - Create models (`juju create-model`)
    - Grant user access to models (`juju grant`)
    - Revoke user access from models (`juju revoke`)
    - Remove models (`juju destroy-model`)
    - Remove the controller (`juju destroy-controller`)
    - Maintenance operations (e.g.: backups)

**Model owners**<br/>
A model owner has the power to list users who have access to the model they own
(`juju list-shares`).

**Regular users**<br/>
The ability of a regular user depends on the model access rights (read-only or
write) they have been given.

For read-only access, the user can do the following:

    - List models (`juju list-models`)
    - List machines (`juju list-machines`)
    - Show the status (`juju status`)

For write access, the user can also do the following:

    - Deploy services (`juju deploy`)
    - Scale out services (`juju add-unit`)

An explanation of how users gain access to models is provided in
[Users and models](./users-models.html).
