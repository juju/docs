(command-charmcraft-clean)=
# Command 'charmcraft clean'

## Usage:
```text
charmcraft clean [options]
```

## Summary:

Purge Charmcraft project's artifacts, including:

- LXD Containers created for building charm(s) 
- Multipass Containers created for building charm(s)

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |

## See also:
- `analyze`
- `init`
- `pack`
- `version`