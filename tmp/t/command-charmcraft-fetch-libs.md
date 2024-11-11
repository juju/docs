(command-charmcraft-fetch-libs)=
# Command `charmcraft fetch-libs`

## Usage:
```text
charmcraft fetch-libs [options]
```

## Summary:

Fetch charm libraries defined in charmcraft.yaml.

For each library in the top-level `charm-libs` key, fetch the latest library version matching those requirements.

For example: charm-libs:   # Fetch lib with API version 0.   # If `fetch-libs` is run and a newer minor version is available,   # it will be fetched from the store.   - lib: postgresql.postgres_client     version: "0"   # Always fetch precisely version 0.57.   - lib: mysql.client     version: "0.57"

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |
| `--format` | Produce the result in the specified format (currently only 'json') |

## See also:
- `create-lib`
- `fetch-lib`
- `list-lib`
- `publish-lib`