**Usage:** `juju remove-application [options] <application> [<application>...]`

**Summary:**

Remove applications from the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--destroy-storage (= false)`

Destroy storage attached to application units

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Removing an application will terminate any relations that application has, remove all units of the application, and in the case that this leaves machines with no running applications, Juju will also remove the machine. For this reason, you should retrieve any logs or data required from applications and units before removing them. Removing units which are co-located with units of other charms or a Juju controller will not result in the removal of the machine.

**Examples:**

       juju remove-application hadoop
        juju remove-application -m test-model mariadb
