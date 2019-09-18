**Usage:** `juju destroy-model [options] [<controller name>:]<model name>`

**Summary:**

Terminate all machines/containers and resources for a non-controller model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`--destroy-storage (= false)`

Destroy all storage instances in the model

`--release-storage (= false)`

Release all storage instances from the model, and management of the controller, without destroying them

`-t, --timeout (= 30m0s)`

Timeout before model destruction is aborted

`-y, --yes (= false)`

Do not prompt for confirmation

Details:

Destroys the specified model. This will result in the non-recoverable removal of all the units operating in the model and any resources stored there. Due to the irreversible nature of the command, it will prompt for confirmation (unless overridden with the `-y` option) before taking any action.

If there is persistent storage in any of the models managed by the controller, then you must choose to either destroy or release the storage, using `--destroy-storage` or `--release-storage` respectively.

**Examples:**

       juju destroy-model test
        juju destroy-model -y mymodel
        juju destroy-model -y mymodel --destroy-storage
        juju destroy-model -y mymodel --release-storage
**See also:**

[destroy-controller](https://discourse.jujucharms.com/t/command-destroy-controller/1708)
