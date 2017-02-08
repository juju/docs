Title: Creating Juju users


# Creating users

A regular user is added to a controller by the controller administrator. This
process yields an alphanumeric text string that encodes information about the
user and the controller. This string is supplied (manually at this time) to the
corresponding (real) person who will use it to *register* with the controller
using their own client system. The user will be asked to enter an arbitrary
(but hopefully meaningful) name to the controller as well as create a password
for themselves. The controller name needs to be unique within the context of
the local (operating system) user account. The user's password is stored on the
controller.

!!! Note: A "client system" is a computer, such as an Ubuntu system, that is on
the network and has Juju installed.

At this stage, the user is registered to a controller and is allowed to perform
the following additional actions (in the context of the controller):

- List controllers (`juju controllers`)
- Show controller details (`juju show-controller`)
- List enabled controller users (`juju users`)
- Show details for controller users (`juju show-user`)

To do anything further the user must wait to be granted access to a model by
the administrator. See [Users and models](./users-models.html).

!!! Note: User registration (and any other Juju operations that involves
communication between a client system and a controller) necessitates the client
be able to contact the controller over the network on TCP port 17070. In
particular, if using the LXD provider, network routes need to be in place (i.e.
to contact the LXD controller container the client traffic must be routed
through the LXD host).


## User creation and registration

To create user 'jon' (in the current controller):

```bash
juju add-user jon
```

Which will produce output similar to:

```no-highlight
Please send this command to jon:    juju register
MD4TA2ppbTAVExMxMC4xOTUuMTAuMTMwOjE3MDcwBCDENImZEDvYcWLU1USgaUJQXhWR98JNLWcbS0-MiW6NiQA=

"jon" has not been granted access to any models. You can use "juju grant" to
grant access.
```

Send the command to Jon. The registration string contained in the command you
send encodes the addresses of the controller. All Jon must do is enter the
command on a client system with Juju installed and with internet access:

```bash
juju register
MD4TA2ppbTAVExMxMC4xOTUuMTAuMTMwOjE3MDcwBCDENImZEDvYcWLU1USgaUJQXhWR98JNLWcbS0-MiW6NiQA=
```


## Logins and logouts

On any given client system, each controller that shows up with `juju
controllers` accepts a single login; a logout is necessary before logging
in to the same controller. Note that a logout of a user on one client does not
affect the same user session possibly underway on a separate client.

A newly-registered user is automatically logged in to a session. To log out of
the current Juju user session:

```bash
juju logout
```

And to log back in, either on the same client system or not, using the same
user we added earlier:

```bash
juju login jon
```

Once a user logs in they become the current user. The following is a quick way
to determine the current user (as well as the current controller and model):

```bash
juju whoami
```

The command `juju show-user` can also be used to get the current user, in
addition to other information on the user.
