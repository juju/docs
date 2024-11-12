(command-charmcraft-prime)=
# Command 'charmcraft prime'

## Usage:
```text
charmcraft prime [options] <part-name>
```

## Summary:

Prepare the final payload to be packed, performing additional processing and adding metadata files. If part names are specified only those parts will be primed. The default is to prime all parts.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-V, --version` | Show the application version and exit |
| `--destructive-mode` | Build in the current host |
| `--use-lxd` | Build in a LXD container. |
| `--shell` | Shell into the environment in lieu of the step to run. |
| `--shell-after` | Shell into the environment after the step has run. |
| `--debug` | Shell into the environment if the build fails. |
| `--platform` | Set platform to build for |
| `--build-for` | Set architecture to build for |

## See also:
- `build`
- `clean`
- `pack`
- `pull`
- `remote-build`
- `stage`