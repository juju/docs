# Charm configuration

The optional `actions.yaml` file defines actions that can be run using the 
`juju do <action> [<options> ...]` feature.

If this file exists it must be structured with action names being first level
keys, and details about the action being sub key-values.


[For information about juju actions go here](./actions.md)


## Sample actions.yaml file


    actions:
      snapshot:
        description: Take a snapshot of the database.
        params:
          outfile:
            description: The file to write out to.
            type: string
            default: foo.bz2
      backup:
        description: Backup the database.
        params:
          backup-method:
            description: Description of backup-method
            type: string
            default: auto


