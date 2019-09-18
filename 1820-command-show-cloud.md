**Usage:** `juju show-cloud [options] <cloud name>`

**Summary:**

Shows detailed information on a cloud.

**Options:**

`--format (= yaml)`

Specify output format (yaml)

`--include-config (= false)`

Print available config option details specific to the specified cloud

`-o, --output (= "")`

Specify an output file

**Details:**

Provided information includes 'defined' (public, built-in), 'type', 'auth-type', 'regions', 'endpoints', and cloud specific configuration options.

If `--include-config` is used, additional configuration (key, type, and description) specific to the cloud are displayed if available.

**Examples:**

       juju show-cloud google
        juju show-cloud azure-china --output ~/azure_cloud_details.txt
**See also:**

[clouds](https://discourse.jujucharms.com/t/command-clouds/1695), [update-clouds](https://discourse.jujucharms.com/t/command-update-clouds/1847)
