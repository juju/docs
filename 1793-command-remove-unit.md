**Usage:** `juju remove-unit [options] <unit> [...] | <application>`

**Summary:**

Remove application units from the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--destroy-storage (= false)`

Destroy storage attached to the unit

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--num-units (= 0)`

Number of units to remove (kubernetes models only)

**Details:**

Remove application units from the model.

The usage of this command differs depending on whether it is being used on a Kubernetes or cloud model.

Removing all units of a application is not equivalent to removing the application itself; for that, the `juju remove-application` command is used.

For Kubernetes models only a single application can be supplied and only the `--num-units` argument supported.

Specific units cannot be targeted for removal as that is handled by Kubernetes, instead the total number of units to be removed is specified.

**Examples:**

`   juju remove-unit wordpress --num-units 2`

For cloud models specific units can be targeted for removal.

Units of a application are numbered in sequence upon creation. For example, the fourth unit of wordpress will be designated "wordpress/3". These identifiers can be supplied in a space delimited list to remove unwanted units from the model.

Juju will also remove the machine if the removed unit was the only unit left on that machine (including units in containers).

Examples:

       juju remove-unit wordpress/2 wordpress/3 wordpress/4

        juju remove-unit wordpress/2 --destroy-storage
**See also:**

[remove-application](https://discourse.jujucharms.com/t/command-remove-application/1780), [scale-application](https://discourse.jujucharms.com/t/command-scale-application/1805)
