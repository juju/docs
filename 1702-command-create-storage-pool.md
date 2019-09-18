**Usage:** `juju create-storage-pool [options] <name> <provider> [<key>=<value> [<key>=<value>...]]`

**Summary:**

Create or define a storage pool.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Pools are a mechanism for administrators to define sources of storage that they will use to satisfy application storage requirements.

A single pool might be used for storage from units of many different applications - it is a resource from which different stores may be drawn.

A pool describes provider-specific parameters for creating storage, such as performance (e.g. IOPS), media type (e.g. magnetic vs. SSD), or durability.

For many providers, there will be a shared resource where storage can be requested (e.g. EBS in amazon).

Creating pools there maps provider specific settings into named resources that can be used during deployment.

Pools defined at the model level are easily reused across applications. Pool creation requires a pool name, the provider type and attributes for configuration as space-separated pairs, e.g. tags, size, path, etc.
