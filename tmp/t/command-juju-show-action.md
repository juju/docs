(command-juju-show-action)=
# Command 'juju show-action'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`actions <command-juju-actions>`, {ref}`run <command-juju-run>`

## Summary
Shows detailed information about an action.

## Usage
```juju show-action [options] <application> <action>```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |

## Examples

    juju show-action postgresql backup


## Details

Show detailed information about an action on the target application.