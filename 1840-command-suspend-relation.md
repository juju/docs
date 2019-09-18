**Usage:** `juju suspend-relation [options] <relation-id>[ <relation-id>...]`

**Summary:**

Suspends a relation to an application offer.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--message (= "")`

reason for suspension

**Details:**

A relation between an application in another model and an offer in this model will be suspended. The relation-departed and relation-broken hooks will be run for the relation, and the relation status will be set to suspended. The relation is specified using its id.

**Examples:**

       juju suspend-relation 123
        juju suspend-relation 123 --message "reason for suspending"
        juju suspend-relation 123 456 --message "reason for suspending"
**See also:**

[add-relation](https://discourse.jujucharms.com/t/command-add-relation/1674), [offers](https://discourse.jujucharms.com/t/command-offers/1773), [remove-relation](https://discourse.jujucharms.com/t/command-remove-relation/1789), [resume-relation](https://discourse.jujucharms.com/t/command-resume-relation/1799)
