(command-charmcraft-list-lib)=
# Command 'charmcraft list-lib'

## Usage:
```text
charmcraft list-lib [options] <name>
```

## Summary:

List all libraries from a charm.

For each library, it will show the name and the api and patch versions for its tip.

For example:

```text
$ charmcraft list-lib my-charm
Library name    API    Patch
my_great_lib    0      3
my_great_lib    1      0
other_lib       0      5
```

To fetch one of the shown libraries you can use the `fetch-lib` command.

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
- `status`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`