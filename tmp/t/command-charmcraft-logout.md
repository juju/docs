(command-charmcraft-logout)=
# Command 'charmcraft logout'

## Usage:
```text
charmcraft logout [options]
```

## Summary:

Clear the Charmhub token.

Charmcraft will remove the local token used for Charmhub access. This is important on any shared system because the token allows manipulation of your published charms.

See also `charmcraft whoami` to verify that you are logged in, and `charmcraft login`.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |

## See also:
- `close`
- `create-lib`
- `fetch-lib`
- `list-lib`
- `login`
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