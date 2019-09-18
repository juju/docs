**Usage:** `juju remove-saas [options] <saas-application-name> [<saas-application-name>...]`

**Summary:**

Remove consumed applications (SAAS) from the model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Removing a consumed (SAAS) application will terminate any relations that application has, potentially leaving any related local applications in a non-functional state.

**Examples:**

       juju remove-saas hosted-mysql
        juju remove-saas -m test-model hosted-mariadb
**Aliases:**

remove-consumed-application
