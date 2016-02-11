Title: Implementing actions in Juju charms  


# Actions for the charm author

Actions are executables associated with a charm that may be invoked by the user.
For example, the charm author might include a `snapshot` action on a database
charm. See [Juju Actions](./actions.html) on how to use actions.

The user may pass arguments when invoking the action. The charm uses an
`actions.yaml` file to specify the parameter type for the arguments. In the
[Juju GUI](./juju-gui-management.html), the invocation of an action will be
automatically built based on `actions.yaml`.

[Action tools](#action-tools) may be used by the author to define how actions
interact with Juju. Actions can retrieve parameters passed by the user, set
responses in a map, or set a failure status with a message.

## Implementing actions

Every implemented action must include:

 - its executable (script, binary, etc.) in the charm's `/actions` directory.
 - the executable's name as a top-level key in a YAML map in the `actions.yaml`
   file.

!!! Note: action names must start and end with lowercase alphanumeric
characters, and only contain lowercase alphanumeric characters, the hyphen "-"
or full stop"." characters.

Here is a sample partial layout of a charm's root directory that shows actions
called 'pause', 'resume', and 'snapshot':

```nohighlight
├── actions
│   ├── pause
│   ├── resume
│   └── snapshot
├── actions.yaml
...
```

Below is an `actions.yaml` file that shows the three executables as "top-level
keys":

```yaml
pause:
resume:
snapshot:
```

That is a "barebones" configuration. As the next section will make clear, there
is a lot more that can, and should, be placed in this file.

## Options and format: `actions.yaml`

Here is a list of options that can be used in `actions.yaml` along with their
respective format.

 - Each action is defined as a top-level key of a
   [YAML](https://en.wikipedia.org/wiki/YAML) map, with the same name as its
   corresponding executable.
 - The value of each action **should** include a `description` key and **may**
   include a `params` key. If no description is given, an empty description
   will be used.
 - The value of the `params` key is also a YAML map where each key is a string
   whose value is a ['JSON Schema'](http://json-schema.org/example2.html)
   transformed to a YAML map. The 'JSON Schema' itself, may, in turn, be nested.
 - The 'JSON Schema' keys `required` and `additionalProperties` can be used
   under the action key (parallel to `description` and `params`) but they can
   also be used anywhere within a nested schema.
 - Use `additionalProperties: false` under the action key to reject additional
   parameters passed by the user.
 - At this time, the `$schema` and `$ref` keys are not supported by Juju, as
   they may trigger resolution of remote objects and other issues.


## Detailed example

Using the above information the previous example can be extended with the
`description` key:

```yaml
pause:
  description: Pause the database.
resume:
  description: Resume a paused database.
snapshot:
  description: Take a snapshot of the database.
```

The `snapshot` action can be enriched with the `params` key:

```yaml
...
snapshot:
  description: Take a snapshot of the database.
  params:
    outfile:
      type: string
      description: The filename to write to.
...
```

A sample complete `actions.yaml` file after extending the snapshot action and
adding the `required` and `additionalProperties` keys:

```yaml
pause:
  description: Pause the database.
resume:
  description: Resume a paused database.
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

This action would support a call such as:

```bash
juju action do mysql/0 snapshot filename=out.tar.gz compression.type=gzip
```


## Action tools

Three tools are provided to the action author for the action to interact with Juju:

 - [`action-get`](#action-get) retrieves the params passed when invoking the
   action.
 - [`action-set`](#action-set) sets values in a map to be returned after the
   action finishes.
 - [`action-fail`](#action-fail) sets the action status to `failed` when it
   finishes, with a message to be returned to the user. The results set by
   `action-set` are preserved.

Use `juju help-tool <tool name>` to see more detail on each tool.


### action-get

`action-get` prints the value of the parameter at the given key, serialized
according to the `--format` option. If multiple keys are passed, action-get
will recurse into the parameter map as needed.

For example, if an action named `snapshot` was defined on a MySQL charm, and
was invoked by the user as follows:

```bash
juju action do mysql/0 snapshot outfile="foo"
```

then the `snapshot` could use `action-get` to retrieve the filename:

```bash
#!/bin/bash
# An action named "snapshot"

action-get outfile
# "foo" will be printed
```


### action-set

`action-set` permits the action to set results in a map to be returned at the
completion of the action. Here is an example:

```bash
#!/bin/bash
# An action named "report"

action-set result-map.time-completed="$(date)" result-map.message="Hello world!"
action-set outcome="success"
```

Using the above action ('report'), the command

```bash
juju action fetch <ID>
```

will produce output similar to:

```nohighlight
# ...
message: "" # No error message.
results:
  result-map:
    time-completed: <some date>
    message: Hello world!
  outcome: success
status: completed
```


### action-fail

`action-fail` causes the action to finish as `failed` upon completion. For
instance, this might be used to indicate a full disk if a database dump was
attempted, or to indicate that a remote service was unable to be resolved. The
results set by `action-set` before or after failure are retained, and an action
fail status cannot be unset.

Example:

```bash
#!/bin/bash
# An action named "sayhello"

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

Using the above action ('sayhello'), the command

```bash
juju action do <unit> sayhello command="greetme"
# ...
```

will produce output similar to:

```nohighlight
message: I only know one command.
results:
  received:
    known: no
    value: greetme
  timestamp: Thu Jan 15 13:28:25 EST 2015
status: failed
```


## Params transformation

This section covers the transformation from `params` to JSON-Schema. This is
meant as an aid to creating more complex schemas and should not be necessary
for most actions.

The transformation to JSON-Schema is as follows:

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

The above, which defines an action for `<A>` (and `<B>` , `<C>` , and so on),
becomes the following in JSON-Schema format:

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

For example, a simple YAML file such as:

```yaml
# actions.yaml
snapshot:
  description: Take a snapshot of the database.
  params:
    outfile:
      type: string
```

will be transformed to this:

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


### A complex YAML transform example

Here we transform the example given at the top of this page:

```yaml
# actions.yaml
pause:
  description: Pause the database.
resume:
  description: Resume a paused database.
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

It becomes three actions, with respective JSON-Schema:

pause:
```json
{
  "description": "Pause the database.",
  "title": "pause",
  "type": "object",
  "properties": {}
}
```

resume:
```json
{
  "description": "Resume a paused database.",
  "title": "resume",
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
