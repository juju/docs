**Usage:** `juju set-meter-status [options] [application or unit] status`

**Summary:**

Sets the meter status on an application or unit.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--info (= "")`

Set the meter status info to this string

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Set meter status on the given application or unit. This command is used to test the meter-status-changed hook for charms in development.

**Examples:**

Set Red meter status on all units of myapp

`juju set-meter-status myapp RED`

Set AMBER meter status with "my message" as info on unit myapp/0

`juju set-meter-status myapp/0 AMBER --info "my message"`
