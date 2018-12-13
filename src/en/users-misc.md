Title: Creating Juju users




## Logins and logouts

On any given client system, each controller that shows up with 
`juju controllers` accepts a single login; a logout is necessary before logging
in to the same controller.

A newly-registered user is automatically logged in to a session. To log out of
the current Juju user session:

```bash
juju logout
```

And to log back in, either on the same client system or not, using the same
user we added earlier:

```bash
juju login -u jon
```

Once a user logs in they become the current user. The following is a quick way
to determine the current user (as well as the current controller and model):

```bash
juju whoami
```

The command `juju show-user` can also be used to get the current user, in
addition to other information on the user.
