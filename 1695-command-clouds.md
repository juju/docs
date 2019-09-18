**Usage:** `juju clouds [options]`

**Summary:**

Lists all clouds available to Juju.

**Options:**

`--format (= tabular)`

Specify output format (`json|tabular|yaml`)

`-o, --output (= "")`

Specify an output file

**Details:**

Output includes fundamental properties for each cloud known to the current Juju client: name, number of regions, default region, type, and description.

The default output shows public clouds known to Juju out of the box.

These may change between Juju versions. In addition to these public clouds, the 'localhost' cloud (local LXD) is also listed.

This command's default output format is 'tabular'.

Cloud metadata sometimes changes, e.g. AWS adds a new region. Use the update-clouds command to update the current Juju client accordingly. Use the add-cloud command to add a private cloud to the list of clouds known to the current Juju client.

Use the regions command to list a cloud's regions. Use the show-cloud command to get more detail, such as regions and endpoints. Further reading: https://docs.jujucharms.com/stable/clouds

**Examples:**

       juju clouds
        juju clouds --format yaml
**See also:**

[add-cloud](https://discourse.jujucharms.com/t/command-add-cloud/1669), [regions](https://discourse.jujucharms.com/t/command-regions/1776), [show-cloud](https://discourse.jujucharms.com/t/command-show-cloud/1820), [update-clouds](https://discourse.jujucharms.com/t/command-update-clouds/1847)

**Aliases:**

list-clouds
