(command-juju-add-space)=
# Command 'juju add-space'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`spaces <command-juju-spaces>`, {ref}`remove-space <command-juju-remove-space>`

## Summary
Add a new network space.

## Usage
```juju add-space [options] <name> [<CIDR1> <CIDR2> ...]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |

## Examples


Add space "beta" with subnet 172.31.0.0/20:
    
    juju add-space beta 172.31.0.0/20


## Details
Adds a new space with the given name and associates the given
(optional) list of existing subnet CIDRs with it.