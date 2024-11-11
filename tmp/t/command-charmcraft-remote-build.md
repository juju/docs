(command-charmcraft-remote-build)=
# Command 'charmcraft remote-build'

> Starting with Charmcraft 3+

## Usage:
```text
charmcraft remote-build {ref}`options]
```

## Summary:

Command remote-build sends the current project to be built remotely.  After the build is complete, packages for each architecture are retrieved and will be available in the local filesystem.

Interrupted remote builds can be resumed using the `--recover` option, followed by the build number informed when the remote build was originally dispatched. The current state of the remote build for each architecture can be checked using the `--status` option.

To set a timeout on the remote-build command, use the option ``--launchpad-timeout=<seconds>``. The timeout is local, so the build on launchpad will continue even if the local instance is interrupted or times out.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `--recover` | recover an interrupted build |
| `--launchpad-accept-public-upload` | acknowledge that uploaded code will be publicly available. |
| `--launchpad-timeout` | Time in seconds to wait for Launchpad to build. |


## See also:
- [`pack` <command-charmcraft-pack>`