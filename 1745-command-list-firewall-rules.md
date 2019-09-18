**Usage:** `juju list-firewall-rules [options]`

**Summary:**

Prints the firewall rules.

**Options:**

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`-o, --output (= "")`

Specify an output file

**Details:**

Lists the firewall rules which control ingress to well known services within a Juju model.

**Examples:**

       juju list-firewall-rules
        juju firewall-rules
**See also:**

[set-firewall-rule](https://discourse.jujucharms.com/t/command-set-firewall-rule/1811)

**Aliases:**

firewall-rules
