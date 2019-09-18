**Usage:** `juju run-action [options] <unit> [<unit> ...] <action name> [key.key.key...=value]`

**Summary:**

Queue an action for execution.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--format (= yaml)`

Specify output format (`json|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--params (= )`

Path to yaml-formatted params file

`--string-args (= false)`

Use raw string values of CLI args

`--wait (= )`

Wait for results, with optional timeout

**Details:**

Queue an Action for execution on a given unit, with a given set of params. The Action ID is returned for use with `juju show-action-output` or `juju show-action-status`.

Valid unit identifiers are: a standard unit ID, such as mysql/0 or; leader syntax of the form /leader, such as mysql/leader.

If the leader syntax is used, the leader unit for the application will be resolved before the action is enqueued.

Params are validated according to the charm for the unit's application. The valid params can be seen using `juju actions --schema`.

Params may be in a yaml file which is passed with the `--params` option, or they may be specified by a key.key.key...=value format (see examples below.) Params given in the CLI invocation will be parsed as YAML unless the `--string-args` option is set. This can be helpful for values such as 'y', which is a boolean true in YAML.

If `--params` is passed, along with key.key...=value explicit arguments, the explicit arguments will override the parameter file.

**Examples:**

    $ juju run-action mysql/3 backup --wait action-id: result:

     status: success
      file:

        size: 873.2
        units: GB
        name: foo.sql
$ juju run-action mysql/3 backup action:

$ juju run-action mysql/leader backup resolved leader: mysql/0 action:

$ juju show-action-output result:

     status: success
      file:

        size: 873.2
        units: GB
        name: foo.sql
$ juju run-action mysql/3 backup --params parameters.yml ...

Params sent will be the contents of parameters.yml.

...

$ juju run-action mysql/3 backup out=out.tar.bz2 file.kind=xz file.quality=high ...

Params sent will be:

out: out.tar.bz2 file:

     kind: xz
      quality: high
...

$ juju run-action mysql/3 backup --params p.yml file.kind=xz file.quality=high ...

If p.yml contains:

file:

     location: /var/backups/mysql/
      kind: gzip
then the merged args passed will be:

file:

     location: /var/backups/mysql/
      kind: xz
      quality: high
...

$ juju run-action sleeper/0 pause time=1000 ...

$ juju run-action sleeper/0 pause --string-args time=1000 ...

The value for the "time" param will be the string literal "1000".
