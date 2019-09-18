**Usage:** `juju debug-hooks [options] <unit name> [hook or action names]`

**Summary:**

Launch a tmux session to debug hooks and/or actions.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-host-key-checks (= false)`

Skip host key checking (INSECURE)

`--proxy (= false)`

Proxy through the API server

`--pty (= <auto>)`

Enable pseudo-tty allocation

**Details:**

Interactively debug hooks or actions remotely on an application unit.

See the `juju help ssh` for information about SSH related options accepted by the debug-hooks command.
