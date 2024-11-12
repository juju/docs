(command-juju-disable-user)=
# Command 'juju disable-user'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`users <command-juju-users>`, {ref}`enable-user <command-juju-enable-user>`, {ref}`login <command-juju-login>`

## Summary
Disables a Juju user.

## Usage
```juju disable-user [options] <user name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |

## Examples

    juju disable-user bob


## Details
A disabled Juju user is one that cannot log in to any controller.
This command has no affect on models that the disabled user may have
created and/or shared nor any applications associated with that user.