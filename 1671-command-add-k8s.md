**Usage:** `juju add-k8s [options] <k8s name>`

**Summary:**

Adds a k8s endpoint and credential to Juju.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-c, --controller (= "")`

Controller to operate in

`--cluster-name (= "")`

Specify the k8s cluster to import

**Details:**

Creates a user-defined cloud and populate the selected controller with the k8s cloud details. Speficify non default kubeconfig file location using $KUBECONFIG environment variable or pipe in file content from stdin. The config file can contain definitions for different k8s clusters, use `--cluster-name` to pick which one to use.

**Examples:**

       juju add-k8s myk8scloud
        KUBECONFIG=path-to-kubuconfig-file juju add-k8s myk8scloud --cluster-name=my_cluster_name
        kubectl config view --raw | juju add-k8s myk8scloud --cluster-name=my_cluster_name
**See also:**

[remove-k8s](https://discourse.jujucharms.com/t/command-remove-k8s/1786)
