(command-charmcraft-login)=
# Command 'charmcraft login'

## Usage:
```text
charmcraft login [options]
```

## Summary:

Login to Charmhub.

Charmcraft will provide a URL for the Charmhub login. When you have successfully logged in, charmcraft will store a token for ongoing access to Charmhub at the CLI (if `--export` option was not used otherwise it will only save the credentials in the indicated file).

If `--export <file>` option is used, a secret credentials file will be created. And the file can be used to set `CHARMCRAFT_AUTH` environment variable.

```text
export CHARMCRAFT_AUTH=$(cat secret)
```

This is suitable for Linux environments without a Vault, such as remote servers and CI/CD pipelines.

Please ensure the secret file and environment variable are secured.

Remember to `charmcraft logout` if you want to remove that token from your local system, especially in a shared environment.

If the credentials are exported, they can also be attenuated in several ways specifying their time-to-live (`--ttl`), on which channels would work (`--channel`), what actions will be able to do (`--permission`), and on which packages they will work (using `--charm` or `--bundle`).

See also `charmcraft whoami` to verify that you are logged in.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `--export` | Export the Charmhub unencrypted secret credentials to a file |
| `--charm` | The charm(s) on which the required credentials would work (this option can be indicated multiple times; defaults to all) |
| `--bundle` | The bundle(s) on which the required credentials would work (this option can be indicated multiple times; defaults to all) |
| `--channel` | The channel(s) on which the required credentials would work (this option can be indicated multiple times, defaults to any channel) |
| `--permission` | The permission(s) that the required credentials will have (this option can be indicated multiple times, defaults to all permissions) |
| `--ttl` | The time-to-live (in seconds) of the required credentials (defaults to 30 hours) |

## See also:
- `close`
- `create-lib`
- `fetch-lib`
- `list-lib`
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