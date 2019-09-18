**Usage:** `juju resume-relation [options] <relation-id>[,<relation-id>]`

**Summary:**

Resumes a suspended relation to an application offer.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

A relation between an application in another model and an offer in this model will be resumed. The relation-joined and relation-changed hooks will be run for the relation, and the relation status will be set to joined. The relation is specified using its id.

**Examples:**

       juju resume-relation 123
        juju resume-relation 123 456
**See also:**

[add-relation](https://discourse.jujucharms.com/t/command-add-relation/1674), [offers](https://discourse.jujucharms.com/t/command-offers/1773), [remove-relation](https://discourse.jujucharms.com/t/command-remove-relation/1789), [suspend-relation](https://discourse.jujucharms.com/t/command-suspend-relation/1840)
