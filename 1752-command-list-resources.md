**Usage:** `juju resources [options] <application or unit>`

**Summary:**

Show the resources for an application or unit.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--details (= false)`

show detailed information about resources used by each unit.

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

This command shows the resources required by and those in use by an existing application or unit in your model. When run for an application, it will also show any updates available for resources from the charmstore.

**Aliases:**

list-resources
