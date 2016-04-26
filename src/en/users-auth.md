Title: Juju users and authentication
TODO: Stuff on user-created models (ssh key and credentials)


# Users and authentication

This section deals with topics related to user authentication and general user
security.


## Users and passwords

There are two ways users are introduced into Juju: the initial administrator of
a controller via the controller creation step and a non-administrator via the
user registration step. The latter sets up the user's Juju password but the
former is left without an actual password.  This is why if such a user tries to
log out (`juju logout`) before creating a password the command will fail and a
warning will be displayed. An administrator should, therefore, create a
password once the controller is created. They must do so if multiple Juju users
will be using the same system user account:

```bash
juju bootstrap mycontroller aws
juju change-user-password
```

See [Creating a controller](./controllers-creating.html) for details on
controller creation.


## Credentials and SSH keys

*Credentials* managed in Juju are related to the accessing of the chosen
cloud-backed resource. They are not related to Juju users themselves in any
way. Credentials added to Juju remain local to the system user (on Ubuntu:
`~/.local/share/juju/credentials.yaml`).

See [Cloud credentials](./credentials.html) for more on this topic.

*SSH keys* managed in Juju are related to the accessing of the machines Juju
creates. It copies/removes public SSH keys (`juju add-ssh-key` and `juju
import-ssh-key`) in order to provide/remove SSH access to individuals, external
to Juju. These keys are also not related to internal Juju users. A Juju user,
however, who has access to a model (he has been granted access to it) can log
in to any machine in that model using Juju (`juju ssh`).
