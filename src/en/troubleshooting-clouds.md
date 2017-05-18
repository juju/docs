Title: Juju troubleshooting specific clouds


# Cloud specific issues


## Common issues setting up clouds

### juju add-credential

The YAML needed to add a credential works with a credential file from another
system. This means it's expecting a format that includes a root key of
"credentials:". Often, users pass around a single credential and don't include
the root key.

For example, a azure.yaml file like so will fail.

```
azure:
  rickscreds:
      auth-type: service-principal-secret
      application-id: 1234
      application-password: secretpassword
      subscription-id: 12345
      tenant-id: 12345
```

Once the root key is added it will succeed.

```
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
