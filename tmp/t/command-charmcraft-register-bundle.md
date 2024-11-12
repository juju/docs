(command-charmcraft-register-bundle)=
# Command 'charmcraft register-bundle'

## Usage:
```text
charmcraft register-bundle [options] <name>
```

## Summary:

Register a bundle name in the Store.

Claim a name for your bundle in Charmhub. Once you have registered a name, you can upload bundle packages for that name and release them for wider consumption.

Charmhub operates on the 'principle of least surprise' with regard to naming. A bundle with a well-known name should provide the best system for the service most people associate with that name.  Bundles can be renamed in the Charmhub, but we would nonetheless ask you to use a qualified name, such as `yourname-bundlename` if you are in any doubt about your ability to meet that standard.

We discuss registrations on Charmhub's Discourse:

```text
https://discourse.charmhub.io/c/charm
```

Registration will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |

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
- `release`
- `resource-revisions`
- `resources`
- `revisions`
- `status`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`