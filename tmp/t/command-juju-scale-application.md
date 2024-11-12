(command-juju-scale-application)=
# Command 'juju scale-application'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`remove-application <command-juju-remove-application>`, {ref}`add-unit <command-juju-add-unit>`, {ref}`remove-unit <command-juju-remove-unit>`

## Summary
Set the desired number of k8s application units.

## Usage
```juju scale-application [options] <application> <scale>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |

## Examples

    juju scale-application mariadb 2


## Details

Scale a k8s application by specifying how many units there should be.
The new number of units can be greater or less than the current number, thus
allowing both scale up and scale down.