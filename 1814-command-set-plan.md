**Usage:** `juju set-plan [options] <application name> <plan>`

**Summary:**

Set the plan for an application.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Set the plan for the deployed application, effective immediately.

The specified plan name must be a valid plan that is offered for this particular charm. Use `juju list-plans ` for more information.

**Examples:**

`   juju set-plan myapp example/uptime`
