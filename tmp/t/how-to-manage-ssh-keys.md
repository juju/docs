(how-to-manage-ssh-keys)=
# How to manage SSH keys

> See also: {ref}`SSH key <ssh-key>`

**Contents:**

- [Add an SSH key](#heading--add-an-ssh-key)
- [Import an SSH key](#heading--import-an-ssh-key)
- [View the available SSH keys](#heading--view-the-available-ssh-keys) 
- [Remove an SSH key](#heading--remove-an-ssh-key)

<a href="#heading--add-an-ssh-key"><h2 id="heading--add-an-ssh-key">Add an SSH key</h2></a>

{ref}`tabs]
[tab version="juju"]

To add a public `ssh` key to a model, use the `add-ssh-key` command followed by a string containing the entire key or an equivalent shell formula:

```text

# Use the entire ssh key:
juju add-ssh-key "ssh-rsa qYfS5LieM79HIOr535ret6xy
AAAAB3NzaC1yc2EAAAADAQA6fgBAAABAQCygc6Rc9XgHdhQqTJ
Wsoj+I3xGrOtk21xYtKijnhkGqItAHmrE5+VH6PY1rVIUXhpTg
pSkJsHLmhE29OhIpt6yr8vQSOChqYfS5LieM79HIOJEgJEzIqC
52rCYXLvr/BVkd6yr4IoM1vpb/n6u9o8v1a0VUGfc/J6tQAcPR
ExzjZUVsfjj8HdLtcFq4JLYC41miiJtHw4b3qYu7qm3vh4eCiK
1LqLncXnBCJfjj0pADXaL5OQ9dmD3aCbi8KFyOEs3UumPosgmh
VCAfjjHObWHwNQ/ZU2KrX1/lv/+lBChx2tJliqQpyYMiA3nrtS
jfqQgZfjVF5vz8LESQbGc6+vLcXZ9KQpuYDt joe@ubuntu"


# Use an equivalent shell formula:
juju add-ssh-key "$(cat ~/mykey.pub)"

```

<!--SAW THIS SOMEWHERE ELSE. THIS IS SUPPOSED TO BE THE DEFAULT USER FOR A JUJU MACHINE. BUT WHICH JUJU MACHINE ARE WE TALKING ABOUT NOW? WE JUST SAID WE'RE ADDING THIS TO THE MODEL.

This will add the SSH key to the default user account named 'ubuntu'.
-->

> See more: [`juju add-ssh-key` <command-juju-add-ssh-key>`

[/tab]

[tab version="terraform juju"]
To add a public `ssh` key to a model, in your Terraform plan create a resource of the `juju_ssh_key` type, specifying the name of the model and the payload (here, the SSH key itself). For example:

```text
resource "juju_ssh_key" "mykey" {
  model   = juju_model.development.name
  payload = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1I8QDP79MaHEIAlfh933zqcE8LyUt9doytF3YySBUDWippk8MAaKAJJtNb+Qsi+Kx/RsSY02VxMy9xRTp9d/Vr+U5BctKqhqf3ZkJdTIcy+z4hYpFS8A4bECJFHOnKIekIHD9glHkqzS5Vm6E4g/KMNkKylHKlDXOafhNZAiJ1ynxaZIuedrceFJNC47HnocQEtusPKpR09HGXXYhKMEubgF5tsTO4ks6pplMPvbdjxYcVOg4Wv0N/LJ4ffAucG9edMcKOTnKqZycqqZPE6KsTpSZMJi2Kl3mBrJE7JbR1YMlNwG6NlUIdIqVoTLZgLsTEkHqWi6OExykbVTqFuoWJJY3BmRAcP9H3FdLYbqcajfWshwvPM2AmYb8V3zBvzEKL1rpvG26fd3kGhk3Vu07qAUhHLMi3P0McEky4cLiEWgI7UyHFLI2yMRZgz23UUtxhRSkvCJagRlVG/s4yoylzBQJir8G3qmb36WjBXxpqAGHfLxw05EQI1JGV3ReYOs= user@somewhere"
}
```

> See more: [`juju_ssh_key` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/ssh_key)

[/tab]

[tab version="python libjuju"]
To add a public `ssh` key to a model, on a connected Model object, use the `add_ssh_key()` method, passing a name for the key and the actual key payload. For example:

```python
SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1I8QDP79MaHEIAlfh933zqcE8LyUt9doytF3YySBUDWippk8MAaKAJJtNb+Qsi+Kx/RsSY02VxMy9xRTp9d/Vr+U5BctKqhqf3ZkJdTIcy+z4hYpFS8A4bECJFHOnKIekIHD9glHkqzS5Vm6E4g/KMNkKylHKlDXOafhNZAiJ1ynxaZIuedrceFJNC47HnocQEtusPKpR09HGXXYhKMEubgF5tsTO4ks6pplMPvbdjxYcVOg4Wv0N/LJ4ffAucG9edMcKOTnKqZycqqZPE6KsTpSZMJi2Kl3mBrJE7JbR1YMlNwG6NlUIdIqVoTLZgLsTEkHqWi6OExykbVTqFuoWJJY3BmRAcP9H3FdLYbqcajfWshwvPM2AmYb8V3zBvzEKL1rpvG26fd3kGhk3Vu07qAUhHLMi3P0McEky4cLiEWgI7UyHFLI2yMRZgz23UUtxhRSkvCJagRlVG/s4yoylzBQJir8G3qmb36WjBXxpqAGHfLxw05EQI1JGV3ReYOs= user@somewhere"
await my_model.add_ssh_key('admin', SSH_KEY)
```

> See more: [`add_ssh_key()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.add_ssh_key), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]

<a href="#heading--import-an-ssh-key"><h2 id="heading--import-an-ssh-key">Import an SSH key</h2></a>

[tabs]
[tab version="juju"]


To import a public SSH key from Launchpad / Github to a model, use the `import-ssh-key` command followed by `lp:` / `gh:` and the name of the user account. For example, the code below imports all the public keys associated with the Github user account ‘phamilton’:

```text
juju import-ssh-key gh:phamilton
```

<!--SAW THIS SOMEWHERE ELSE. THIS IS SUPPOSED TO BE THE DEFAULT USER FOR A JUJU MACHINE. BUT WHICH JUJU MACHINE ARE WE TALKING ABOUT NOW? WE JUST SAID WE'RE ADDING THIS TO THE MODEL.

This will add the SSH key to the default user account named 'ubuntu'.
-->

> See more: [`juju import-ssh-key` <command-juju-import-ssh-key>`

{ref}`/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
The `python-libjuju` client does not currently support this. Please use the `juju` client.
[/tab]
[/tabs]

<a href="#heading--view-the-available-ssh-keys"><h2 id="heading--view-the-available-ssh-keys">View the available SSH keys</h2></a>

[tabs]
[tab version="juju"]


To list the currently known SSH keys for the current model, use the `ssh-keys` command. 

```text
# List the keys known in the current model
juju ssh-keys
```

If you want to get more details, or get this information for a different model, use the `--full` or the `--model / -m <model name>` option.

<!--# List the keys known in the 'jujutest' model
juju ssh-keys -m jujutest --full
-->

> See more: [`juju ssh-keys` <command-juju-ssh-keys>`

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client.
[/tab]

[tab version="python libjuju"]
To list the currently known SSH keys for the current model, on a connected Model object, use the `get_ssh_keys()` method. For example:

```python

await my_model.get_ssh_keys()
```

> See more: [`get_ssh_keys()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.get_ssh_keys), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
{ref}`/tab]
[/tabs]

<a href="#heading--remove-an-ssh-key"><h2 id="heading--remove-an-ssh-key">Remove an SSH key</h2></a>




[tabs]
[tab version="juju"]


To remove an SSH key, use the `remove-ssh-key` command followed by the key / a space-separated list of keys. The keys may be specified by either their fingerprint or the text label associated with them. The example below illustrates both:

```text
juju remove-ssh-key 45:7f:33:2c:10:4e:6c:14:e3:a1:a4:c8:b2:e1:34:b4 bob@ubuntu 
```

> See more: [`juju remove-ssh-key` <command-juju-remove-ssh-key>`

[/tab]

[tab version="terraform juju"]
To remove an SSH key, remove its resource definition from your Terraform plan.

> See more: [`juju_ssh_key` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/ssh_key)

[/tab]

[tab version="python libjuju"]
To remove an SSH key, on a connected Model object, use the `remove_ssh_key()` method, passing the user name and the key as parameters. For example:

```python
SSH_KEY = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1I8QDP79MaHEIAlfh933zqcE8LyUt9doytF3YySBUDWippk8MAaKAJJtNb+Qsi+Kx/RsSY02VxMy9xRTp9d/Vr+U5BctKqhqf3ZkJdTIcy+z4hYpFS8A4bECJFHOnKIekIHD9glHkqzS5Vm6E4g/KMNkKylHKlDXOafhNZAiJ1ynxaZIuedrceFJNC47HnocQEtusPKpR09HGXXYhKMEubgF5tsTO4ks6pplMPvbdjxYcVOg4Wv0N/LJ4ffAucG9edMcKOTnKqZycqqZPE6KsTpSZMJi2Kl3mBrJE7JbR1YMlNwG6NlUIdIqVoTLZgLsTEkHqWi6OExykbVTqFuoWJJY3BmRAcP9H3FdLYbqcajfWshwvPM2AmYb8V3zBvzEKL1rpvG26fd3kGhk3Vu07qAUhHLMi3P0McEky4cLiEWgI7UyHFLI2yMRZgz23UUtxhRSkvCJagRlVG/s4yoylzBQJir8G3qmb36WjBXxpqAGHfLxw05EQI1JGV3ReYOs= user@somewhere"
await my_model.remove_ssh_key('admin', SSH_KEY)
```

> See more: [`remove_ssh_key()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.remove_ssh_key), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @hmlanigan, @tmihoc </small>