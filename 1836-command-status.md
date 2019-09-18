**Usage:** `juju show-status [options] [filter pattern ...]`

**Summary:**

Reports the current status of the model, machines, applications and units.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--color (= false)`

Force use of ANSI color codes

`--format (= tabular)`

Specify output format (`json|line|oneline|short|summary|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

`--relations (= false)`

Show 'relations' section

`--retry-count (= 3)`

Number of times to retry API failures

`--retry-delay (= 100ms)`

Time to wait between retry attempts

`--storage (= false)`

Show 'storage' section

`--utc (= false)`

Display time as UTC in RFC3339 format

**Details:**

By default (without argument), the status of the model, including all applications and units will be output.

Application or unit names may be used as output filters (the '*' can be used as a wildcard character). In addition to matched applications and units, related machines, applications, and units will also be displayed. If a subordinate unit is matched, then its principal unit will be displayed. If a principal unit is matched, then all of its subordinates will be displayed.

Machine numbers may also be used as output filters. This will only display data in each section relevant to the specified machines. For example, application section will only contain the applications that have units on these machines, etc. The available output formats are:

* tabular (default): Displays status in a tabular format with a separate table for the model, machines, applications, relations (if any), storage (if any) and units.

            Note: in this format, the AZ column refers to the cloud region's
            availability zone.
* {short|line|oneline}: List units and their subordinates. For each unit, the IP address and agent status are listed.

* summary: Displays the subnet(s) and port(s) the model utilises. Also displays aggregate information about:

            - Machines: total #, and # in each state.

             - Units: total #, and # in each state.

             - Applications: total #, and # exposed of each application.
* yaml: Displays information about the model, machines, applications, and units in structured YAML format.

* json: Displays information about the model, machines, applications, and units in structured JSON format.

In tabular format, 'Relations' section is not displayed by default. Use `--relations` option to see this section. This option is ignored in all other formats.

**Examples:**

       juju show-status
        juju show-status mysql
        juju show-status nova-*
        juju show-status --relations
        juju show-status --storage
**See also:**

[machines](https://discourse.jujucharms.com/t/command-machines/1765), [show-model](https://discourse.jujucharms.com/t/command-show-model/1825), [show-status-log](https://discourse.jujucharms.com/t/command-show-status-log/1828), [storage](https://discourse.jujucharms.com/t/command-storage/1837)

**Aliases:**

status
