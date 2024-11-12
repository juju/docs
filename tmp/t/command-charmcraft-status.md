(command-charmcraft-status)=
# Command 'charmcraft status'

## Usage:
```text
charmcraft status [options] <name>
```

## Summary:

Show channels and released revisions in Charmhub.

Charm revisions are not available to users until they are released into a channel. This command shows the various channels for a charm and whether there is a charm released.

For example:

```text
$ charmcraft status
Track    Base                   Channel    Version    Revision
latest   ubuntu 20.04 (amd64)   stable     -          -
                                candidate  -          -
                                beta       -          -
                                edge       1          1
```

Showing channels will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `--format` | Produce the result in the specified format (currently only 'json') |

## See also:
- `close`
- `create-lib`
- `fetch-lib`
- `list-lib`
- `login`
- `logout`
- `names`
- `promote-bundle`
- `publish-lib`
- `register`
- `register-bundle`
- `release`
- `resource-revisions`
- `resources`
- `revisions`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`