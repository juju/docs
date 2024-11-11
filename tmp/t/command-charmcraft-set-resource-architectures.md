(command-charmcraft-set-resource-architectures)=
# Command 'charmcraft set-resource-architectures'

## Usage:
```text
charmcraft set-resource-architectures [options] <charm-name> <resource-name> <arch>
```

## Summary:

Set the architectures for a resource revision in Charmhub.

Each resource revision is tagged with one or more architectures. If a revision is incorrectly tagged, this command can modify the architecture tags for that resource revision.

For example:

```text
$ charmcraft resource-revisions my-charm my-resource
Revision    Created at               Size  Architectures
1           2020-11-15 T11:13:15Z  183151  riscv64
$ charmcraft set-resource-architectures my-charm my-resource --revision=1 arm64,armhf
Revision 1 of 'my-resource' on charm 'my-charm' set to architectures: arm64,armhf
$ charmcraft resource-revisions my-charm my-resource
Revision    Created at               Size  Architectures
1           2020-11-15 T11:13:15Z  183151  arm64,armhf
```

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
| `--revision` | A revision to update |

## See also:
- `close`
- `promote-bundle`
- `release`
- `resource-revisions`
- `resources`
- `revisions`
- `status`
- `upload`
- `upload-resource`