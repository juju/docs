**Usage:** `juju disable-command [options] <command set> [message...]`

**Summary:**

Disable commands for the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Juju allows to safeguard deployed models from unintentional damage by preventing execution of operations that could alter model.

This is done by disabling certain sets of commands from successful execution. Disabled commands must be manually enabled to proceed.

Some commands offer a `--force option` that can be used to bypass the disabling. Commands that can be disabled are grouped based on logical operations as follows: `destroy-model` prevents:

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

To prevent the model from being destroyed:

`   juju disable-command destroy-model "Check with SA before destruction."`

To prevent the machines, applications, units and relations from being removed:

`   juju disable-command remove-object`

To prevent changes to the model:

`   juju disable-command all "Model locked down"`

**See also:**

[disabled-commands](https://discourse.jujucharms.com/t/command-disabled-commands/1714), [enable-command](https://discourse.jujucharms.com/t/command-enable-command/1716)
