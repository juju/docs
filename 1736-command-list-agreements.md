**Usage:** `juju agreements [options]`

**Summary:**

List user's agreements.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

**Details:**

Charms may require a user to accept its terms in order for it to be deployed. In other words, some applications may only be installed if a user agrees to accept some terms defined by the charm. This command lists the terms that the user has agreed to.

**See also:**

[agree](https://discourse.jujucharms.com/t/command-agree/1681)

**Aliases:**

list-agreements
