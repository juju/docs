# Configuring for OpenStack

You should start by generating a generic configuration file for Juju, using the
command:

    juju init

This will generate a file, `environments.yaml`, which will live in your
`~/.juju/` directory (and will create the directory if it doesn't already
exist).

!!__Note:__ If you have an existing configuration, you can use `juju init
--show` to output the new config file, then copy and paste relevant areas
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

!!__Note:__ At any time you can run `juju init --show` to display the most revent
version of the environments.yaml template file, instead of having it write to
file.

Remember to substitute in the parts of the snippet that are important to you. If
you are deploying on OpenStack the following documentation might also be useful:

[Ubuntu Cloud
Infrastructure](https://help.ubuntu.com/community/UbuntuCloudInfrastructure)
