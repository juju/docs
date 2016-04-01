Title: Exposing services    


# Exposing Services

By design, Juju operates a very secure environment for deploying your services.
Even if you have deployed services, they won't be publicly available unless
you explicitly make them so. To allow public access to services, the
appropriate changes must be made to the cloud provider firewall settings. As
the procedure for doing this varies depending on your cloud, Juju helpfully
abstracts this into a single command, `juju expose <servicename>`.

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
juju status
[Services]
NAME       STATUS  EXPOSED CHARM                
mariadb    unknown false   cs:trusty/mariadb-2  
wordpress  unknown true    cs:trusty/wordpress-4

[Relations]
SERVICE1    SERVICE2  RELATION     TYPE   
mariadb     mariadb   cluster      peer   
mariadb     wordpress db           regular
mariadb     wordpress db           regular
wordpress   wordpress loadbalancer peer   

[Units]    
ID          WORKLOAD-STATE AGENT-STATE VERSION    MACHINE PORTS  PUBLIC-ADDRESS MESSAGE
mariadb/0   unknown        idle        2.0-alpha2 2              54.224.143.151        
wordpress/0 unknown        idle        2.0-alpha2 1       80/tcp 54.145.6.196          

[Machines]
ID         STATE   DNS            INS-ID     SERIES AZ        
1          started 54.145.6.196   i-0a9c888f trusty us-east-1b
2          started 54.224.143.151 i-9626540e trusty us-east-1c 
```

As you can see here under [Services], the `EXPOSED:` status is listed as true,
and the service is running and available to users.

**Note:** Exposing the service does not change any DNS or other settings which
may be necessary to get your service running as you expect.

# Unexposing a service

To return the firewall settings and make a service non-public again, you
simply need to run the `unexpose` command. For example:

```bash
juju unexpose wordpress
```



