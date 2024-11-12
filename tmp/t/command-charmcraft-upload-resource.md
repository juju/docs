(command-charmcraft-upload-resource)=
# Command 'charmcraft upload-resource'

## Usage:
```text
charmcraft upload-resource [options] <charm-name> <resource-name>
```

## Summary:

Upload a resource to Charmhub.

Push a resource content to Charmhub, associating it to the specified charm. This charm needs to have the resource declared in its metadata (in a previously uploaded to Charmhub revision).

The resource can be a file from your computer (use the `--filepath` option) or an OCI Image (use the `--image` option to indicate the image digest or id), which can be already in Canonical's registry and used directly, or locally in your computer and will be uploaded and used.

Upload will take you through login if needed.

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
| `--filepath` | The file path of the resource content to upload |
| `--image` | The digest (remote or local) or id (local, exclude "sha256:") of the OCI image |
| `--arch` | The architectures valid for this file resource. If none are provided, the resource is uploaded without architecture information. |

## See also:
- `close`
- `promote-bundle`
- `release`
- `resource-revisions`
- `resources`
- `revisions`
- `set-resource-architectures`
- `status`
- `upload`