**Usage:** `juju destroy-controller [options] <controller name>`

**Summary:**

Destroys a controller.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--destroy-all-models (= false)`

Destroy all hosted models in the controller

`--destroy-storage (= false)`

Destroy all storage instances managed by the controller

`--release-storage (= false)`

Release all storage instances from management of the controller, without destroying them

`-y, --yes (= false)`

Do not ask for confirmation

**Details:**

All models (initial model plus all workload/hosted) associated with the controller will first need to be destroyed, either in advance, or by specifying `--destroy-all-models`.

If there is persistent storage in any of the models managed by the controller, then you must choose to either destroy or release the storage, using `--destroy-storage` or `--release-storage` respectively.

**Examples:**

Destroy the controller and all hosted models. If there is persistent storage remaining in any of the models, then this will prompt you to choose to either destroy or release the storage.

`   juju destroy-controller --destroy-all-models mycontroller`

Destroy the controller and all hosted models, destroying any remaining persistent storage.

`   juju destroy-controller --destroy-all-models --destroy-storage`

Destroy the controller and all hosted models, releasing any remaining persistent storage from Juju's control.

`   juju destroy-controller --destroy-all-models --release-storage`

**See also:**

[kill-controller](https://discourse.jujucharms.com/t/command-kill-controller/1734), [unregister](https://discourse.jujucharms.com/t/command-unregister/1846)
