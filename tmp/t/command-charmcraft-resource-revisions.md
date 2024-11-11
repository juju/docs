(command-charmcraft-resource-revisions)=
# Command 'charmcraft resource-revisions'

## Usage:
```text
charmcraft resource-revisions [options] <charm-name> <resource-name>
```

## Summary:

Show size and date for each resource revision in Charmhub.

For example:

```text
$ charmcraft resource-revisions my-charm my-resource
Revision    Created at               Size
1           2020-11-15 T11:13:15Z  183151
```

Listing revisions will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `--format` | Produce the result in the specified format (currently only 'json') |

## See also:
- `close`
- `promote-bundle`
- `release`
- `resources`
- `revisions`
- `set-resource-architectures`
- `status`
- `upload`
- `upload-resource`