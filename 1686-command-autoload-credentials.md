**Usage:** `juju autoload-credentials`

**Summary:**

Attempts to automatically add or replace credentials for a cloud.

**Details:**

Well known locations for specific clouds are searched and any found information is presented interactively to the user.

An alternative to this command is `juju add-credential` Below are the cloud types for which credentials may be autoloaded, including the locations searched.

EC2 Credentials and regions:

         1. On Linux, $HOME/.aws/credentials and $HOME/.aws/config
          2. Environment variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
GCE Credentials:

         1. A JSON file whose path is specified by the
            GOOGLE_APPLICATION_CREDENTIALS environment variable
          2. On Linux, $HOME/.config/gcloud/application_default_credentials.json
            Default region is specified by the CLOUDSDK_COMPUTE_REGION environment
            variable.

          3. On Windows, %APPDATA%\\gcloud\\application_default_credentials.json
OpenStack Credentials:

         1. On Linux, $HOME/.novarc
          2. Environment variables OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME,

    OS_DOMAIN_NAME
LXD Credentials:

         1. On Linux, $HOME/.config/lxc/config.yml
**Example:**

         juju autoload-credentials
**See also:**

[list-credentials](https://discourse.jujucharms.com/t/command-list-credentials/1743), [remove-credential](https://discourse.jujucharms.com/t/command-remove-credential/1785), [set-default-credential](https://discourse.jujucharms.com/t/command-set-default-credential/1809), [add-credential](https://discourse.jujucharms.com/t/command-add-credential/1670)
