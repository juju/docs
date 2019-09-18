**Usage:** `juju scale-application [options] <application> <scale>`

**Summary:**

Set the desired number of application units.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Scale a Kubernetes application by specifying how many units there should be. The new number of units can be greater or less than the current number, thus allowing both scale up and scale down.

**Examples:**

`   juju scale-application mariadb 2`
