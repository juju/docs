(command-charmcraft-upload)=
# Command 'charmcraft upload'

## Usage:
```text
charmcraft upload [options] <filepath>
```

## Summary:

Upload a charm or bundle to Charmhub.

Push a charm or bundle to Charmhub where it will be verified. This command will finish successfully once the package is approved by Charmhub.

In the event of a failure in the verification process, charmcraft will report details of the failure, otherwise it will give you the new charm or bundle revision.

Upload will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `--format` | Produce the result in the specified format (currently only 'json') |
| `--release` | The channel(s) to release to (this option can be indicated multiple times) |
| `--name` | Name of the charm or bundle on Charmhub to upload to |
| `--resource` | The resource(s) to attach to the release, in the <name>:<revision> format (this option can be indicated multiple times) |

## See also:
- `close`
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
- `upload-resource`
- `whoami`