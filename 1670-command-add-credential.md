**Usage:** `juju add-credential [options] <cloud name>`

**Summary:**

Adds or replaces credentials for a cloud, stored locally on this client.

**Options:**

`-f (= "")`

The YAML file containing credentials to add

`--replace (= false)`

Overwrite existing credential information

**Details:**

The user is prompted to add credentials interactively if a YAML-formatted credentials file is not specified. Here is a sample credentials file:

credentials:

       aws:

          <credential name>:

            auth-type: access-key
            access-key: <key>
            secret-key: <key>
        azure:

          <credential name>:

            auth-type: service-principal-secret
            application-id: <uuid1>
            application-password: <password>
            subscription-id: <uuid2>
        lxd:

          <credential name>:

            auth-type: interactive
            trust-password: <password>
A "credential name" is arbitrary and is used solely to represent a set of credentials, of which there may be multiple per cloud.

The `--replace` option is required if credential information for the named cloud already exists locally. All such information will be overwritten. This command does not set default regions nor default credentials. Note that if only one credential name exists, it will become the effective default credential.

For credentials which are already in use by tools other than Juju, ` juju autoload-credentials` may be used.

When Juju needs credentials for a cloud, i) if there are multiple available; ii) there's no set default; iii) and one is not specified ('`-- credential`'), an error will be emitted.

**Examples:**

       juju add-credential google
        juju add-credential aws -f ~/credentials.yaml
**See also:**

[credentials](https://discourse.jujucharms.com/t/command-credentials/1704) , [remove-credential](https://discourse.jujucharms.com/t/command-remove-credential/1785) , [set-default-credential](https://discourse.jujucharms.com/t/command-set-default-credential/1809), [autoload-credentials](https://discourse.jujucharms.com/t/command-autoload-credentials/1686)
