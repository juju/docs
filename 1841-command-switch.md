**Usage:** `juju switch [options] [<controller>|<model>|<controller>:|:<model>|<controller>:<model>]`

**Summary:**

Selects or identifies the current controller and model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

**Details:**

When used without an argument, the command shows the current controller and its active model. When a single argument without a colon is provided juju first looks for a controller by that name and switches to it, and if it's not found it tries to switch to a model within current controller. mycontroller: switches to default model in mycontroller, :mymodel switches to mymodel in current controller and mycontroller:mymodel switches to mymodel on mycontroller. The `juju models` command can be used to determine the active model (of any controller). An asterisk denotes it.

**Examples:**

       juju switch
        juju switch mymodel
        juju switch mycontroller
        juju switch mycontroller:mymodel
        juju switch mycontroller:

        juju switch :mymodel
**See also:**

[controllers](https://discourse.jujucharms.com/t/command-controllers/1700), [models](https://discourse.jujucharms.com/t/command-models/1771), [show-controller](https://discourse.jujucharms.com/t/command-show-controller/1821)
