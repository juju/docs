**Usage:** `juju machines [options]`

**Summary:**

Lists machines in a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--color (= false)`

Force use of ANSI color codes

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--utc (= false)`

Display time as UTC in RFC3339 format

**Details:**

By default, the tabular format is used.

The following sections are included: ID, STATE, DNS, INS-ID, SERIES, AZ Note: AZ above is the cloud region's availability zone.

**Examples:**

    juju machines
**See also:**

[status](https://discourse.jujucharms.com/t/command-status/1836)

**Aliases:**

list-machines
