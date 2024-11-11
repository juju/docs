(command-juju-whoami)=
# Command 'juju whoami'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`controllers <command-juju-controllers>`, {ref}`login <command-juju-login>`, {ref}`logout <command-juju-logout>`, {ref}`models <command-juju-models>`, {ref}`users <command-juju-users>`

## Summary
Print current login details.

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `-o`, `--output` |  | Specify an output file |

## Examples

    juju whoami


## Details
Display the current controller, model and logged in user name. 