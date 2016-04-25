Title: Juju workflow scenarios
TODO: 


# Workflow scenarios

To demonstrate multi-user interaction, we present several workflows. It is
assumed that Juju is installed [link to juju install page]. This presentation
will be based on the local cloud: LXD. Since LXD does not require credentials,
there will be no mention of credentials below (see
[Getting Started](./getting-started.html) for a full treatment of using LXD as
the cloud provider).


## Basic setup and single user

**Controller creation**<br/>
A system user creates a controller, thus becoming the controller's
administrator. See [Controllers](./controllers.html) for information on
controllers.

```bash
juju bootstrap lxd-controller-1 lxd
```

**Administrator password creation**<br/>
A new administrator does not have a real password. He should create it now:

```bash
juju change-user-password
```

**Regular user creation**<br/>
The administrator creates a regular user.

```bash
juju add-user tom
```

This outputs a special string to provide to the user so user registration can
take place (see below).

**Hosted model creation**<br/>
Although not strictly necessary (every controller comes
with a usable model named 'default'), the administrator creates a hosted model:

```bash
juju create-model lxd-model-1
```

**Grant model access**<br/>
The administrator grants the user write access to the previously created model:

```bash
juju grant --acl=write tom lxd-model-1
```

**User registration**<br/>
The previously created regular user registers with the controller:

```bash
juju register MD0TBGpvaG4wExMRMTAuODA...
```

The user is automatically logged in to the controller upon registration and
enjoys model access that may have been granted. Commands to try:

```bash
juju list-controllers
juju list-models
```

**Password change**<br/>
Although a password is created in the above step the regular user may want to
change it:

```bash
juju change-user-password
```

Juju usage Because the regular user has been provided write access to the model
he/she can begin to utilise Juju:

```bash
juju deploy mysql mysql-staging
```

**Logout**<br/>
A login session expires after a fixed amount of time (24 hours) but the regular
user can explicitly log out:

```bash
juju logout
```
