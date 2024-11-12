(command-juju-show-model)=
# Command 'juju show-model'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-model <command-juju-add-model>`

## Summary
Shows information about the current or specified model.

## Usage
```juju show-model [options] <model name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--format` | yaml | Specify output format (json&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |

## Details
Show information about the current or specified model.