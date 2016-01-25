Title: Command changes 1.x to 2.0
TODO: Add new commands 
      Add completely new commands

# Command changes from 1.25 to 2.0

!!! Note: These are provisional changes at the moment, not guaranteed


<style> table td{text-align:left;}</style>

| Old command                          | New command                        |
|:-------------------------------------|:-----------------------------------|
| juju action defined                  | `juju list-action`                 |
| juju action do                       | `juju run-action`                  |
| juju action fetch                    | `juju show-action-output`          |
| juju action status                   | `juju show-actions-status`         |
| juju add-machine                     | UNCHANGED                          |
| juju add-relation                    | UNCHANGED                          |
| juju add-unit                        | UNCHANGED                          |
| juju api-endpoints		       | deprecated (see [show-model][show-model])|
| juju api-info                        | deprecated (see [show-model][show-model])|
| juju authorised-keys add             | `juju add-ssh-key`                 |
| juju authorised-keys delete          |                                    |
| juju authorised-keys import          |                                    |
| juju authorised-keys list            |                                    |
| juju backups create                  |                                    |
| juju backups download                |                                    |
| juju backups info                    |                                    |
| juju backups list                    |                                    |
| juju backups remove                  |                                    |
| juju backups restore                 |                                    |
| juju backups upload                  |                                    |
| juju block all-changes               |                                    |
| juju block destroy-model             |                                    |
| juju block list                      |                                    |
| juju block remove-object             |                                    |
| juju cached-images delete            |                                    |
| juju cached-images list              |                                    |
| juju debug-hooks                     |                                    |
| juju debug-log                       |                                    |
| juju destroy-environment             |                                    |
| juju destroy-relation                |                                    |
| juju destroy-service                 |                                    |
| juju destroy-unit                    |                                    |
| juju ensure-availability             |                                    |
| juju environment get                 |                                    |
| juju environment retry-provisioning  |                                    |
| juju environment set                 |                                    |
| juju environment unset               |                                    |
| juju expose                          |                                    |
| juju generate-config                 | deprecated ([see config docs][init])|
| juju get                             |                                    |
| juju get-constraints                 |                                    |
| juju get-environment                 |                                    |
| juju help                            |                                    |
| juju help tool                       |                                    |
| juju init                            | deprecated ([see config docs][init])|
| juju list-payloads                   |                                    |
| juju machine add                     |                                    |
| juju machine remove                  |                                    |
| juju publish                         | deprecated ([see docs on publishing charms][charm-publishing])|
| juju remove-machine                  |                                    |
| juju remove-relation                 |                                    |
| juju remove-service                  |                                    |
| juju remove-unit                     |                                    |
| juju resolved                        |                                    |
| juju retry-provisioning              |                                    |
| juju service add-unit                |                                    |
| juju service get                     |                                    |
| juju service get-constraints         |                                    |
| juju service help                    |                                    |
| juju service set                     |                                    |
| juju service set-constraints         |                                    |
| juju service unset                   |                                    |
| juju set-constraints                 |                                    |
| juju set-environment                 |                                    |
| juju ssh                             | UNCHANGED                          |
| juju status                          | UNCHANGED                          |
| juju status-history                  |                                    |
| juju space create                    |                                    |
| juju space help                      |                                    |
| juju space list                      |                                    |
| juju storage add                     |                                    |
| juju storage filesystem              |                                    |
| juju storage help                    |                                    |
| juju storage list                    |                                    |
| juju storage pool                    |                                    |
| juju storage show                    |                                    |
| juju storage volume                  |                                    |
| juju subnet add                      |                                    |
| juju subnet help                     |                                    |
| juju subnet list                     |                                    |
| juju switch                          | UNCHANGED                          |
| juju sync-tools                      | deprecated                         |
| juju terminate-machine               |                                    |
| juju unblock all-changes             |                                    |
| juju unblock destroy-environment     |                                    |
| juju unblock remove-object           |                                    |
| juju unset                           |                                    |
| juju unset-env                       |                                    |
| juju unset-environment               |                                    |
| juju upgrade-charm                   |                                    |
| juju upgrade-juju                    | UNCHANGED                          |
| juju user add                        |                                    |
| juju user change-password            |                                    |
| juju user disable                    |                                    |
| juju user enable                     |                                    |
| juju user help                       |                                    |
| juju user info                       |                                    |
| juju user list                       |                                    |
| juju version                         | UNCHANGED                          |


## New commands in 2.0

| New command                | Summary                                      |
|:---------------------------|:---------------------------------------------|
|                            |                                              |






[init]: ./juju-config.md "Configuring Juju"
[show-model]: ./commands.md#show-model "juju show-model"
[charm-publishing]: ./developers-charm-store "publishing a charm"

