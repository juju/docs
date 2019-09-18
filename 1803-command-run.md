**Usage:** `juju run [options] <commands>`

**Summary:**

Run the commands on the remote targets specified.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-a, --app, --application (= )`

One or more application names

`--all (= false)`

Run the commands on all the machines

`--format (= default)`

Specify output format (`default|json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--machine (= )`

One or more machine ids

`-o, --output (= "")`

Specify an output file

`--timeout (= 5m0s)`

How long to wait before the remote command is considered to have failed

`-u, --unit (= )`

One or more unit ids

**Details:**

Run a shell command on the specified targets. Only admin users of a model are able to use this command.

Targets are specified using either machine ids, application names or unit names. At least one target specifier is needed.

Multiple values can be set for `--machine`, `--application`, and `--unit` by using comma separated values.

If the target is a machine, the command is run as the "root" user on the remote machine.

Some options are shortened for usabilty purpose in CLI `--application` can also be specified as `--app` and `-a --unit` can also be specified as `-u` If the target is an application, the command is run on all units for that application. For example, if there was an application "mysql" and that application had two units, "mysql/0" and "mysql/1", then `--application mysql`

is equivalent to `--unit mysql/0,mysql/1`

Commands run for applications or units are executed in a 'hook context' for the unit.

`--all` is provided as a simple way to run the command on all the machines in the model. If you specify `--all` you cannot provide additional targets.

Since `juju run` creates actions, you can query for the status of commands started with `juju run` by calling `juju show-action-status --name juju-run`. If you need to pass options to the command being run, you must precede the command and its arguments with `--`, to tell `juju run` to stop processing those arguments. For example:

         juju run --all -- hostname -f
