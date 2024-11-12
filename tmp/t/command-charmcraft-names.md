(command-charmcraft-names)=
# Command 'charmcraft names'

## Usage:
```text
charmcraft names [options]
```

## Summary:

An overview of names you have registered to publish in Charmhub.

```text
$ charmcraft names
Name                Type    Visibility    Status
sabdfl-hello-world  charm   public        registered
```

Visibility and status are shown for each name. `public` items can be seen by any user, while `private` items are only for you and the other accounts with permission to collaborate on that specific name.

The `--include-collaborations` option can be included to also list those names you collaborate with; in that case the publisher will be included in the output.

Listing names will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `--format` | Produce the result in the specified format (currently only 'json') |
| `--include-collaborations` | Include the names you are a collaborator of |

## See also:
- `close`
- `create-lib`
- `fetch-lib`
- `list-lib`
- `login`
- `logout`
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