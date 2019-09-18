**Usage:** `juju remove-ssh-key [options] <ssh key id> ...`

**Summary:**

Removes a public SSH key (or keys) from a model.

**Options:**

`-B, --no-browser-login (= false)`

Do not use web browser for authentication

`-m, --model (= "")`

Model to operate in. Accepts `[<controller name>:]<model name>`

**Details:**

Juju maintains a per-model cache of public SSH keys which it copies to each unit. This command will remove a specified key (or space separated list of keys) from the model cache and all current units deployed in that model. The keys to be removed may be specified by the key's fingerprint, or by the text label associated with them.

**Examples:**

       juju remove-ssh-key ubuntu@ubuntu
        juju remove-ssh-key 45:7f:33:2c:10:4e:6c:14:e3:a1:a4:c8:b2:e1:34:b4
        juju remove-ssh-key bob@ubuntu carol@ubuntu
**See also:**

[ssh-keys](https://discourse.jujucharms.com/t/command-ssh-keys/1835), [add-ssh-key](https://discourse.jujucharms.com/t/command-add-ssh-key/1676), [import-ssh-key](https://discourse.jujucharms.com/t/command-import-ssh-key/1733)
