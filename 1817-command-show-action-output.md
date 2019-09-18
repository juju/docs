**Usage:** `juju show-action-output [options] <action ID>`

**Summary:**

Show results of an action by ID.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--wait (= "-1s")`

Wait for results

**Details:**

Show the results returned by an action with the given ID. A partial ID may also be used. To block until the result is known completed or failed, use the `--wait` option with a duration, as in `--wait 5s` or `--wait 1h`. Use `--wait 0` to wait indefinitely. If units are left off, seconds are assumed.

The default behavior without `--wait` is to immediately check and return; if the results are "pending" then only the available information will be displayed. This is also the behavior when any negative time is given.
