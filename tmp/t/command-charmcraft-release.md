(command-charmcraft-release)=
# Command 'charmcraft release'

## Usage:
```text
charmcraft release [options] <name>
```

## Summary:

Release a charm or bundle revision in the channel(s) provided.

Charm or bundle revisions are not published for anybody else until you release them in a channel. When you release a revision into a channel, users who deploy the charm or bundle from that channel will get see the new revision as a potential update.

A channel is made up of `track/risk/branch` with both the track and the branch as optional items, so formally:

```text
[track/]risk[/branch]
```

Channel risk must be one of stable, candidate, beta or edge. The track defaults to `latest` and branch has no default.

It is enough just to provide a channel risk, like `stable` because the track will be assumed to be `latest` and branch is not required.

Some channel examples:

```text
stable
edge
2.0/candidate
beta/hotfix-23425
1.3/beta/feature-foo
```

When releasing a charm, one or more resources can be attached to that release, using the `--resource` option, indicating in each case the resource name and specific revision. For example, to include the resource `thedb` revision 4 in the charm release, do:

```text
charmcraft release mycharm --revision=14 \
    --channel=beta --resource=thedb:4
```

Releasing a revision will take you through login if needed.

## Options:
| | |
|-|-|
| `-h, --help` | Show this help message and exit |
| `-v, --verbose` | Show debug information and be more verbose |
| `-q, --quiet` | Only show warnings and errors, not progress |
| `--verbosity` | Set the verbosity level to 'quiet', 'brief', 'verbose', 'debug' or 'trace' |
| `-p, --project-dir` | Specify the project's directory (defaults to current) |
| `-r, --revision` | The revision to release |
| `-c, --channel` | The channel(s) to release to (this option can be indicated multiple times) |
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
- `resource-revisions`
- `resources`
- `revisions`
- `status`
- `unregister`
- `upload`
- `upload-resource`
- `whoami`