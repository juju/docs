(command-charmcraft-promote-bundle)=
# Command 'charmcraft promote-bundle'

## Usage:
```text
charmcraft promote-bundle [options]
```

## Summary:

Promote a bundle to another channel in the Store.

This command must be run from the bundle project directory to be promoted.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |
| `--from-channel` | The channel from which to promote the bundle |
| `--to-channel` | The target channel for the promoted bundle |
| `--output-bundle` | A path where the created bundle.yaml file can be written |
| `--exclude` | Any charms to exclude from the promotion process |

## See also:
- `close`
- `release`
- `resource-revisions`
- `resources`
- `revisions`
- `set-resource-architectures`
- `status`
- `upload`
- `upload-resource`