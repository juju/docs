(user)=
# User

<!--TODOS INHERITED FROM 
Todo:
- bug tracking: https://bugs.launchpad.net/bugs/1808661
- bug tracking: https://bugs.launchpad.net/bugs/1808662
-->

> See also: {ref}`How to manage users <how-to-manage-users>`

In Juju, a **user** is any person able to log in to a Juju {ref}`controller <controller>`. 

```{note}

Juju users are not related in any way to the client system users. 

```

Users can be created in two ways: Implicitly by bootstrapping a controller into a cloud or explicitly by adding a user to a controller (`juju add-user`). 

A user logs in to a Juju controller using a username and a password. The user created implicitly gets the username `admin` and  is prompted to create a password the first time they attempt to log out. A user created explicitly gets the username assigned to them when being added (via `juju add-user`) and is prompted to create login details when they register the new controller with their Juju client. 


```{note}

A user's username and password are entirely different from the credentials referenced in `juju` commands such as `add-credential`---those are about access to a cloud, whereas these are about access to a Juju controller.

```

```{important}

Multiple users can be accommodated by the same Juju client. However, there can only be one user logged in at a time.

```

<!--
Juju has an internal user framework that allows for the sharing of controllers and models. To achieve this, a Juju user can be created, disabled, and have rights granted and revoked. Users remote to the system that created a controller can use their own Juju client to log in to the controller and manage the environment based on the rights conferred. 
-->

Every user is associated with an access level. The default level for the user created implicitly (`admin`) is the controller `superuser` access level, which means they can do everything at the level of the entire controller. The default level for a user created explicitly is the controller `login` level, which means they can do nothing on the controller other than register it with their client and log in to it -- for anything more they must be granted a higher level explicitly.

> See more: {ref}`User access levels <user-access-levels>`