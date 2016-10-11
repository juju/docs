Title: Juju users and models
TODO: Stuff on user-added models (ssh key and credentials)


# Users and models

This section is about understanding models with multiple users.


## Adding models

When an administrator adds a model, by default, the cloud credentials used
throughout the model will be those that the admin used to create the controller
and the SSH keys copied across the model will be those of the controller model.
The administrator can override these defaults with the appropriate command
options.

The model creator becomes, by default, the model owner. However, the creation
process does allow for owner designation.

Examples:

Add model 'mymodel' (in the current controller):

```bash
juju add-model mymodel
```

Add model 'mymodel' and designate user 'tron' as the owner:

```bash
juju add-model --owner=tron mymodel
```

See [Adding a model][addmodel] for details on adding models.


## Models and user access

Model access can be granted, by an administrator, to a regular user in
read-only or write modes (ACL). Once a user has access to a model, he can apply
commands to it. Which commands become available depend upon their assigned ACL.

See [Users][regularusers] for details on available commands.

Examples:

To grant user 'bob' read access to model 'mymodel':

```bash
juju grant bob mymodel
```

!!! Note: The default ACL is read-only.

Make user 'jim' an administrator by granting him write access to model 
'controller':

```bash
juju grant --acl=write jim controller
```

!!! Note: Each user has control over naming the models they own. This means
it is possible for two users, `jane` and `claire`, to each have a model with
the same name, `foo`. This could cause difficulty when `claire` needs to access
`jane`'s model. Because of this, it is possible to refer to models
using `<owner>/<model>` in place of just the model name. For example, `claire`
can get the status of the model using `juju status -m jane/foo`.

To revoke write access from user 'jim' for model 'controller' (leaving the user
with read-only access):

```bash
juju revoke --acl=write jim mymodel
```

To revoke all access (ACL read) from user 'bob' for model 'mymodel':

```bash
juju revoke bob mymodel
```

Create user 'ben' and grant him read access to model 'mymodel':

```bash
juju add-user --models=mymodel --acl=read ben
```

Naturally, the model in the above example needs to already exist.

!!! Note: The admin user has credentials stored in the controller and will
be able to perform functions on any model. However, a regular user who has
been given 'add-model' permissions may need to specify which credential to
use when logging in to a model for the first time. To specify a credential,
run 'juju add-credential'.

[addmodel]: ./models-adding.html
[regularusers]: ./users.html#regular-users
