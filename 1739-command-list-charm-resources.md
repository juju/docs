**Usage:** `juju charm-resources [options] <charm>`

**Summary:**

Display the resources for a charm in the charm store.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--channel (= "stable")`

the charmstore channel of the charm

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

This command will report the resources for a charm in the charm store. can be a charm URL, or an unambiguously condensed form of it, just like the deploy command. So the following forms will be accepted: For cs:trusty/mysql mysql trusty/mysql

For cs:user/trusty/mysql cs:user/mysql

Where the series is not supplied, the series from your local host is used. Thus the above examples imply that the local series is trusty.

**Aliases:**

list-charm-resources
