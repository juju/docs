**Usage:** `juju diff-bundle [options] <bundle file or name>`

**Summary:**

Compares a bundle with a model and reports any differences.

**Options:**

`B, --no-browser-login (= false)`

Do not use web browser for authentication

`--annotations (= false)`

Include differences in annotations

`--channel (= "")`

Channel to use when getting the bundle from the charm store

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

`--map-machines (= "")`

Indicates how existing machines correspond to bundle machines

`--overlay (= )`

Bundles to overlay on the primary bundle, applied in order

**Details:**

Bundle can be a local bundle file or the name of a bundle in the charm store. The bundle can also be combined with overlays (in the same way as the `deploy` command) before comparing with the model.

The map-machines option works similarly as for the deploy command, but existing is always assumed, so it doesn't need to be specified.

**Examples:**

       juju diff-bundle localbundle.yaml
        juju diff-bundle canonical-kubernetes
        juju diff-bundle -m othermodel hadoop-spark
        juju diff-bundle mongodb-cluster --channel beta
        juju diff-bundle canonical-kubernetes --overlay local-config.yaml --overlay extra.yaml
        juju diff-bundle localbundle.yaml --map-machines 3=4
**See also:**

[deploy](https://discourse.jujucharms.com/t/command-deploy/1707)
