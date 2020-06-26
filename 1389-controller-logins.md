When a Juju user logs in to a controller there are two basic scenarios:

- Logging in during user initialisation
- Logging in with an existing user

Each of these are described in greater detail on this page.

Terminology: A *known* controller is one that the local Juju client is aware of. It shows up in the output for the `controllers` command and has its metadata recorded in `~/.local/share/juju/controllers.yaml`.

## Logging in during user initialisation

This scenario covers the case where a Juju user has never logged in to a controller. Doing so for the first time initialises the user, which involves, in particular, the creation of a password on the part of the Juju administrator. There are two sub-cases:

- Using the initial user token
- Using a re-generated user token

Doing either results in the controller becoming known to the client.

### Using the initial user token

This is the "normal" way for initialising a user.

When a Juju user is added to a controller with the `add-user` command a token is printed. This is provided to the person who will interact with Juju as that user. This token is then supplied to the `register` command to register, and log in to, the controller:

```text
juju register MHMTBHdpbGwUNTQuMjI2LjI....MCoLdEXylP6MRWITCHNvbWUtYXdz
```

Sample output:

```text
Enter a new password: *******
Confirm password: *******
Enter a name for this controller [some-aws]: that-aws
Initial password successfully set for will.

Welcome, will. You are now logged into "that-aws".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

The end result is that the controller is now known to this client:

```text
juju controllers
```

Output:

```text
Use --refresh option with this command to see the latest information.

Controller  Model  User  Access  Cloud/Region  Models  Nodes  HA  Version
that-aws*   -      will  login                      -      -   -  2.6-beta2
```

### Using a re-generated user token

There are some valid situations where a registration token may need to be re-generated for a Juju user:

- A login is desired from multiple clients.
- The original token was simply misplaced.

The end result is the same as in the first scenario. A new user will be initialised. 

This is done with the `change-user-password` command:

```text
juju change-user-password --reset fred
```

Sample output:

```text
Password for "fred" has been reset.
Ask the user to run:
     juju register MHMTBHdpbGwwPxMUNQuMjI2LjI....IuMTonqYile1dhwTCHNvbWUtYXdz
```

Any previously generated token for user 'fred' is automatically invalidated.

## Logging in with an existing user

This scenario covers the case where a Juju user has already logged in to the controller at least once from any device. Here, Juju is expecting a specific password for authentication to succeed. There are two sub-cases:

- Referencing a known controller by name
- Referencing an unknown controller by API endpoint

The API method results in the controller becoming known to the client.

### Referencing a known controller by name

This is the "normal" way for logging in to a controller:

```text
juju login -c this-aws
```

Output:

```text
Enter username: mike

please enter password for mike on this-aws: *******
Welcome, mike. You are now logged into "this-aws".

There are no models available. You can add models with
"juju add-model", or you can ask an administrator or owner
of a model to grant access to that model with "juju grant".
```

The `login` command also accepts a username with the `-u` option.

## Logging in to an unknown controller via an API endpoint

Beginning with `v.2.6.0`, a controller can be accessed via its API endpoint.

A few use cases for this feature:

- A login is desired from multiple clients
- A controller is migrated and Juju users need to reconnect

The controller's CA certificate is used to identify the controller to the Juju administrator. A fingerprint of the certificate will be displayed and the administrator will need to confirm that fingerprint before connecting.

If the controller is already known to the client then the command will print output guiding the administrator to use the non-API method, and then exit.

[note type="caution" status="Note"]
The endpoint method of logging in will only work if the controller itself is running `v.2.6.0`.
[/note]

### Example

The API endpoint can be obtained from the `show-controller` command on a client currently connected to the controller:

```text
juju show-controller | grep endpoints
```

Sample output:

```text
    api-endpoints: ['54.226.250.155:17070']
```

The fingerprint of the CA certificate can be found similarly:

```text
juju show-controller | grep fingerprint
```

Sample output:

```text
    ca-fingerprint: FA:B6:E3:E5:86:61:2F:D0:C8:45:DF:62:49:57:4C:78:BC:FE:83:79:29:71:49:E2:9E:D2:E2:18:2E:37:E9:EF
```

And now from a separate device:

```text
juju login 54.226.250.155:17070 -c some-aws
```

The controller name is arbitrary, but hopefully meaningful, just like it is during the standard registration process.

Sample output:

```text
Controller "54.226.250.155:17070" presented a CA cert that could not be verified.
CA fingerprint: [FA:B6:E3:E5:86:61:2F:D0:C8:45:DF:62:49:57:4C:78:BC:FE:83:79:29:71:49:E2:9E:D2:E2:18:2E:37:E9:EF]
Trust remote controller? (y/N): y

Enter username: admin

Enter password: *******

Welcome, admin. You are now logged into "some-aws".

There are 2 models available. Use "juju switch" to select
one of them:
  - juju switch controller
  - juju switch default
```

The end result is that the controller is now known to this client:

```text
juju controllers
```

Output:

```text
Use --refresh option with this command to see the latest information.

Controller  Model  User   Access     Cloud/Region  Models  Nodes    HA  Version
some-aws*   -      admin  superuser                     2      1  none  2.6-beta2
```
