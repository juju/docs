Title: Command changes 1.x to 2.0  
TODO: Add new commands   
      Add completely new commands  

# Command changes from 1.25 to 2.0

!!! Note: These are provisional changes at the moment, no guarantees!


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
| juju authorised-keys delete          | `juju remove-ssh-key`              |
| juju authorised-keys import          | `juju import-ssh-key`              |
| juju authorised-keys list            | `juju list-ssh-key`                |
| juju backups create                  | `juju create-backup`               |
| juju backups download                | `juju download-backup`             |
| juju backups info                    | `juju show-backup`                 |
| juju backups list                    | `juju list-backup`                 |
| juju backups remove                  | `juju remove-backup`               |
| juju backups restore                 | `juju restore-backup`              |
| juju backups upload                  | `juju upload-backup`               |
| juju block all-changes               | `juju disable-command`             |
| juju block destroy-model             | `juju disable-command`             |
| juju block list                      | `juju list-disable-commands`       |
| juju block remove-object             | `juju disable-command`             |
| juju bootstrap                       | UNCHANGED                          |
| juju cached-images delete            | `juju remove-cached-image`         |
| juju cached-images list              | `juju list-cached-images`          |
| juju debug-hooks                     | UNCHANGED                          |
| juju debug-log                       | UNCHANGED                          |
| juju destroy-environment             | `juju destroy-model`               |
| juju destroy-relation                | `juju remove-relation`             |
| juju destroy-service                 | `juju remove-service`              |
| juju destroy-unit                    | `juju remove-unit`                 |
| juju ensure-availability             | `juju enable-ha`  (to enable)      |
| juju ensure-availability             | `juju restore-ha` (to restore)     |
| juju environment retry-provisioning  | `juju retry-machine`               |
| juju environment set                 | `juju set-model-config`            |
| juju environment unset               | `juju set-model-config --default`  |
| juju expose                          | UNCHANGED                          |
| juju generate-config                 | deprecated ([see config docs][init])|
| juju get                             | `juju get-config`                  |
| juju get-constraints                 | UNCHANGED                          |
| juju get-environment                 | deprecated                         |
| juju help                            | UNCHANGED                          |
| juju help tool                       | `juju list-hook-tools`             |
| juju init                            | deprecated ([see config docs][init])|
| juju list-payloads                   | UNCHANGED                          |
| juju machine add                     | `juju add-machine`                 |
| juju machine remove                  | `juju remove-machine`             |
| juju publish                         | deprecated ([see docs on publishing charms][charm-publishing])|
| juju remove-machine                  | UNCHANGED                          |
| juju remove-relation                 | UNCHANGED                          |
| juju remove-service                  | UNCHANGED                          |
| juju remove-unit                     | UNCHANGED                          |
| juju resolved                        | `juju set-resolved` (see also `retry-hook`)|
| juju retry-provisioning              | `juju retry-machine`               |
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

