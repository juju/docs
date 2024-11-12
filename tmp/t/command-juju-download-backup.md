(command-juju-download-backup)=
# Command 'juju download-backup'

```{caution}

The information in this doc is based on Juju version 3.5.5,
and may not accurately reflect other versions of Juju.

```

> See also: {ref}`create-backup <command-juju-create-backup>`

## Summary
Download a backup archive file.

## Usage
```juju download-backup [options] /full/path/to/backup/on/controller```

### Options
| Flag | Default | Usage |
| --- | --- | --- |
| `-B`, `--no-browser-login` | false | Do not use web browser for authentication |
| `--filename` |  | Download target |
| `-m`, `--model` |  | Model to operate in. Accepts [&lt;controller name&gt;:]&lt;model name&gt;&#x7c;&lt;model UUID&gt; |

## Examples

    juju download-backup /full/path/to/backup/on/controller


## Details

download-backup retrieves a backup archive file.

If --filename is not used, the archive is downloaded to a temporary
location and the filename is printed to stdout.