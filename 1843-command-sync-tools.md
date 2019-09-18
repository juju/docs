**Usage:** `juju sync-agent-binaries [options]`

**Summary:**

Copy agent binaries from the official agent store into a local model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--all (= false)`

Copy all versions, not just the latest

`--destination (= "")`

Local destination directory

DEPRECATED: use `--local-dir` instead

`--dev (= false)`

Consider development versions as well as released ones

DEPRECATED: use `--stream` instead

`--dry-run (= false)`

Don't copy, just print what would be copied

`--local-dir (= "")`

Local destination directory

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--public (= false)`

Tools are for a public cloud, so generate mirrors information

`--source (= "")`

Local source directory

`--stream (= "")`

Simplestreams stream for which to sync metadata

`--version (= "")`

Copy a specific major[.minor] version

**Details:**

This copies the Juju agent software from the official agent binaries store (located at https://streams.canonical.com/juju) into a model. It is generally done when the model is without Internet access.

Instead of the above site, a local directory can be specified as source. The online store will, of course, need to be contacted at some point to get the software.

**Examples:**

Download the software (version auto-selected) to the model:

`   juju sync-agent-binaries --debug`

Download a specific version of the software locally:

`   juju sync-agent-binaries --debug --version 2.0 --local-dir=/home/ubuntu/sync-agent-binaries`

Get locally available software to the model:

`   juju sync-agent-binaries --debug --source=/home/ubuntu/sync-agent-binaries`

**See also:**

[upgrade-model](https://discourse.jujucharms.com/t/command-upgrade-model/1852)

**Aliases:**

sync-tools
