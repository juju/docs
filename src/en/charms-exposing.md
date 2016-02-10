Title: Exposing services    


# Exposing Services

By design, Juju operates a very secure environment for deploying your services.
Even if you have deployed services, they won't be publicly available unless
you explicitly make them so. To allow public access to services, the
appropriate changes must be made to the cloud provider firewall settings. As
the procedure for doing this varies depending on the provider, Juju helpfully
abstracts this into a single command, `juju expose <servicename>`

For example, you may have deployed a WordPress service using the relevant
charm. Once deployed, the service still cannot be accessed by the public,
so you would run:

```bash
juju expose wordpress
```

Juju will then take the steps necessary to adjust firewall rules and any other
settings to expose the service via its given address. This process may take
anything from a few moments to several minutes. You can check on the current
status of your services by running:

```bash
juju status
```

This will return a status report like this:

```yaml
    machines:
      "0":
        agent-state: started
        agent-version: 1.12.0
        dns-name: 15.185.88.51
        instance-id: "1736045"
        series: precise
      "1":
        agent-state: started
        agent-version: 1.12.0
        dns-name: 15.185.89.204
        instance-id: "1736065"
        series: precise
    services:
      wordpress:
        charm: cs:precise/wordpress-42
        exposed: true
        units:
          wordpress/0:
            agent-state: started
            agent-version: 1.12.0
            machine: "1"
            open-ports:
              - 80/tcp
            public-address: 15.185.89.236
```

As you can see here, the `exposed:` status is listed as true, and the
service is running and available to users.

**Note:** Exposing the service does not change any DNS or other settings which may be necessary to get your service running as you expect.

# Unexposing a service

To return the firewall settings and make a service non-public again, you
simply need to run the `unexpose` command. For example:

```bash
juju unexpose wordpress
```
