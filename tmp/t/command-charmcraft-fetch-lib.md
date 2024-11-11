(command-charmcraft-fetch-lib)=
# Command 'charmcraft fetch-lib'

```{caution}

Starting with Charmcraft 3.1, we suggest you use `charmcraft fetch-libs` instead. 
> See more: {ref}`How to fetch a charm library <6123md>`

```

## Usage:
```text
charmcraft fetch-lib [options] <library>
```

## Summary:

Fetch charm libraries.

The first time a library is downloaded the command will create the needed directories to place it, subsequent fetches will just update the local copy.

You can specify the library to update or download by building its fully qualified name with the charm and library names, and the desired API version. For example, to fetch the API version 3 of library 'somelib' from charm `specialcharm`, do:

```text
$ charmcraft fetch-lib charms.specialcharm.v3.somelib
Library charms.specialcharm.v3.somelib version 3.7 downloaded.
```

If the command is executed without parameters, it will update all the currently downloaded libraries.

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
- `close`
- `create-lib`
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