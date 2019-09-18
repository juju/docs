Introduction
===

Note: This is a sharp knife feature - be careful with it.

Cloudinit-userdata
--
Allows the user to provide additional cloudinit data to be included in the cloudinit data created by juju.  In general, specifying a key will overwrite what juju puts in the cloudinit file with the following caveats: 
1. Users and bootcmd keys will cause an error
2. The packages key will be appended to the packages listed by juju
3. The runcmds key will cause an error.  You can specify preruncmd and postruncmd keys to prepend and append the runcmd created by juju
Included in juju 2.3.1.

Using
--
Create a file, cloudinit-userdata.yaml, which starts with the cloudinit-userdata key and data you wish to include in the cloudinit file.  Note: juju reads the value as a string, though formatted as yaml.  

`juju model-config cloudinit-userdata.yaml`
`juju model-config cloudinit-userdata --format yaml`

sample yaml:

    cloudinit-userdata: |
      packages:
        - 'python-keystoneclient'
        - 'python-glanceclient'

Known Issues
--
- Runcmd accepts both lists of strings and strings.  Only strings strings are handled until ["cloudinit-userdata doesn't handle lists in rancid properly"](https://bugs.launchpad.net/juju/+bug/1759398) is fixed.
- must be passed via file, not on the command line.
