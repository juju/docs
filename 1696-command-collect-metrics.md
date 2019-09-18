**Usage:** `juju collect-metrics [options] [application or unit]`

**Summary:**

Collect metrics on the given unit/application.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Trigger metrics collection This command waits for the metric collection to finish before returning. You may abort this command and it will continue to run asynchronously. Results may be checked by `juju show-action-status`.
