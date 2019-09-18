**Usage:** `juju consume [options] <remote offer path> [<local application name>]`

**Summary:**

Add a remote offer to the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Adds a remote offer to the model. Relations can be created later using `juju relate`. The remote offer is identified by providing a path to the offer:

         [<model owner>/]<model name>.<application name>
              for an application in another model in this controller (if owner isn't specified it's assumed to be the logged-in user)
**Examples:**

       $ juju consume othermodel.mysql
        $ juju consume owner/othermodel.mysql
        $ juju consume anothercontroller:owner/othermodel.mysql
**See also:**

[add-relation](https://discourse.jujucharms.com/t/command-add-relation/1674), [offer](https://discourse.jujucharms.com/t/command-offer/1772)
