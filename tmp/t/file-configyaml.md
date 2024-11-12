(file-configyaml)=
# File 'config.yaml'

> <small>{ref}`List of files in the charm project <list-of-files-in-a-charm-project>` > `config.yaml`</small> 
>
> See also: {ref}`How to make your charm configurable <how-to-add-a-configuration-option-to-a-charm>`

```{caution}

:warning: Starting with Charmcraft 2.5, the `config.yaml` file is created automatically from information you provide in the {ref}``charmcraft.yaml` <file-charmcraftyaml>` file. For backwards compatibility, Charmcraft will continue to allow the use of the `config.yaml` file, but you may not duplicate keys across the two files. 

```


The`config.yaml` in a charm's root directory is an optional file that may be used to define the configuration options supported by a charm.

The definitions are collected under a single YAML map called `options`. The rest of this doc gives details about this map.

**Contents:**
- [`options`](#heading--options)	 

<a href="#heading--options"><h2 id="heading--options">`options`</h2></a>

**Status:** Optional.

**Purpose:** The `options` key allows charm authors to declare the configuration options that they have defined for a charm.

**Structure:** The key contains a definition block for each option, where each definition consists of a charm-author-defined option name and an option description, given in 3 fields -- type, description, and default value:

```yaml
options:
      <option name>:
        default: <default value>
        description: <description>
        type: <type>
      <option name>:
        default: <default value>
        description: <description>
        type: <type>
      ...
```

where each field is defined as below:

|  Field Name   | Specification                                                                                                                   | Required? |
| :-----------: | ------------------------------------------------------------------------------------------------------------------------------- | :-------: |
|    `type`     | Specifies the data type of the configuration option. Possible values are: `string`, `int`, `float` and `boolean`.               |    Yes    |
| `description` | Contains an explanation of the configuration item and the resulting behaviour. Might also include a list of acceptable values.  |    No     |
|   `default`   | Defines the default value for the option. Must be of the appropriate type and a sane default value in the context of the charm. |    No     |

In some cases, it may be awkward or impossible to provide a sensible default. In these cases, ensure that it is noted in the description of the configuration option. It is acceptable to provide `null` configuration defaults or omit the `default` field. For example:

- `default: `
- `default: ‘’`
- `default: ""`


**Examples:**

-----

```{dropdown} Expand to see an example


```yaml
options:
      name:
        default: Wiki
        description: The name, or Title of the Wiki
        type: string
      skin:
        default: vector
        description: skin for the Wiki
        type: string
      logo:
        default:
        description: URL to fetch logo from
        type: string
      admins:
        default:
        description: Comma-separated list of admin users to create: user:pass[,user:pass]+
        type: string
      debug:
        default: false
        type: boolean
        description: turn on debugging features of mediawiki
```

```