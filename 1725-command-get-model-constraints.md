**Usage:** `juju get-model-constraints [options]`

**Summary:**

Displays machine constraints for a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= constraints)`

Specify output format (`constraints|json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Shows machine constraints that have been set on the model with `juju set-model-constraints`. By default, the model is the current model.

Model constraints are combined with constraints set on an application with `juju set-constraints` for commands (such as `deploy`) that provision machines for applications. Where model and application constraints overlap, the application constraints take precedence.

Constraints for a specific application can be viewed with `juju get-constraints`.

**Examples:**

       juju get-model-constraints
        juju get-model-constraints -m mymodel
**See also:**

[models](https://discourse.jujucharms.com/t/command-models/1771) , [get-constraints](https://discourse.jujucharms.com/t/command-get-constraints/1724) , [set-constraints](https://discourse.jujucharms.com/t/command-set-constraints/1807), [set-model-constraints](https://discourse.jujucharms.com/t/command-set-model-constraints/1813)
