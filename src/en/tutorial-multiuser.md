Title: Multi-user basic setup - tutorial

# Multi-user basic setup - tutorial

*This is a tutorial in connection with the multi-user framework of Juju. See
[Working with multiple users][multiuser] for background information.*

This tutorial will give an overview of how Juju can be used with one person
assuming the role of a traditional administrator and a second person acting as
the Juju operator. The administrator creates the controller, creates users,
and grants user permissions whereby the operator is responsible for creating
models and installing software.

The following topics will be covered:

 - Controller creation and the initial controller administrator
 - User creation and controller registration
 - User login, logout, and password changing
 - User model creation
 - User charm deployment

## Controller creation and the initial controller administrator

Besides resulting in a new controller the `bootstrap` command sets up a Juju
user called 'admin' with controller permissions of 'superuser'. This is the
initial controller administrator.

Here we'll add credentials and then create a GCE-based controller: 

```bash
juju add-credential google -f credentials-administrator.yaml
juju bootstrap google gce
```

In the above the credentials file contains a single credential for the 'google'
cloud, allowing it to become the default credential in the subsequent
`bootstrap` command.

Inspecting the controller's users with the `users` command allows us to confirm
the above information:

```bash
juju users
```

Example output:

```no-highlight
Controller: gce

Name    Display name  Access     Date created   Last connection
admin*  admin         superuser  2 minutes ago  just now
```

Note that the new administrator does not have a password per se. Create one
now:

```bash
juju change-user-password
```

## User creation and controller registration

Let the administrator now create a regular user called 'tom':

```bash
juju add-user tom
```

The output includes a string (token) to give to the intended operator of the
new user. This will enable the operator to add the controller to their own Juju
client running on a separate host.

Sample output:

```no-highlight
User "tom" added
Please send this command to tom:
    juju register MGcTA3RvbTA5ExQzNS4yMzcuMTY1LjI[...]

"tom" has not been granted access to any models. You can use "juju grant" to grant access.
```

!!! Important: 
    The client host must be able to contact the controller host on TCP port
    17070 in order for controller registration to succeed. This is the case for
    any client-controller communication.

Registration is done with the `register` command. On a separate host, then:

```bash
juju register MGcTA3RvbTA5ExQzNS4yMzcuMTY1LjI[...]
```

Example output:

```no-highlight
Enter a new password: ******
Confirm password: ******
Enter a name for this controller [gce]: 
Initial password successfully set for tom.

Welcome, tom. You are now logged into "gce".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

## User login, logout, and password changing

A newly-created user is granted controller access of 'login' out of the box. So
besides logging in the user cannot do much else.

Registration implies a controller login (as can be seen by the previous
command's messaging). To log out, use the `logout` command:

```bash
juju logout
```

A login session also expires after a fixed amount of time (24 hours).

To log back in, use the `login` command with the username as argument. Provide
the password that was set up during registration:

```bash
juju login -u tom
```

Supply a controller name (`-c gce`) if there is more than one controller
registered with the client.

Change the user's password with the `change-user-password` command:

```bash
juju change-user-password
```

## User model creation

In order for the user to be able to add models the administrator must grant
'add-model' controller access:

```bash
juju grant tom add-model
```

Yet before the remote operator is able to create a model he will first need to
add a credential to Juju. In a single-user setup this is done prior to
controller creation, but in this context the operator is devoid of a
credential.

On the (user) operator's host, add a credential and then add a model:

```bash
juju add-credential google -f credentials-operator.yaml
juju add-model gce-model-1
```

In the above the credentials file contains a single credential for the 'google'
cloud, allowing it to become the default credential in the subsequent
`add-model` command.

## User model SSH access

The operator user can now connect, using Juju's `ssh` command, to any machine
that may get created within their new model. This is standard Juju behaviour
that the model creator always enjoys. Note, however, that the SSH keys
necessary for this to work are found within the client system's filesystem at
`~/.local/share/juju/ssh/juju_id_rsa.pub` (and `~/.ssh/id_rsa.pub` if it
existed at the time of model creation).

Verify SSH access now on the operator host:

```bash
juju add-machine
juju ssh 0
```

Above we assume the machine that was added got assigned an ID of '0' (the
default for the first machine in a model).

## User charm deployment

The operator user can now deploy charms as normal. See
[Deploying applications][charms-deploying] for help.


<!-- LINKS -->

[multiuser]: ./multiuser.md
[credentials]: ./credentials.md
[models-adding]: ./models-adding.md
[machine-auth]: ./machine-auth.md
[charms-deploying]: ./charms-deploying.md
