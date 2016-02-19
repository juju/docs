Title: Configuring Juju for use with vSphere  

# Configuring the VMWare (vSphere) provider

Juju supports VMWare's vSphere ("Software-Defined Data Center") installations
as a targetable cloud. In order to use the vSphere provider, you will need to
have an existing vSphere installation, which supports VMWare's Hardware Version
8 or better.

To enable Juju to work with VMWare vSphere, you should start by generating a
generic configuration file using the command:

```bash
juju generate-config
```

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

!!! Note: If you have an existing configuration, you can use
`juju generate-config --show` to output the new config file, then copy and
paste relevant areas in a text editor etc.

The basic configuration will look something like this:

```yaml
vsphere:
   type: vsphere
   host: <api-endpoint>
   user: <some-user>
   password: <some-password>
   datacenter: <datacenter-name>
   external-network: <external-network-name>
```

The values indicated by angle brackets (`<` and `>`) need to be replaced, (e.g `user: vmuser`)
with your vSphere information. 

  - `host` must contain the IP address or DNS name of vSphere API endpoint. 
  - `user` and `password` are fields that must contain your vSphere user credentials 
  - `datacenter` field must contain the name of your vSphere virtual datacenter. 
  - `external-network` is an optional field. If set, it contains the name of
     the network that will be used to obtain public IP addresses for each
     virtual machine provisioned by Juju. An IP pool must be configured in this
     network and all available public IP addresses must be added to this pool for it
     to work with Juju instances. 

For more information on IP pools, see 
[VMWare's official documentation](https://pubs.vmware.com/vsphere-51/index.jsp?topic=2Fcom.vmware.vsphere.vm_admin.doc%2FGUID-5B3AF10D-8E4A-403C-B6D1-91D9171A3371.html).

You should also refer to the 
[section on general configuration options](config-general.html)
for additional and advanced customisation of your environment.
