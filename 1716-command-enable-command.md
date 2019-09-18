**Usage:** `juju enable-command [options] <command set>`

**Summary:**

Enable commands that had been previously disabled.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Juju allows to safeguard deployed models from unintentional damage by preventing execution of operations that could alter model.

This is done by disabling certain sets of commands from successful execution. Disabled commands must be manually enabled to proceed.

Some commands offer a `--force` option that can be used to bypass a block. Commands that can be disabled are grouped based on logical operations as follows: `destroy-model` prevents:

         destroy-controller
          destroy-model
`remove-object` prevents:

         destroy-controller
          destroy-model
          remove-machine
          remove-relation
          remove-application
          remove-unit
`all` prevents:

         add-machine
          add-relation
          add-unit
          add-ssh-key
          add-user
          change-user-password
          config
          deploy
          disable-user
          destroy-controller
          destroy-model
          enable-ha
          enable-user
          expose
          import-ssh-key
          model-config
          remove-application
          remove-machine
          remove-relation
          remove-ssh-key
          remove-unit
          resolved
          retry-provisioning
          run
          set-constraints
          sync-agents
          unexpose
          upgrade-charm
          upgrade-model
**Examples:**

To allow the model to be destroyed:

`   juju enable-command destroy-model`

To allow the machines, applications, units and relations to be removed:

`   juju enable-command remove-object`

To allow changes to the model:

`   juju enable-command all`

**See also:**

[disable-command](https://discourse.jujucharms.com/t/command-disable-command/1712), [disabled-commands](https://discourse.jujucharms.com/t/command-disabled-commands/1714)
