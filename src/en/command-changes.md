Title: Command changes 1.x to 2.0  
TODO: Add completely new commands  

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
| juju machine remove                  | `juju remove-machine`              |
| juju publish                         | deprecated ([see docs on publishing charms][charm-publishing])|
| juju remove-machine                  | UNCHANGED                          |
| juju remove-relation                 | UNCHANGED                          |
| juju remove-service                  | UNCHANGED                          |
| juju remove-unit                     | UNCHANGED                          |
| juju resolved                        | `juju set-resolved` (see also `retry-hook`)|
| juju retry-provisioning              | `juju retry-machine`               |
| juju service add-unit                | `juju add-unit`                    |
| juju service get                     | `juju get-config`                  |
| juju service get-constraints         | `juju get-constraints`             |
| juju service help                    | deprecated                         |
| juju service set                     | `juju set-config`                  |
| juju service set-constraints         | `juju set-constraints`             |
| juju service unset                   | deprecated (use `juju set-config --to-default`)|
| juju set-constraints                 | `juju set-constraints`             |
| juju set-environment                 | deprecated                         |
| juju ssh                             | UNCHANGED                          |
| juju status                          | UNCHANGED (now defaults to tabular format)|
| juju status-history                  | `juju show-status-log`             |
| juju space create                    | `juju add-space`                   |
| juju space list                      | `juju list-space`                  |
| juju storage add                     | `juju add-storage`                 |
| juju storage filesystem              | deprecated                         |
| juju storage list                    | `juju list-storage`                |
| juju storage pool                    | `juju list pools`, `juju add-pool` |
| juju storage show                    | `juju show-storage`                |
| juju storage volume                  | deprecated                         |
| juju subnet add                      | `juhu add-subnet`                  |
| juju subnet list                     | `juju list-subnet`                 |
| juju switch                          | UNCHANGED                          |
| juju sync-tools                      | deprecated                         |
| juju terminate-machine               | use `juju remove-machine`          |
| juju unblock all-changes             | `juju enable-commands --all`       |
| juju unblock destroy-environment     | `juju enable-commands --destroy-model`|
| juju unblock remove-object           | `juju enable-command --remove-object`|
| juju unexpose                        | UNCHANGED                          |
| juju upgrade-charm                   | UNCHANGED                          |
| juju unset                           | deprecated                         |
| juju unset-env                       | deprecated                         |
| juju unset-environment               | deprecated                         |
| juju upgrade-charm                   | UNCHANGED                          |
| juju upgrade-juju                    | UNCHANGED                          |
| juju user add                        | `juju add-user`                    |
| juju user change-password            | `juju change-password`             |
| juju user disable                    | `juju disable-user`                |
| juju user enable                     | `juju enable-user`                 |
| juju user info                       | `juju show-user`                   |
| juju user list                       | `juju list-user`                   |
| juju version                         | UNCHANGED                          |


## New commands in 2.0

| New command                | Summary                                      |
|:---------------------------|:---------------------------------------------|
|                            |                                              |






[init]: ./juju-config.md "Configuring Juju"
[show-model]: ./commands.md#show-model "juju show-model"
[charm-publishing]: ./developers-charm-store "publishing a charm"

