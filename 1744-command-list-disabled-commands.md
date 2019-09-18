**Usage:** `juju disabled-commands [options]`

**Summary:**

List disabled commands.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--all (= false)`

Lists for all models (administrative users only)

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

List disabled commands for the model.

Commands that can be disabled are grouped based on logical operations as follows: `destroy-model` prevents:

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
**See also:**

[disable-command](https://discourse.jujucharms.com/t/command-disable-command/1712), [enable-command](https://discourse.jujucharms.com/t/command-enable-command/1716)

**Aliases:**

list-disabled-commands
