**Usage:** `juju find-offers [options]`

**Summary:**

Find offered application endpoints.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`--interface (= "")`

return results matching the interface name

`-o, --output (= "")`

Specify an output file

`--offer (= "")`

return results matching the offer name

`--url (= "")`

return results matching the offer URL

**Details:**

Find which offered application endpoints are available to the current user. This command is aimed for a user who wants to discover what endpoints are available to them.

**Examples:**

      $ juju find-offers
      $ juju find-offers mycontroller:

      $ juju find-offers fred/prod
      $ juju find-offers --interface mysql
      $ juju find-offers --url fred/prod.db2
      $ juju find-offers --offer db2
**See also:**

[show-offer](https://discourse.jujucharms.com/t/command-show-offer/1826)
