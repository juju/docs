**Usage:**` juju add-subnet [options] <CIDR>|<provider-id> <space> [<zone1> <zone2> ...]`

**Summary:**

Add an existing subnet to Juju.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Adds an existing subnet to Juju, making it available for use. Unlike `juju add-subnet`, this command does not create a new subnet, so it is supported on a wider variety of clouds (where SDN features are not available, e.g. MAAS). The subnet will be associated with the given existing Juju network space.

Subnets can be referenced by either their CIDR or ProviderId (if the provider supports it). If CIDR is used an multiple subnets have the same CIDR, an error will be returned, including the list of possible provider IDs uniquely identifying each subnet.

Any availablility zones associated with the added subnet are automatically discovered using the cloud API (if supported). If this is not possible, since any subnet needs to be part of at least one zone, specifying zone(s) is required.
