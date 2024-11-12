(how-to-manage-users)=
# How to manage users

> See also: {ref}`User <user>`

**Contents:**
- [Add a user](#heading--add-a-user)
- [View all the known users](#heading--view-all-the-known-users)
- [View details about a user](#heading--view-details-about-a-user)
- [View details about the current user](#heading--view-details-about-the-current-user)
- [Manage a user's access level](#heading--manage-a-users-access-level)
- [Manager a user's login details](#heading--manager-a-users-login-details)
- [Manage a user's login status](#heading--manage-a-users-login-status)
- [Manage a user's enabled status](#heading--manage-a-users-enabled-status)
- [Remove a user](#heading--remove-a-user)



 <a href="#heading--add-a-user"><h2 id="heading--add-a-user">Add a user</h2></a>

{ref}`tabs]
[tab version="juju"]

```{tip}

**If you're the controller creator:** <br> Juju has already set up a user for you. Your username is `admin` and your access level is that of controller `superuser`. Run `juju logout` to be prompted to set up a password. Use `juju change-user-password` to set the password.

```

To add a user to a controller, run the `add-user` command followed by the username you want to assign to this user. For example:

```text
juju add-user alex
````

This will create a user with username 'alex' and a controller `login` access level. 

> See more: [User access levels <user-access-levels>`

It will also print a line of code that you must give this user to run using their Juju client -- this will register the controller with their client and also prompt them to set up a password for the user.

-------
```{dropdown} Example user setup

Admin adding a new user 'alex' to the controller:

```text
# Add a user named `alex`:
$ juju add-user alex
User "alex" added
Please send this command to alex:
    juju register MFUTBGFsZXgwFRMTMTAuMTM2LjEzNi4xOToxNzA3MAQghBj6RLW5VgmCSWsAesRm5unETluNu1-FczN9oVfNGuYTFGxvY2FsaG9zdC1jb250cm9sbGVy

"alex" has not been granted access to any models. You can use "juju grant" to grant access.
```

New user 'alex' accessing the controller:

```text
$ juju register MFUTBGFsZXgwFRMTMTAuMTM2LjEzNi4xOToxNzA3MAQghBj6RLW5VgmCSWsAesRm5unETluNu1-FczN9oVfNGuYTFGxvY2FsaG9zdC1jb250cm9sbGVy
Enter a new password: ********
Confirm password: ********
Enter a name for this controller {ref}`localhost-controller]: localhost-controller
Initial password successfully set for alex.

Welcome, alex. You are now logged into "localhost-controller".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".

```

```

-----

```{note}

Controller registration (and any other Juju operations that involves communication between a client and a controller) requires that the client be able to contact the controller over the network on TCP port 17070. In particular, if using a LXD-based cloud, network routes need to be in place (i.e. to contact the controller LXD container the client traffic must be routed through the LXD host).

```

> See more: [`juju add-user` <command-juju-add-user>`,{ref}`How to register a private controller <1156md>`

[/tab]

[tab version="terraform juju"]
To add a user to a controller, in your Terraform plan add a `juju_user` resource, specifying a label, a name, and a password. For example:

```terraform
resource "juju_user" "alex" {
  name = "alex"
  password = "alexsupersecretpassword"

}
``` 

> See more: [`juju_user` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/user)
[/tab]

[tab version="python libjuju"]
To add a user to a controller, on a connected Controller object, use the `add_user()` method.

```python
await my_controller.add_user("alex")
```

> See more: [`add_user()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.add_user)
{ref}`/tab]
[/tabs]

 <a href="#heading--view-all-the-known-users"><h2 id="heading--view-all-the-known-users">View all the known users</h2></a>

[tabs]
[tab version="juju"]

To view a list of all the users known (i.e., allowed to log in) to the current controller, run the `users` command:


```text
juju users
```

The command also has flags that will allow you to specify a different controller, an output file, an output format, whether to print the full timestamp for connection times, etc.

> See more: [`juju users` <command-juju-users>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To view a list of all the users known (i.e., allowed to log in) to a controller, on a connected Controller object, use the `get_users()` method.

```python
await my_controller.get_users()
```

> See more: [`get_users()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.get_users)
{ref}`/tab]
[/tabs]

 <a href="#heading--view-details-about-a-user"><h2 id="heading--view-details-about-a-user">View details about a user</h2></a>

[tabs]
[tab version="juju"]

To view details about a specific user, run the `show-user` command followed by the name of the user. For example:

```text
juju show-user alice
```

This will display the user's username, display name (if available), access level, creation date, and last connection time, in a YAML format.


------------
```{dropdown} Expand to see a sample output for user 'admin'

```text
user-name: admin
display-name: admin
access: superuser
date-created: 8 minutes ago
last-connection: just now
```

```
-----

> See more: [`juju show-user` <1156md>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To view details about a specific user, on a connected Controller, use the `get_user()` method to retrieve a User object that encapsulates everything about that user. Using that object, you can access all the details (via the object properties) for that user.

```python
user_object = await my_controller.get_user("alice")
# Then we can access all the properties to view details
print(user_object.display_name)
print(user_object.access)
print(user_object.date_created)
print(user_object.last_connection)
```

> See more: [`get_user()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.get_user), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)
{ref}`/tab]
[/tabs]

 <a href="#heading--view-details-about-the-current-user"><h2 id="heading--view-details-about-the-current-user">View details about the current user</h2></a>

[tabs]
[tab version="juju"]

To see details about the current user, run the `whoami` command:

```text
juju whoami
```

This will print the current controller, model, and user username.


------
```{dropdown} Expand to see a sample output

```text
Controller:  microk8s-controller
Model:       <no-current-model>
User:        admin
```

```
-----

> See more: [`juju whoami` <command-juju-whoami>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To see details about the current user, on a connected Controller, use the `get_current_user()` method to retrieve a User object that encapsulates everything about the current user. Using that object, you can access all the details (via the object properties) for that user.

```python
user_object = await my_controller.get_current_user()
# Then we can access all the properties to view details
print(user_object.display_name)
print(user_object.access)
print(user_object.date_created)
print(user_object.last_connection)
```

> See more: [`get_current_user()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.get_current_user), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)
{ref}`/tab]
[/tabs]

 <a href="#heading--manage-a-users-access-level"><h2 id="heading--manage-a-users-access-level">Manage a user's access level</h2></a>
> See also: [User access levels <user-access-levels>`

[tabs]
[tab version="juju"]

The procedure for how to control a user's access level depends on whether you want to grant access at the level of the controller, model, application, or application offer or rather at the level of a cloud.

```{important}

This division doesn't currently align perfectly with the scope hierarchy, which is rather controller > cloud > model > application > offer (because the cloud scope is designed as a restriction on the controller scope for cases where multiple clouds are managed via the same controller).

```


- [Manage access at the controller, model, application, or offer level](#heading--manage-access-at-the-controller-model-application-or-offer-level)
- [Manage access at the cloud level](#heading--manage-access-at-the-cloud-level)

 <a href="#heading--manage-access-at-the-controller-model-application-or-offer-level"><h3 id="heading--manage-access-at-the-controller-model-application-or-offer-level">Manage access at the controller, model, application, or offer level</h3></a>

**Grant access.** To grant a user access at the controller, model, application, or offer level, run the `grant` command, specifying the user, applicable desired access level, and the target controller, model, application, or offer. For example:

```text
juju grant jim write mymodel
```

The command also has a flag that allows you to specify a different controller to operate in.

> See more: {ref}``juju grant` <command-juju-grant>`

**Revoke access.** To revoke a user's access at the controller, model, application, or offer level, run the `revoke` command, specifying the user, access level to be revoked, and the controller, model, application, or offer to be revoked from. For example:

```text
juju revoke joe read mymodel
```

The command also has a flag that allows you to specify a different controller to operate in.

> See more: {ref}``juju revoke` <command-juju-revoke>`


 <a href="#heading--manage-access-at-the-cloud-level"><h3 id="heading--manage-access-at-the-cloud-level">Manage access at the cloud level</h3></a>

**Grant access.** To grant a user's access at the cloud level, run the `grant-cloud` command followed by the name of the user, the access level, and the name of the cloud. For example:

```text
juju grant-cloud joe add-model fluffy
```

> See more: {ref}``juju grant-cloud` <command-juju-grant-cloud>`

**Revoke access.** To revoke a user's access at the cloud level, run the `revoke-cloud` command followed by the name of the user, the access level to be revoked, and the name of the cloud. For example:

```text
juju revoke-cloud joe add-model fluffy
```

> See more: {ref}``juju revoke-cloud` <command-juju-revoke-cloud>`

[/tab]

[tab version="terraform juju"]
With the `terraform juju` client you can manage user access only at the model level; for anything else, please use the `juju` client. 

To grant a user access to a model, in your Terraform plan add a `juju_access_model` resource, specifying the model, the access level, and the user(s) to which you want to grant access. For example:

```terraform
resource "juju_access_model" "this" {
  model  = juju_model.dev.name
  access = "write"
  users  = [juju_user.dev.name, juju_user.qa.name]
}
```

> See more: [`juju_access_model`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/access_model)
[/tab]

[tab version="python libjuju"]

To manage a user's access to a controller, a model, or an offer, on a User object, use the `grant()` and `revoke()` methods to grant or revoke a certain access level to a user. 

```python
# grant a superuser access to the controller (that the user is on)
await user_object.grant('superuser')

# grant user the access to see a model
await user_object.grant("read", model_name="test-model")

# revoke ‘read’ (and ‘write’) access from user for application offer ‘fred/prod.hosted-mysql’:
await user_object.revoke("read", offer_url="fred/prod.hosted-mysql")
```

> See more: [`grant()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User.grant),  [`revoke()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User.revoke), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)

{ref}`/tab]
[/tabs]

 <a href="#heading--manager-a-users-login-details"><h2 id="heading--manager-a-users-login-details">Manager a user's login details</h2></a>

[tabs]
[tab version="juju"]

**Set a password.** The procedure for how to set a password depends on whether you are the controller creator or rather some other user.

-  To set a password as a controller creator user ('admin'), run the `change-user-password` command, optionally followed by your username, 'admin'.

```text
juju change-user-password 
```

This will prompt you to type, and then re-type, your desired password.

> See more: [`juju change-user-password` <command-juju-change-user-password>`


- To set a password as a non-controller-creator user, follow the prompt you get when registering the controller via the `register` command.

> See more: {ref}`How to register a controller <1156md>`

**Change a password.** To change the current user's password, run the `change-user-password` command:

```text
juju change-user-password 
```

This will prompt you to type, and then re-type, your desired password.

The command also allows an optional username argument, and flags, allowing an admin to change / reset the password for another user.

> See more: {ref}``juju change-user-password` <command-juju-change-user-password>`

[/tab]

[tab version="terraform juju"]
To set or change a user's password, in your Terraform plan add, in the relevant `juju_user` resource definition, change the `password` attribute to the desired value. For example:

```terraform
resource "juju_user" "alex" {
  name = "alex"
  password = "alexnewsupersecretpassword"

}
``` 

> See more: [`juju_user`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/user#password)
[/tab]

[tab version="python libjuju"]

To set or change a user's password, on a User object, use the `set_password()` method.

```python
await user_object.set_password('123')
```

> See more: [`set_password()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User.set_password), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)

{ref}`/tab]
[/tabs]

 <a href="#heading--manage-a-users-login-status"><h2 id="heading--manage-a-users-login-status">Manage a user's login status</h2></a>

[tabs]
[tab version="juju"]

**Log in.** 

```{important}

**If you're the controller creator:** <br> You've already been logged in as the `admin` user. To verify, run `juju whoami` or `juju show-user admin`; to set a password, run `juju change-user-password` to set a password; to log out, run `juju logout`.

```

```{important}

**If you've just registered an external controller with your client (via `juju register`):** <br> You're already logged in. Run `juju whoami` or `juju show-user <username>` to view your user details. 

```

To log in as a user on the current controller, run the `login` command, using the `-u` flag to specify the user you want to log in as. For example:

```text
juju login -u alice
```

This will prompt you to enter the password.

The command also has flags that allow you to specify a controller, etc.

> See more: [`juju login` <command-juju-login>`

**Log out.**

```{important}

**If you're the controller creator, and you haven't set a password yet:** <br> You will be prompted to set a password. Make sure to set it before logging out. 

```

To log a user out of the current controller, run the `logout` command:

```text
juju logout
```

> See more: {ref}``juju logout` <command-juju-logout>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

 <a href="#heading--manage-a-users-enabled-status"><h2 id="heading--manage-a-users-enabled-status">Manage a user's enabled status</h2></a>

[tabs]
[tab version="juju"]

To disable a user on the current controller, run the `disable-user` command followed by the name of the user. For example:

```text
juju disable-user mike
```

> See more: [`juju disable-user` <command-juju-disable-user>`

```{tip}

**To view disabled users in the output of `juju users`:** Use the `--all` flag.

```

To re-enable a disabled user on a controller, run the `enable-user` command followed by the name of the user. For example:

```text
juju enable-user mike
```

> See more: {ref}``juju enable-user` <command-juju-enable-user>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To enable or disable a user, on a User object, use the `enable()` and `disable()` methods.

```python
await user_object.enable()

await user_object.disable()
```

You can also check if a user is enabled or disabled using the `enabled` and `disabled` properties on the Unit object.

```python
# re-enable a disabled user
if user_object.disabled:
    await user_object.enable()
```

> See more: [`enable()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User.enable), [`disable()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User.disable), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)
{ref}`/tab]
[/tabs]

 <a href="#heading--remove-a-user"><h2 id="heading--remove-a-user">Remove a user</h2></a>

[tabs]
[tab version="juju"]

To remove a user from the current controller, run the `remove-user` command followed by the name of the user. For example:

```text
juju remove-user bob
```

This will prompt you to confirm, and then proceed to remove.

The command also has flags that allow you to specify a different controller, skip the confirmation, etc.

> See more: [`juju remove-user` <command-juju-remove-user>`

[/tab]

[tab version="terraform juju"]
To remove a user, in your Terraform plan remove its resource definition.

> See more: [`juju_user` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/user)

[/tab]

[tab version="python libjuju"]

To remove a user, on a connected Controller object, use the `remove_user()` method.

```python
await my_controller.remove_user("bob")
```

> See more: [`remove_user()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.controller.html#juju.controller.Controller.remove_user), [User (module)](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.user.html#juju.user.User)

[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @hmlanigan, @pedroleaoc, @pmatulis, @timclicks, @tmihoc </small>