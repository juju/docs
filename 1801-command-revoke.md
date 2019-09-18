**Usage:** `juju revoke [options] <user name> <permission> [<model name> ... | <offer url> ...]`

**Summary:**

Revokes access from a Juju user for a model, controller, or application offer.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

By default, the controller is the current controller.

Revoking write access, from a user who has that permission, will leave that user with read access. Revoking read access, however, also revokes write access.

**Examples:**

Revoke 'read' (and 'write') access from user 'joe' for model 'mymodel':

`   juju revoke joe read mymodel`

Revoke 'write' access from user 'sam' for models 'model1' and 'model2':

`   juju revoke sam write model1 model2`

Revoke 'read' (and 'write') access from user 'joe' for application offer 'fred/prod.hosted-mysql':

`   juju revoke joe read fred/prod.hosted-mysql`

Revoke 'consume' access from user 'sam' for models 'fred/prod.hosted-mysql' and 'mary/test.hosted-mysql':

`   juju revoke sam consume fred/prod.hosted-mysql mary/test.hosted-mysql`

**See also:**

[grant](https://discourse.jujucharms.com/t/command-grant/1726)
