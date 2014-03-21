[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# Exposing Services

By design, Juju operates a very secure environment for deploying your services.
Even if you have deployed services, they won't be publically available unless
you explicitly make them so. To allow public access to services, the appropriate
changes must be made to the cloud provider firewall settings. As the procedure
or doing this varies depending on the provider, Juju helpfully abtracts this
into a single command, `juju expose &LT;servicename&GT;`

For example, you may have deployed a WordPress service using the relevant charm.
Once deployed, the service still cannot be accessed by the public, so you would
run:

    
    
    juju expose wordpress

Juju will then take the steps necessary to adjust firewall rules and any other
settings to expose the service via its given address. This process may take
anything from a few moments to several minutes. You can check on the current
status of your services by running:

    
    
    juju status

This will return a status report like this:

    
    
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

As you can see here, the `exposed:` status is listed as true, and the service is
running and available to users.

__Note:__ Exposing the service does not change any DNS or other settings which
may be neccessary to get your service running as you expect.

# Unexposing a service

To return the firewall settings and make a service non-public again, you simply
need to run the `unexpose` command. For example:

    
    
    juju unexpose wordpress

  - ## [Juju](/)

    - [Charms](/charms)
    - [Features](/features)
    - [Deployment](/deployment)
  - ## [Resources](/resources)

    - [Overview](/resources/juju-overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/the-juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://canonical.com).

