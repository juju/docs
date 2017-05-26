Title: Command changes 1.x to 2.0  

# Command changes from 1.25 to 2.0


<style> table td{text-align:left;}</style>

| 1.25 command                         | 2.0 command                   |
|--------------------------------------|-------------------------------|
| juju environment destroy             | juju destroy-model             
| juju environment get                 | juju model-config
| juju environment get-constraints     | juju get-model-constraints 
| juju environment retry-provisioning  | juju retry-provisioning
| juju environment set                 | juju model-config 
| juju environment set-constraints     | juju set-model-constraints
| juju environment share               | juju grant 
| juju environment unset               | juju model-config
| juju environment unshare             | juju revoke
| juju environment users               | juju list-users
| juju user add                        | juju add-user
| juju user change-password            | juju change-user-password
| juju user disable                    | juju disable-user
| juju user enable                     | juju enable-user
| juju user info                       | juju show-user
| juju user list                       | juju list-users
| juju machine add                     | juju add-machine 
| juju machine remove                  | juju remove-machine 
| juju authorised-keys add             | juju add-ssh-key
| juju authorised-keys list            | juju list-ssh-keys
| juju authorised-keys delete          | juju remove-ssh-key
| juju authorised-keys import          | juju import-ssh-key
| juju get                             | juju config
| juju set                             | juju config
| juju get-constraints                 | juju get-model-constraints
| juju set-constraints                 | juju set-model-constraints
| juju get-constraints <application>   | juju get-constraints
| juju set-constraints <application>   | juju set-constraints
| juju backups create                  | juju create-backup 
| juju backups restore                 | juju restore-backup 
| juju action do                       | juju run-action 
| juju action defined                  | juju list-actions 
| juju action fetch                    | juju show-action-output 
| juju action status                   | juju show-action-status 
| juju storage list                    | juju list-storage 
| juju storage show                    | juju show-storage 
| juju storage add                     | juju add-storage 
| juju space create                    | juju add-space 
| juju space list                      | juju list-spaces 
| juju subnet add                      | juju add-subnet 
| juju ensure-availability             | juju enable-ha
| juju system create-environment       | juju add-model             
| juju system destroy                  | juju destroy-controller    
| juju system environments             | juju list-models           
| juju system kill                     | juju kill-controller       
| juju system list                     | juju list-controllers      
| juju system login                    | juju login                 
| juju system remove-blocks            | juju enable-commands       
| juju system list-blocks              | juju list-disabled-commands


