# Actions for the Charm author

---

 - ### [Defining Actions](#defining-actions)
    - #### [Requirements](#requirements)
    - #### [Example Schema](#example-schema)
 - ### [Params Transformation](#params-transformation)
    - #### [Simple YAML transform example](#simple-yaml-transform-example)
    - #### [More complex YAML transform example](#more-complex-yaml-transform-example)

---

## Defining Actions

To define Actions ([see here for more about Actions](actions.html)) on a Charm, executables (scripts, binaries, etc.) for each 
Action must be included in `/actions` in the Charm, and each named executable
must be defined in a YAML map in `/actions.yaml` in the Charm.  [See below](#example-schema) for
an example.

### Requirements

 - Each Action is defined as a top-level key of a YAML map, with the same name as
the script it defines.

 - The value of each Action must be a map, which should include a `description`
key and may include a `params` key to define a schema.  If no `description` is
given, a default empty description will be used.

 - The value of `params`, if it is included, must be a YAML map.  Each key under
`params` must be a string, and must have valid [JSON-Schema](http://json-schema.org/example2.html) as its value,
transformed to a YAML map.  JSON-Schema may be nested to create complex
schemas.

 - JSON-Schema defines special keys such as `required` and `additionalProperties`,
which may be given for the whole action at the same level as `description` and
`params`, or within nested schemas at the usual level.

 - At this time, the `$schema` key is not supported by Juju, as it may trigger
resolution of remote objects.

### Example Schema

 > Charm dir
```
/actions/
/actions/report
/actions/snapshot
/actions.yaml
/...
```

 > actions.yaml example
```
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

This schema would support a call such as:

```bash
juju action do mysql/0 snapshot filename=out.tar.gz compression.type=gzip
```

---

## Params Transformation

This section specifies the transformation from `params` to JSON-Schema.  This
is meant as a clarifying aid to creating more complex schemas and should not
be necessary for most Actions.  If that is what the reader seeks, read on!

The `params` key of an action in `actions.yaml` defines a YAML map which is
transformed to JSON-Schema as follows: 

```
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
  "required": ["filename"]
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

 > report
```json
{
  "description": "No description",
  "title": "report",
  "type": "object",
  "properties": {}
}
```

> snapshot
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
