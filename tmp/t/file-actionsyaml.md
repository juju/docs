(file-actionsyaml)=
# File 'actions.yaml'

<!-- NOTE: The spec information for validation should match what is in juju/charm/actions.go -->

> <small> {ref}`List of files in the charm project <list-of-files-in-a-charm-project>` > `actions.yaml`</small> 

The `actions.yaml` file in a charm project is an optional file that may be used to define the [actions](https://juju.is/docs/juju/action) supported by the charm.

```{caution}

:warning: Starting with Charmcraft 2.5, the `actions.yaml` file is created automatically from information you provide in the {ref}``charmcraft.yaml` <file-charmcraftyaml>` file file. For backwards compatibility, Charmcraft will continue to allow the use of the `actions.yaml` file, but you may not duplicate keys across the two files. 

```


The file contains a YAML map for each defined action. Each map starts with the key `<action name>`. The rest of this document gives details about this key.


<!--If present, it should contain a single YAML map representing one or more actions.-->

---
```{dropdown} Expand to view the full spec at once

```yaml
<action 1>:
  description: <string>
  parallel: <boolean>
  execution-group: <string>
  params:
    <param 1>: <JSON Schema>
    <param 2>: <JSON Schema>
    …
  <other keys>
<action name 2>:
  …
```

```
---

```{dropdown} Expand to view a simple example

The following shows a simple example of an `actions.yaml` file, defining three actions named `pause`, `resume`, and `snapshot`. The `snapshot` action takes a single string parameter named `outfile`:

```yaml
pause:
  description: Pause the database.
  additionalProperties: false
resume:
  description: Resume a paused database.
  additionalProperties: false
snapshot:
  description: |
    Take a snapshot of the database.
    Descriptions can be extended to multiple lines.
  params:
    outfile:
      type: string
      description: The filename to write to.
  additionalProperties: false
```

```

---

```{dropdown} Expand to view a complex example

The following example showcases a more complex configuration file that uses features of JSON schema to define detailed options. It also makes the `filename` field mandatory:

```yaml
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

The above action could be run with `juju run <unit> snapshot filename=out.tar.gz compression.kind=gzip`. This demonstrates how to pass objects with the CLI.

```

---

**Contents:**

- [Key `<action>`](#heading--action-name)	

<a href="#heading--action-name"><h2 id="heading--action-name">Key `<action>`</h2></a>	

- [Status](#heading--status)
- [Purpose](#heading--purpose)
- [Structure](#heading--structure)



<a href="#heading--status"><h3 id="heading--status">Status</h3></a>

Required, one for each action.

<a href="#heading--purpose"><h3 id="heading--purpose">Purpose</h3></a>

To define an action supported by the charm.

The information stated here will feed into `juju actions <charm>` and `juju run <charm unit> <action>`, helping a Juju end user know what actions and action parameters are defined for the charm.
> See more: [Juju | `juju actions`](https://juju.is/docs/juju/juju-actions), [Juju | `juju run`](https://juju.is/docs/juju/juju-run)

<a href="#heading--structure"><h3 id="heading--structure">Structure</h3></a>

*Name:* The name of the key (`<action name>`) is defined by the charm author.  It must be 
a valid Python [identifier](https://docs.python.org/3/reference/lexical_analysis.html#identifiers) that does not collide with Python [keywords](https://docs.python.org/3/reference/lexical_analysis.html#keywords) except that it may contain hyphens (which will be mapped to underscores in the Python event handler). 

<!--TODO: Add sentence commenting on validation -- when does it happen?-->


*Type:* Map.

*Value:* A series of keys-value pairs corresponding to action metadata and to parameter validation, defined as follows:

```text
<action>:
  # Action metadata keys
  description: <string>
  parallel: <boolean>
  execution-group: <string>
  # Parameter validation keys, cf. JSON Schema object
  params:
    <param 1>: <...>
    <param 2>: <...>
    …
  <other key-value pairs>
```

```{important}

As you can see, the action definition schema defines a typical JSON Schema object, except:
1. It includes some new keys specific to actions: `description`, `parallel`, and `execution-group`.
2. It does not currently support the JSON Schema concepts `$schema` and `$ref`.
3. The `additionalProperties` and `required` keys from JSON Schema can be used at the top-level of an action (adjacent to `description` and `params`), but also used anywhere within a nested schema.
<!--TODO: Revisit redundant info -- point 3 duplicates what we say for the <other key-value pairs> bit lower.-->
> See more: [JSON schema](https://www.learnjsonschema.com/)

```

where

***`<action>.description`***

- **Status:** Optional but recommended.

- **Purpose:** To describe the action.

- **Structure:** *Type:* String.

***`<action>.parallel`***

- **Status:** Optional, defaults to false.

- **Purpose:** To set whether to allow tasks created by this action to execute in parallel. 

- **Structure:** *Type:* Boolean.

> See more: [Juju | `juju run`](https://juju.is/docs/juju/juju-run), [Juju | Task](https://juju.is/docs/juju/task)

***`<action>.execution-group`***

- **Status:** Optional, defaults to “”.

- **Purpose:** Sets in which execution group to place tasks created by this action. 

- **Structure:** *Type:* String.

> See more: [Juju | `juju run`](https://juju.is/docs/juju/juju-run), [Juju | Task](https://juju.is/docs/juju/task)

***`<action>.params`***

- **Status:** Optional.

- **Purpose:** To define the fixed parameters for the action. Fixed parameters are those with a name given by a fixed string.

- **Structure:** *Type:* Map. *Value:* One or more key-value pairs where each key is a parameter name and each value is the YAML equivalent of a valid [JSON Schema](https://json-schema.org/). The entire map of `<action>.params` is inserted into the action schema object as a “properties” validation keyword. The Juju CLI may read the “description” annotation keyword of each parameter to present to the user when describing the action.


***`<action>.*`***

- **Status:** Optional.

- **Purpose:** To define additional validation or annotation keywords of the action schema object.

- **Structure:** *Name:* A valid keyword of a JSON Schema object instance that will be merged into the action schema object. For example, `additionalProperties` or `required`. *Type:* Various.  

<!-- this example I came up with is a little silly now, so removing

<a href="#heading--examples"><h3 id="heading--examples">Examples</h3></a>

---
```{dropdown} Expand to view an example featuring  `<action>.description` and `<action>.*`


The following example uses `<action>.*` to declare `additionalProperties: true` so that the action can accept arbitrary arguments.

```yaml
insert-into-db:
  description: Set given keys into database
  additionalProperties: true
```

While the `additionalProperties` key could also be omitted as `true` is the default, it may be desirable to indicate this behaviour explicitly.


```

----

-->




<!--OTHER MATERIAL -- CHECK IF WE NEED TO INCORPORATE ANYTHING FROM IT; IF NOT, DELETE:

(((probably unnecessary - At the moment, annotation keywords are not used by the CLI except for the “params.<param-name>.description” keys mentioned above. Hence a user may be unaware of complex options for parameter passing)))



Each action may have the following sub-keys, none of which are required:

| Sub-key           | Type    | Specification                                                                              |
|:-----------------:|---------|--------------------------------------------------------------------------------------------|
| `description`     | string  | A description that is shown to juju users.                                                 |
| `params`          | map     | Each key defines a parameter of the action with the value given in JSON Schema format      |
| `execution-group` | string  | Which execution group to place tasks created by this action (defaults to "")               |
| `parallel`        | boolean | Whether to allow tasks to execute in parallel (defaults to false)                          |
| other keys        | various | Must be valid JSON Schema object instance keys and define the top-level JSON Schema object |

The action parameters are declared in a YAML flavour of [JSON Schema](https://json-schema.org/) and should mirror what the handler expects for the action. The schema provides a guarantee for the action handler, that the `params` dictionary passed to it will match the JSON schema. Conversely, the Juju user will only be allowed to pass parameters that match the JSON schema.

 I think this would be better to link a description in 'tasks' of the Juju reference, but only after this description is in place --Danny

There are some small differences in the parameters spec for `actions.yaml` from [JSON Schema](https://json-schema.org/):
  - The `$schema` and `$ref` keys are not currently supported
  - The `params` map is treated as if it were a single top-level JSON Schema instance of type [object](https://json-schema.org/understanding-json-schema/reference/object.html) with a map of `properties` corresponding to each key in `params`. This instance is what is used to validate the Juju user input.
  - Additional properties of the top-level JSON Schema `object` instance (e.g. `additionalProperties` or `required`) can be specified as sub-keys of the action, shown as "other keys" in the table above.
<!-- there may be more subtleties here to do with the `cleanse` function in juju/charm/actions.go 

 <a href="#heading--common-use-cases"><h2 id="heading--common-use-cases">Common use cases</h2></a>

A simple subset of JSON schema can cover the majority of use cases for actions:
```yaml
<action-name>:
  description: <text>
  params:
    <param-1>:
      description: <param specific description>
      type: <string | boolean | number> # optional
      default: <string | boolean | number | nil> # optional
    <param-2>:
      ...
  additionalProperties: <true | false> # defaults to true
  required: <list of parameter names> # defaults to []
```

The `additionalProperties` and `required` together define which parameter names are allowed. Names that appear in `required` MUST be given when running the action. If `additionalProperties` is `true` (the default) then names which do not appear in the parameter list are allowed when running the action.

If the caller of the action does not provide a parameter, then:
  - if the name appears in `required` a validation error occurs.
  - if the parameter provides a default, this will be used in the `params` dictionary of the handler.
  - otherwise the parameter will not appear in the `params` dictionary.

Note that `default: nil` will cause different behaviour than omitting `default` entirely.

It is highly recommended to provide `additionalProperties: false` to avoid user frustration with accidental typos.

-->
> <small>Contributors: @charlie4284 , @dannycocks , @mmkay, @tmihoc  </small>