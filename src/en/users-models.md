

### Controller access for external users

It is possible to give a user access to a controller without creating a local
account for them. Linking the controller to the external identity manager, such
as the Ubuntu SSO, in this way provides the benefit of convenience, as the
authentication system used may also be used for other systems. This reduces
the number of login credentials that users must remember across multiple systems.

To do this, these criteria must first be met:

- The user must already have an account on an external identity manager
- The controller must have been created (bootstrapped) using the identity
  configuration option, like here where we use the URL for the Ubuntu SSO
  and Juju: `--config identity-url=https://api.jujucharms.com/identity`
- The user must first log in to http://jujucharms.com at least once before
  attempting to log in to Juju as an external user
- The user must install Juju on the machine from which they will access the
  controller

On the controller, you grant Frances access to add models using:

```bash
juju grant frances@external addmodel
```

!!! Note: 
    The '@external' is required as it indicates where the credential
    comes from, as opposed to '@local'.

You can allow anyone with an Ubuntu SSO account to create models on this
controller like this:

```bash
juju grant everyone@external addmodel
```

Sharing controller information must be done directly between the controller
owner and the external user, such as via email, and manually adding the
controller information to the local user's `$HOME/.local/share/juju/controllers.yaml`
in Ubuntu and other Linux distributions and the similar location in other OSes.

The external user will log in from their machine with `juju login -u <username>`.
They will be directed to the URL for the external identity provider so that
they may log in there and then will be granted access to the controller.

For the external user to create models from the controller, they must have
credentials for that provider, for example, GCE or AWS. Any models created
by this user will use these credentials.

```bash
juju add-model test --credential gce
```

To learn more about credentials, see [Credentials][credentials].

## Public controllers

The `juju login` command can also be used to access a public controller, using
either the name or the host name of the controller as a parameter:

```bash 
juju login jaas
```

The above command will add the 'jaas' public controller to the list of
controllers you can use, caching its details in the locally stored
`controllers.yaml` file. 

Public controllers will normally use an external identity provider.
[JAAS][jaas], as used above, uses [Ubuntu SSO][sso], which means you should 
register with [https://jujucharms.com/login](https://jujucharms.com/login).

## Revoke access rights

The 'revoke' command is used to remove a user's access to either a model or a
controller. To revoke 'add-model' controller access for user 'jim', you would
use the following:

```bash
juju revoke jim add-model
```

After a `revoke` command has been issued, a user's access will reduce to the
next lower access level. With the above example, user 'jim' would have have
'add-model' access reduced to 'login' access on the controller. This also means
that if a user has write access to a model, the following command would revoke
both read and write access:

```bash
juju revoke bob read mymodel
```

!!! Note:
    The admin user has credentials stored in the controller and will be able to
    perform functions on any model. However, a regular user who has been given
    'add-model' permissions may need to specify which credential to use when
    logging in to a model for the first time. To specify a credential, run 'juju
    add-credential'.


<!-- LINKS -->

[models-adding]: ./models-adding.md
[credentials]: ./credentials.md
[regularusers]: ./users.html#regular-users
[jaas]: https://jujucharms.com/jaas
[sso]: https://login.ubuntu.com/
