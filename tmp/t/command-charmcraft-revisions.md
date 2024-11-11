(command-charmcraft-revisions)=
# Command 'charmcraft revisions'

## Usage:
```text
charmcraft revisions [options] <name>
```

## Summary:

Show version, date and status for each revision in Charmhub.

For example:

```text
$ charmcraft revisions mycharm
Revision    Version    Created at              Status
1           1          2020-11-15T11:13:15Z    released
```

Listing revisions will take you through login if needed.

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
- `status`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`