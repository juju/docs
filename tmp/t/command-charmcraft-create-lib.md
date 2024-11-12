(command-charmcraft-create-lib)=
# Command 'charmcraft create-lib'

## Usage:
```text
charmcraft create-lib [options] <name>
```

## Summary:

Create a charm library.

Charmcraft manages charm libraries, which are published by charmers to help other charmers integrate their charms. This command creates a new library in your charm which you are publishing for others.

This command MUST be run inside your charm directory with a valid `charmcraft.yaml`. It will create the Python library with API version 0 initially:

```text
lib/charms/<yourcharm>/v0/<name>.py
```

Each library has a unique identifier assigned by Charmhub that supports accurate updates of libraries even if charms are renamed. Charmcraft will request a unique ID from Charmhub and initialise a template Python library.

Creating a charm library will take you through login if needed.

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
- `status`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`