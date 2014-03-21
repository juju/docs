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

# Configuring for OpenStack

You should start by generating a generic configuration file for Juju, using the
command:

    
    
    juju generate-config

This will generate a file, __environments.yaml__, which will live in your
__~/.juju/__ directory (and will create the directory if it doesn't already
exist).

__Note:__ If you have an existing configuration, you can use `juju generate-
config --show` to output the new config file, then copy and paste relevant areas
in a text editor etc.

The essential configuration sections for OpenStack look like this:

    
    
    openstack:
      type: openstack
      # Specifies whether the use of a floating IP address is required to give the nodes
      # a public IP address. Some installations assign public IP addresses by default without
      # requiring a floating IP address.
      # use-floating-ip: false
      admin-secret: 13850d1b9786065cadd0f477e8c97cd3
      # Globally unique swift bucket name
      control-bucket: juju-fd6ab8d02393af742bfbe8b9629707ee
      # Usually set via the env variable OS_AUTH_URL, but can be specified here
      # auth-url: https://yourkeystoneurl:443/v2.0/
      # override if your workstation is running a different series to which you are deploying
      # default-series: precise
      # The following are used for userpass authentication (the default)
      auth-mode: userpass
      # Usually set via the env variable OS_USERNAME, but can be specified here
      # username: 
      # Usually set via the env variable OS_PASSWORD, but can be specified here
      # password: 
      # Usually set via the env variable OS_TENANT_NAME, but can be specified here
      # tenant-name: 
      # Usually set via the env variable OS_REGION_NAME, but can be specified here
      # region: 

__Note:__ At any time you can run `juju init --show` to display the most revent
version of the environments.yaml template file, instead of having it write to
file.

Remember to substitute in the parts of the snippet that are important to you. If
you are deploying on OpenStack the following documentation might also be useful:

[Ubuntu Cloud
Infrastructure](https://help.ubuntu.com/community/UbuntuCloudInfrastructure)

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

