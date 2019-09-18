**Usage:** `juju sla [options] <level>`

**Summary:**

Set the SLA level for a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--budget (= "")`

the maximum spend for the model

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Set the support level for the model, effective immediately.

**Examples:**

Set the support level to essential

`juju sla essential`

Set the support level to essential with a maximum budget of $1000 in wallet 'personal'

`juju sla standard --budget personal:1000`

Display the current support level for the model.

`   juju sla`
