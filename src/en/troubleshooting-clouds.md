Title: Cloud specific Juju troubleshooting


# Cloud specific issues


## Common issues setting up clouds

### juju add-credential

juju add-credential supports adding a credential with a YAML file. The YAML
format is the same that's used to store the credentials on a user's
filesystem. This means that it allows for more than one credential to be
located in the file. However, you can only add one at a time. This often
throws folks that manually create the new credential file. The format must
include a root key of "credentials:".

For example, the following 'azure.yaml' file will fail.

```yaml
azure:
  rickscreds:
      auth-type: service-principal-secret
      application-id: 1234
      application-password: secretpassword
      subscription-id: 12345
      tenant-id: 12345
```

Once the root key is added it will succeed:

```yaml
credentials:
    azure:
      rickstuff:
          auth-type: service-principal-secret
          ...
```


## MAAS


## OpenStack


## LXD



## Amazon Web Services



## Microsoft Azure



## Google Compute Engine


## Oracle


## Manual
