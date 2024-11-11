(command-juju-update-k8s)=
# Command 'juju update-k8s'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-k8s <command-juju-add-k8s>`, {ref}`remove-k8s <command-juju-remove-k8s>`

## Summary
Updates an existing k8s endpoint used by Juju.

## Usage
```juju update-k8s [options] <k8s name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-c`, `--controller` |  | Controller to operate in |
| `--client` | false | Client operation |
| `-f` |  | The path to a cloud definition file |

## Examples

    juju update-k8s microk8s
    juju update-k8s myk8s -f path/to/k8s.yaml
    juju update-k8s myk8s -f path/to/k8s.yaml --controller mycontroller
    juju update-k8s myk8s --controller mycontroller
    juju update-k8s myk8s --client --controller mycontroller
    juju update-k8s myk8s --client -f path/to/k8s.yaml


## Details

Update k8s cloud information on this client and/or on a controller.

The k8s cloud can be a built-in cloud like microk8s.

A k8s cloud can also be updated from a file. This requires a &lt;cloud name&gt; and
a yaml file containing the cloud details.

A k8s cloud on the controller can also be updated just by using a name of a k8s cloud
from this client.

Use --controller option to update a k8s cloud on a controller.

Use --client to update a k8s cloud definition on this client.