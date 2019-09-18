**Usage:** `juju hook-tool [tool]`

**Summary:**

Show help on a Juju charm hook tool.

**Details:**

Juju charms can access a series of built-in helpers called 'hook-tools'. These are useful for the charm to be able to inspect its running environment. Currently available charm hook tools are:

         action-fail              set action fail status with message
          action-get               get action parameters
          action-set               set action results
          add-metric               add metrics
          application-version-set  specify which version of the application is deployed
          close-port               ensure a port or range is always closed
          config-get               print application configuration
          credential-get           access cloud credentials
          goal-state               print the status of the charm's peers and related units
          is-leader                print application leadership status
          juju-log                 write a message to the juju log
          juju-reboot              Reboot the host machine
          leader-get               print application leadership settings
          leader-set               write application leadership settings
          network-get              get network config
          open-port                register a port or range to open
          opened-ports             lists all ports or ranges opened by the unit
          pod-spec-set             set pod spec information
          relation-get             get relation settings
          relation-ids             list all relation ids with the given relation name
          relation-list            list relation units
          relation-set             set relation settings
          status-get               print status information
          status-set               set status information
          storage-add              add storage instances
          storage-get              print information for storage instance with specified id
          storage-list             list storage attached to the unit
          unit-get                 print public-address or private-address
**Examples**:

       For help on a specific tool, supply the name of that tool, for example:

            juju hook-tool unit-get
**Aliases:**

help-tool,

hook-tools
