(command-charmcraft-analyse)=
# Command 'charmcraft analyse'

## Usage:
```text
charmcraft analyse [options] <filepath>
```

## Summary:

Analyze a charm.

Report the attributes and lint results directly in the terminal. Use `--force` to run even those configured to be ignored.

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
| `--ignore` | Linters to ignore (comma separated) |

## See also:
- `analyze`
- `version`