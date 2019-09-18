**Usage:** `juju set-model-constraints [options] <constraint>=<value> ...`

**Summary:**

Sets machine constraints on a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Sets machine constraints on the model that can be viewed with `juju get-model-constraints`. By default, the model is the current model. Model constraints are combined with constraints set for an application with `juju set-constraints` for commands (such as `deploy`) that provision machines for applications. Where model and application constraints overlap, the application constraints take precedence.

Constraints for a specific application can be viewed with `juju get-constraints`.

**Examples:**

       juju set-model-constraints cores=8 mem=16G
        juju set-model-constraints -m mymodel root-disk=64G
**See also:**

[models](https://discourse.jujucharms.com/t/command-models/1771), [get-model-constraints](https://discourse.jujucharms.com/t/command-get-model-constraints/1725), [get-constraints](https://discourse.jujucharms.com/t/command-get-constraints/1724), [set-constraints](https://discourse.jujucharms.com/t/command-set-constraints/1807)
