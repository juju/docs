**Usage:** `juju set-firewall-rule [options] <service-name>, --whitelist <cidr>[,<cidr>...]`

**Summary:**

Sets a firewall rule.

**Options:**

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--whitelist (= "")`

list of subnets to whitelist

**Details:**

Firewall rules control ingress to a well known services within a Juju model. A rule consists of the service name and a whitelist of allowed ingress subnets.

The currently supported services are:

      -ssh
      -juju-controller
      -juju-application-offer
**Examples:**

       juju set-firewall-rule ssh --whitelist 192.168.1.0/16
        juju set-firewall-rule juju-controller --whitelist 192.168.1.0/16
        juju set-firewall-rule juju-application-offer --whitelist 192.168.1.0/16
**See also:**

[list-firewall-rules](https://discourse.jujucharms.com/t/command-list-firewall-rules/1745)
