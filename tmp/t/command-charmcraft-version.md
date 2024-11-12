(command-charmcraft-version)=
# Command 'charmcraft version'

## Usage:
```text
charmcraft version [options]
```

## Summary:

Show charmcraft version.

The output has the following format: `X.Y.Z[+N.gHASH[.dirty]]`

Where:

- `X`, `Y` and `Z` are the major, minor and patch version numbers,   upgraded when a release is done

- `+N.gHASH` is present if using charmcraft from the project (how many   commits after last release, and last commit's hash)

- `.dirty` is present if the branch you're executing charmcraft from has   modifications

Example: `0.3.1+40.g883455b.dirty`

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
- `analyze`
- `clean`
- `init`
- `pack`