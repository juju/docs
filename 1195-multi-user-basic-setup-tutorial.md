*This is a tutorial in connection with the multi-user framework of Juju. See [Working with multiple users](/t/working-with-multiple-users/1156) for background information.*

This tutorial will give an overview of how Juju can be used with one person assuming the role of a system administrator and a second person acting as the Juju administrator. 

The system administrator creates the controller, creates users, and grants user permissions whereby the operator is responsible for creating models and installing software.

The following topics will be covered:

-   Controller creation and the initial controller administrator
-   User creation and controller registration
-   User login, logout, and password changing
-   User model creation
-   User charm deployment

<h2 id="heading--controller-creation-and-the-initial-controller-administrator">Controller creation and the initial controller administrator</h2>

Besides resulting in a new controller the `bootstrap` command sets up a Juju user called 'admin' with controller permissions of 'superuser'. This is the initial controller administrator.

Here we'll add credentials and then create a GCE-based controller:

``` text
juju add-credential google -f credentials-administrator.yaml
juju bootstrap google gce
```

In the above the credentials file contains a single credential for the 'google' cloud, allowing it to become the default credential in the subsequent `bootstrap` command.

Inspecting the controller's users with the `users` command allows us to confirm the above information:

``` text
juju users
```

Example output:

``` text
Controller: gce

Name    Display name  Access     Date created   Last connection
admin*  admin         superuser  2 minutes ago  just now
```

Note that the new administrator does not have a password per se. Create one now:

``` text
juju change-user-password
```

<h2 id="heading--user-creation-and-controller-registration">User creation and controller registration</h2>

Let the administrator now create a regular user called 'tom':

``` text
juju add-user tom
```

The output of `juju add-user` includes a string (token) to send to the new user. This will enable that administrator to register the  controller to their own Juju client.

Sample output:

``` text
User "tom" added
Please send this command to tom:
    juju register MGcTA3RvbTA5ExQzNS4yMzcuMTY1LjI[...]

"tom" has not been granted access to any models. You can use "juju grant" to grant access.
```

[note type="caution"]
The client host must be able to contact the controller host on TCP port 17070 in order for controller registration to succeed. This is the case for any client-controller communication.
[/note]

Registration is done with the `register` command. On a separate host, then:

``` text
juju register MGcTA3RvbTA5ExQzNS4yMzcuMTY1LjI[...]
```

Example output:

``` text
Enter a new password: ******
Confirm password: ******
Enter a name for this controller [gce]: 
Initial password successfully set for tom.

Welcome, tom. You are now logged into "gce".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

<h2 id="heading--user-login-logout-and-password-changing">User login, logout, and password changing</h2>

A newly-created user is granted controller access of 'login' out of the box (implicitly: `juju grant -c gce tom login`). So besides logging in, the user cannot do much else.

Registration implies a controller login (as can be seen by the previous command's messaging). To log out, use the `logout` command:

``` text
juju logout
```

A login session also expires after a fixed amount of time (24 hours).

To log back in, use the `login` command with the username as argument. Provide the password that was set up during registration:

``` text
juju login -u tom
```

Supply a controller name (`-c gce`) if there is more than one controller registered with the client.

Change the user's password with the `change-user-password` command:

``` text
juju change-user-password
```

<h2 id="heading--user-model-creation">User model creation</h2>

In order for users to be able to add models, the admin user must grant 'add-model' access to them:

``` text
juju grant tom add-model
```

Yet before the grantee is able to create a model with the new permissions, a credential needs to be added to Juju. 

On the user's host, add a credential and then `juju add-model` will succeed:

``` text
juju add-credential google -f credentials-tom.yaml
juju add-model gce-model-1
```

In the above the credentials file (`credentials-tom.yaml`) contains a single credential for the 'google' cloud, allowing it to become the default credential in the subsequent `add-model` command.

<h2 id="heading--user-model-ssh-access">User model SSH access</h2>

The operator user can now connect, using Juju's `ssh` command, to any machine that may get created within their new model. This is standard Juju behaviour that the model creator always enjoys. Note, however, that the SSH keys necessary for this to work are found within the client system's filesystem at `~/.local/share/juju/ssh/juju_id_rsa.pub` (and `~/.ssh/id_rsa.pub` if it existed at the time of model creation).

Verify SSH access now on the operator host:

``` text
juju add-machine
juju ssh 0
```

Above we assume the machine that was added got assigned an ID of '0' (the default for the first machine in a model).

<h2 id="heading--user-charm-deployment">User charm deployment</h2>

The operator user can now deploy charms as normal. See [Deploying applications](/t/deploying-applications/1062) for help.

That's the end of this tutorial!

<!-- LINKS -->
