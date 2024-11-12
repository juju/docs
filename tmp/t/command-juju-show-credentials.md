(command-juju-show-credentials)=
# Command 'juju show-credentials'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`credentials <command-juju-credentials>`, {ref}`add-credential <command-juju-add-credential>`, {ref}`update-credential <command-juju-update-credential>`, {ref}`remove-credential <command-juju-remove-credential>`, {ref}`autoload-credentials <command-juju-autoload-credentials>`
**Alias:** show-credential

## Summary
Shows credential information stored either on this client or on a controller.

## Usage
```juju show-credentials [options] [<cloud name> <credential name>]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |
| `--client` | false | Client operation |
| `--format` | yaml | Specify output format (yaml) |
| `-o`, `--output` |  | Specify an output file |
| `--show-secrets` | false | Display credential secret attributes |

## Examples

    juju show-credential google my-admin-credential
    juju show-credentials 
    juju show-credentials --controller mycontroller --client 
    juju show-credentials --controller mycontroller 
    juju show-credentials --client
    juju show-credentials --show-secrets


## Details

This command displays information about cloud credential(s) stored 
either on this client or on a controller for this user.

To see the contents of a specific credential, supply its cloud and name.
To see all credentials stored for you, supply no arguments.

To see secrets, content attributes marked as hidden, use --show-secrets option.

To see credentials from this client, use "--client" option.

To see credentials from a controller, use "--controller" option.