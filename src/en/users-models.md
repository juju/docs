Title: Juju users and models
TODO: Stuff on user-created models (ssh key and credentials)


# Users and models

This section is about understanding models with multiple users.


## Creating models

When an administrator creates a model, by default, the cloud credentials used
throughout the model will be those that the admin used to create the controller
and the SSH keys copied across the model will be those of the admin model. The
administrator can override these defaults with the appropriate command options.

The model creator becomes, by default, the model owner. However, the creation
process does allow for owner designation.

Examples:

Create model 'mymodel' (in the current controller):

```bash
juju create-model mymodel
```

Create model 'mymodel' and designate user 'tron' as the owner:

```bash
juju create-model --owner=tron mymodel
```

See [Creating a model](./models-creating.html) for details on creating models.


## Models and user access

Model access can be granted, by an administrator, to a regular user in
read-only or write modes (ACL). Once a user has access to a model, he can apply
commands to it. Which commands become available depend upon their assigned ACL.

Examples:

To grant user 'bob' read access to model 'mymodel':

```bash
juju grant bob mymodel
```

!!! Note: The default ACL is read-only.

Make user 'jim' an administrator by granting him write access to model 'admin':

```bash
juju grant --acl=write jim admin
```

To revoke write access from user 'jim' for model 'admin' (leaving the user with
read-only access):

```bash
juju revoke --acl=write jim mymodel
```

To revoke all access (ACL read) from user 'bob' for model 'mymodel':

```bash
juju revoke bob mymodel
```

Create user 'ben' and grant him read access to model 'mymodel':

```bash
juju add-user --models=mymodel --acl=read jon
```

Naturally, the model in the above example needs to already exist.
