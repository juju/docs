(command-juju-find-offers)=
# Command 'juju find-offers'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`show-offer <command-juju-show-offer>`

## Summary
Find offered application endpoints.

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--format` | tabular | Specify output format (json&#x7c;tabular&#x7c;yaml) |
| `--interface` |  | return results matching the interface name |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |
| `-o`, `--output` |  | Specify an output file |
| `--offer` |  | return results matching the offer name |
| `--url` |  | return results matching the offer URL |

## Examples

    juju find-offers
    juju find-offers mycontroller:
    juju find-offers fred/prod
    juju find-offers --interface mysql
    juju find-offers --url fred/prod.db2
    juju find-offers --offer db2
   


## Details

Find which offered application endpoints are available to the current user.

This command is aimed for a user who wants to discover what endpoints are available to them.