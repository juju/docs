(command-juju-default-credential)=
# Command 'juju default-credential'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`credentials <command-juju-credentials>`, {ref}`add-credential <command-juju-add-credential>`, {ref}`remove-credential <command-juju-remove-credential>`, {ref}`autoload-credentials <command-juju-autoload-credentials>`

## Summary
Sets local default credentials for a cloud on this client.

## Usage
```juju default-credential [options] <cloud name> [<credential name>]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `--reset` | false | Reset default credential for the cloud |

## Examples

    juju default-credential google credential_name
    juju default-credential google
    juju default-credential google --reset


## Details
The default credentials are specified with a "credential name". 

A credential name is created during the process of adding credentials either 
via `juju add-credential` or `juju autoload-credentials`. 
Credential names can be listed with `juju credentials`.

This command sets a locally stored credential to be used as a default.
Default credentials avoid the need to specify a particular set of 
credentials when more than one are available for a given cloud.

To unset previously set default credential for a cloud, use --reset option.

To view currently set default credential for a cloud, use the command
without a credential name argument.