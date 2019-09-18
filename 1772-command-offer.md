**Usage:** `juju offer [options] [model-name.]<application-name>:<endpoint-name>[,...] [offer-name]`

**Summary:**

Offer application endpoints for use in other models.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

**Details:**

Deployed application endpoints are offered for use by consumers.

By default, the offer is named after the application, unless an offer name is explicitly specified.

**Examples**:

$ juju offer mysql:db $ juju offer mymodel.mysql:db $ juju offer db2:db hosted-db2 $ juju offer db2:db,log hosted-db2

**See also:**

[consume](https://discourse.jujucharms.com/t/command-consume/1698), [relate](https://discourse.jujucharms.com/t/command-relate/1778)
