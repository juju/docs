**Usage:** `juju upgrade-gui [options]`

**Summary:**

Upgrade to a new Juju GUI version.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--list (= false)`

List available Juju GUI release versions without upgrading

**Details:**

Upgrade to the latest Juju GUI released version:

`juju upgrade-gui`

Upgrade to a specific Juju GUI released version:

`juju upgrade-gui 2.2.0`

Upgrade to a Juju GUI version present in a local tar.bz2 GUI release file: juju upgrade-gui /path/to/jujugui-2.2.0.tar.bz2 List available Juju GUI releases without upgrading:

`juju upgrade-gui --list`
