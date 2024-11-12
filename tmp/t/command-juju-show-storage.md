(command-juju-show-storage)=
# Command 'juju show-storage'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`storage <command-juju-storage>`, {ref}`attach-storage <command-juju-attach-storage>`, {ref}`detach-storage <command-juju-detach-storage>`, {ref}`remove-storage <command-juju-remove-storage>`

## Summary
Shows storage instance information.

## Usage
```juju show-storage [options] <storage ID> [...]```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--format` | yaml | Specify output format (json&#x7c;yaml) |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |
| `-o`, `--output` |  | Specify an output file |

## Examples

    juju show-storage storage-id


## Details

Show extended information about storage instances.
Storage instances to display are specified by storage IDs. 
Storage IDs are positional arguments to the command and do not need to be comma
separated when more than one ID is desired.