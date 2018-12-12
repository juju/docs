Title: Using Juju with multiple users

# Using Juju with multiple users

Juju has an internal user framework that allows for the sharing of controllers
and models. To achieve this, a Juju user can be created that is of a certain
type; be granted specific permissions; and be authenticated in a certain way.

[User types][users]

# Creating users

A user is added to a controller by the controller administrator. This process
yields a text string that encodes information about the user and the
controller. This string is supplied to the intended operator who will use it to
*register* the controller using their own Juju client.

The user will be asked to enter an arbitrary (but hopefully meaningful) name to
the controller as well as create a password for themselves. The controller name
needs to be unique within the context of the client. The user's password is
stored on the controller.

!!! Note: 
    Controller registration (and any other Juju operations that involves
    communication between a client and a controller) necessitates the client be
    able to contact the controller over the network on TCP port 17070. In
    particular, if using a LXD-based cloud, network routes need to be in place
    (i.e. to contact the controller LXD container the client traffic must be
    routed through the LXD host).

## User creation and controller registration

To create user 'mat' the controller administrator uses the `add-user` command:

```bash
juju add-user mat
```

This will produce output similar to:

```no-highlight
User "mat" added
Please send this command to mat:
    juju register ME0TA21hdDAWExQxMC4xNDkuMTMzLjIwOToxNzA3MAQg7D-RDR8cnioqd7ctEoCjyDzaprK4wXodvfMBBrgBUKETDGx4ZC1iaW9uaWMtMQAA

"mat" has not been granted access to any models. You can use "juju grant" to grant access.
```

The administrator provides the command (manually) to the intended operator, who
will execute it:

```bash
juju register ME0TA21hdDAWExQxMC4xNDkuMTMzLjIwOToxNzA3MAQg7D-RDR8cnioqd7ctEoCjyDzaprK4wXodvfMBBrgBUKETDGx4ZC1iaW9uaWMtMQAA
```

Sample user session:


```no-highlight
Enter a new password: 
Confirm password: 
Enter a name for this controller [lxd-bionic-1]: lxd-bionic-1
Initial password successfully set for mat.

Welcome, mat. You are now logged into "lxd-bionic-1".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

The name of the original controller, in this case 'lxd-bionic-1', is offered as
a default controller name.



<!-- LINKS -->

[users]: ./users.md
