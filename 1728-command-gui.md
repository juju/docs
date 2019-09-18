**Usage:** `juju gui [options]`

**Summary:**

Print the Juju GUI URL, or open the Juju GUI in the default browser.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--browser (= false)`

Open the web browser, instead of just printing the Juju GUI URL

`--hide-credential (= false)`

Do not show admin credential to use for logging into the Juju GUI

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--no-browser (= true)`

DEPRECATED. `--no-browser` is now the default. Use `--browser` to open the web browser

`--show-credentials (= true)`

DEPRECATED. Show admin credential to use for logging into the Juju GUI

**Details:**

Print the Juju GUI URL and show admin credential to use to log into it:

`juju gui`

Print the Juju GUI URL only:

`juju gui --hide-credential`

Open the Juju GUI in the default browser and show admin credential to use to log into it:

`juju gui --browser`

Open the Juju GUI in the default browser without printing the login credential:

`juju gui --hide-credential --browser`

An error is returned if the Juju GUI is not available in the controller.
