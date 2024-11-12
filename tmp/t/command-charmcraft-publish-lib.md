(command-charmcraft-publish-lib)=
# Command 'charmcraft publish-lib'

## Usage:
```text
charmcraft publish-lib [options] <library>
```

## Summary:

Publish charm libraries.

Upload and release in Charmhub the new api/patch version of the indicated library, or all the charm libraries if <library> is not provided.

It will automatically take you through the login process if your credentials are missing or too old.

Note that in order to be able to publish a charm library, you need to be signed into Charmcraft as a user that has permissions to publish libraries to this charm. In particular you need to be the owner of this charm or registered as a contributor to the charm (a status that can be requested via Discourse).

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