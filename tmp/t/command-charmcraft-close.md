(command-charmcraft-close)=
# Command 'charmcraft close'

## Usage:
```text
charmcraft close [options] <name> <channel>
```

## Summary:

Close the specified channel for a charm or bundle.

The channel is made up of `track/risk/branch` with both the track and the branch as optional items, so formally:

```text
[track/]risk[/branch]
```

Channel risk must be one of stable, candidate, beta or edge. The track defaults to `latest` and branch has no default.

Closing a channel will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |

## See also:
- `create-lib`
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