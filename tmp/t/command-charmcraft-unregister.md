(command-charmcraft-unregister)=
# Command 'charmcraft unregister'

## Usage:
```text
charmcraft unregister [options] <name>
```

## Summary:

Unregister a name in the Store.

Unregister a name from Charmhub if no revisions have been uploaded.

A package cannot be unregistered if something has been uploaded to the name. This command is only for unregistering names that have never been used. Unregistering must be done by the publisher. Attempting to unregister a charm or bundle as a collaborator will fail.

We discuss registrations on Charmhub's Discourse:

```text
https://discourse.charmhub.io/c/charm
```

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |

## See also:
- `login`
- `logout`
- `names`
- `register`
- `register-bundle`
- `whoami`