Title: implementing actions in juju charms

# Actions for the Charm author

Actions are scripts, binaries, or other executables defined on a charm which may
be invoked or queued remotely by the user on demand.  For example, the Charm
author might include a `snapshot` Action on a database Charm.  
[See here for more on Actions and their use](actions.html).

The user may give arguments when invoking the Action.  Complex, nested arguments
are possible.  The Charm uses a file named `actions.yaml` to specify the type
and parameters of these arguments.  On [juju-gui](howto-gui-management.html),
the UI for an Action invocation will be automatically built based on
`actions.yaml`.

[Action Tools](#action-tools) may be used by the author to define how Actions
interact with Juju.  Actions can retrieve params passed by the user, set
responses in a map, or set a failure status with a message.

## Defining Actions

To define the Actions available on a Charm, executables (scripts, binaries,
etc.) for each Action must be included in the `/actions` directory in the Charm,
and the name of each executable must be a top-level key in a YAML map in 
`/actions.yaml` in the Charm root:

Charm dir:
```nohighlight
├── actions
│   ├── pause
│   ├── resume
│   └── snapshot
├── actions.yaml
...
```

`actions.yaml` defining three rudimentary Actions:
```yaml
pause:
  description: Pause the database.
resume:
  description: Resume a paused database.
snapshot:
  description: Take a snapshot of the database.
```

Actions may be called with parameters.  These parameters are specified as a
child YAML map under a `params` key for each Action in `actions.yaml`.  Note
that Actions support [JSON-Schema](http://json-schema.org) to enable nested
schemas, and many other features. 

#### A simple Action schema showing the use of `params` 
```yaml
snapshot:
  description: Take a snapshot of the database.
  params:
    outfile:
      type: string
      description: The filename to write to.
  required: [outfile]
  additionalProperties: false
```

[See below](#example-schema) for a more detailed example.


### Schema Requirements

`actions.yaml` must be included in the charm root, and must conform to the
following requirements:

 - Each Action is defined as a top-level key of a YAML map, with the same name
   as the script it defines.
 - The value of each Action must be a map, which should include a `description`
   key and may include a `params` key to define a schema.  If no `description`
   is given, a default empty description will be used.
 - The value of `params`, if it is included, must be a YAML map.  Each key under
   `params` must be a string, and must have valid
   [JSON-Schema](http://json-schema.org/example2.html)
   as its value, transformed to a YAML map.  JSON-Schema  may be nested to
   create complex schemas.
 - JSON-Schema defines special keys such as `required` and
   `additionalProperties`, which may be given for the whole action at the same
   level as `description` and `params`, or within nested schemas at the usual
   level.
 - At this time, the `$schema` and `$ref` keys are not supported by Juju, as
   they may trigger resolution of remote objects and other issues.
 - `additionalProperties: false` should be included at the same level as the
   `description` key if additional params passed by the user should be rejected.

### Example Schema

Charm dir:
```nohighlight
├── actions
│   ├── report
│   └── snapshot
├── actions.yaml
...
```

#### actions.yaml example
```yaml
# actions.yaml

report:
  description: Make a report of the system status.
snapshot: 
  description: Take a snapshot of the database.
  params:
    filename: 
      type: string
      description: The name of the snapshot file.
    compression:
      type: object
      description: The type of compression to use.
      properties:
        kind:
          type: string
          enum: [gzip, bzip2, xz]
        quality:
          description: Compression quality
          type: integer
          minimum: 0
          maximum: 9
  required: [filename]
  additionalProperties: false
```

This schema would support a call such as:

```bash
juju action do mysql/0 snapshot filename=out.tar.gz compression.type=gzip
```

### Action Tools

Three tools are provided to the Action author for the Action to interact with Juju:

 - [`action-get`](#action-get) retrieves the params passed when invoking the Action.
 - [`action-set`](#action-set) sets values in a map to be returned after the Action finishes.
 - [`action-fail`](#action-fail) sets the Action status to `failed` when it finishes, with a message to be returned to the user.  The results set by `action-set` are preserved.

Use `juju help-tool <tool name>` to see more detail on each tool.

#### action-get

`action-get` prints the value of the parameter at the given key, serialized
according to the `--format` option.  If multiple keys are passed, action-get
will recurse into the param map as needed.

For example, if an action named `snapshot` was defined on a mysql charm, and was
invoked by the user as follows:

```bash
juju action do mysql/0 snapshot outfile="foo"
```

then the `snapshot` could use `action-get` to retrieve the filename as follows:

```bash
#!/bin/bash
# An Action named "snapshot"

action-get outfile
# "foo" will be printed
```

#### action-set

`action-set` permits the Action to set results in a map to be returned at
completion of the Action.

#### Example:
```bash
#!/bin/bash
# An Action named "report"

action-set result-map.time-completed="$(date)" result-map.message="Hello world!"
action-set outcome="success"
```

#### Results for this Action
```nohighlight
juju action fetch <some action ID>

# ...
message: "" # No error message.
results:
  result-map:
    time-completed: <some date>
    message: Hello world!
  outcome: success
status: completed
```
Note that there are some restrictions on the names you can give to action 
keys: they must start and end with lowercase alphanumeric characters, and 
only contain lowercase alphanumeric characters, the hyphen "-" or full 
stop "." characters.

#### action-fail

`action-fail` causes the Action to finish as `failed` after completion.  This
might be used to indicate a full disk if a database dump was attempted, or
perhaps to indicate that a remote service was unable to be resolved. The
results set by `action-set` before or after failure are retained, and an Action
fail status cannot be unset.

#### Example:
```bash
# An Action named "sayhello"
command=$(action-get command)

action-set received.value="$command"

if [ "$command" != "hello" ];
  then
    action-fail "I only know one command."
    action-set received.known="no"
  else
    action-set received.known="yes"
fi

action-set timestamp="$(date)"
```

```bash
juju action do <unit> sayhello command="greetme"
# ...
```

#### Results
```yaml
message: I only know one command.
results:
  received:
    known: no
    value: greetme
  timestamp: Thu Jan 15 13:28:25 EST 2015
status: failed
```

---

## Params Transformation

This section specifies the transformation from `params` to JSON-Schema.  This is
meant as a clarifying aid to creating more complex schemas and should not be
necessary for most Actions.  If that is what the reader seeks, read on! 

The `params` key of an action in `actions.yaml` defines a YAML map which is
transformed to JSON-Schema as follows: 

```yaml
# actions.yaml
<string A>:
  [description: <string AB>]
  [params:
    <string PAA>:
      <YAML map YAA>
    <string PAB>: 
      <YAML map YAB>]
  [string C]: X
  [string D]: Y
  [string ...]: Z
<string B>:
  ...
```

will define an Action for `<A>` (and `<B>`, `<C>`, and so on) with JSON-Schema:

```json
{
  "description": "<AB>",
  "title": "<A>",
  "type": "object",
  "properties": {
    "<PAA>": {YAA as JSON},
    "<PAB>": {YAB as JSON}
  },
  "required": ["filename"],
  "<C>": X,
  "<D>": Y,
  ...
}
```

which is valid JSON-Schema.

### Simple YAML transform example

For example, a simple schema such as:

```yaml
# actions.yaml
snapshot:
  description: Take a snapshot of the database.
  params:
    outfile:
      type: string
```

will be transformed to an Action with JSON-Schema:

```json
{
  "description": "Take a snapshot of the database.",
  "title": "snapshot",
  "type": "object",
  "properties": {
    "outfile": {
      "type": "string"
    }
  }
}
```

### More complex YAML transform example

The first example given at the top of this document would transform as follows:

```yaml
# actions.yaml
report:
snapshot: 
  description: Take a snapshot of the database.
  params:
    filename: 
      type: string
      description: The name of the snapshot file.
    compression:
      type: object
      description: The type of compression to use.
      properties:
        kind:
          type: string
          enum: [gzip, bzip2, xz]
        quality:
          description: Compression quality
          type: integer
          minimum: 0
          maximum: 9
  required: [filename]
  additionalProperties: false
```

becomes two Actions, with respective JSON-Schema:

report:
```json
{
  "description": "No description",
  "title": "report",
  "type": "object",
  "properties": {}
}
```

snapshot:
```json
{
  "description": "Take a snapshot of the database.",
  "title": "snapshot",
  "type": "object",
  "properties": {
    "filename": {
      "type": "string",
      "description": "The name of the snapshot file."
    },
    "compression": {
      "type": "object",
      "description": "The type of compression to use.",
      "properties": {
        "kind": {
          "type": "string",
          "enum": ["gzip", "bzip2", "xz"]
        },
        "description": {
          "type": "integer",
          "description": "Compression quality",
          "minimum": 0,
          "maximum": 9
        }
      }
    }
  },
  "required": ["filename"],
  "additionalProperties": "false"
}
```
