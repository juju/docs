(command-juju-remove-space)=
# Command 'juju remove-space'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`add-space <command-juju-add-space>`, {ref}`spaces <command-juju-spaces>`, {ref}`reload-spaces <command-juju-reload-spaces>`, {ref}`rename-space <command-juju-rename-space>`, {ref}`show-space <command-juju-show-space>`

## Summary
Remove a network space.

## Usage
```juju remove-space [options] <name>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--force` | false | remove the offer as well as any relations to the offer |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |
| `-y`, `--yes` | false | Do not prompt for confirmation |

## Examples

Remove a space by name:

	juju remove-space db-space

Remove a space by name with force, without need for confirmation:

	juju remove-space db-space --force -y


## Details
Removes an existing Juju network space with the given name. Any subnets
associated with the space will be transferred to the default space.
The command will fail if existing constraints, bindings or controller settings are bound to the given space.

If the --force option is specified, the space will be deleted even if there are existing bindings, constraints or settings.