(set-up--tear-down-your-test-environment)=
# Set up / Tear down your test environment

This document shows how to set up a Juju test environment -- complete with a sandbox (Ubuntu VM), a local cloud (LXD for machine charms and MicroK8s for Kubernetes charms), and Juju -- and then how to tear it all down once you're done playing around.

There are two ways to get all this set up: automatically or manually. 

## Set up / tear down automatically

### Set up automatically

1. [Install Multipass](https://multipass.run/docs/how-to-install-multipass). 

```{caution}

**If on Windows:** Note that Multipass can only be installed on Windows 10 Pro or Enterprise. If you are using a different version, please  follow the [Set up / tear down manually](#heading--set-up---tear-down-manually) guide, omitting the Multipass step. 

```

For example, on Linux (assumes you have `snapd`):

```text
sudo snap install multipass
```

2. Use Multipass with the `charm-dev` blueprint to launch a Juju-ready Ubuntu VM (below `my-juju-vm`): 

```text
multipass launch --cpus 4 --memory 8G --disk 50G --name my-juju-vm charm-dev 
```

```{important}

This step may take a few minutes to complete (e.g., 10 mins).

This is because the command downloads, installs, (updates,) and configures a number of packages, and the speed will be affected by network bandwidth (not just your own, but also that of the package sources).

However, once it’s done, you’ll have everything you’ll need – all in a nice isolated environment that you can clean up easily.

> See more: [GitHub > `multipass-blueprints` > `charm-dev.yaml`](https://github.com/canonical/multipass-blueprints/blob/ae90147b811a79eaf4508f4776390141e0195fe7/v1/charm-dev.yaml#L134)

**Troubleshooting:** If this fails, run `multipass delete --purge my-juju-vm` to clean up, then try the `launch` line again. 

```


3. Open a shell into the VM:

```text
$ multipass shell my-juju-vm
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-100-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Mon Mar 18 17:11:59 CET 2024

  System load:  0.0               Processes:             117
  Usage of /:   5.6% of 28.89GB   Users logged in:       1
  Memory usage: 3%                IPv4 address for ens3: 10.238.98.63
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

16 updates can be applied immediately.
1 of these updates is a standard security update.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


Last login: Mon Mar 18 16:09:16 2024 from 10.238.98.1
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@my-juju-vm:~$ 

```

4. (Optional:) Verify that the VM has indeed come pre-equipped with everything you'll need:

Verify that you have Juju, MicroK8s (for machine charms) / LXD (for machine charms), a MicroK8s / LXD cloud (`microk8s` / `localhost`), a controller on that cloud (`microk8s` / `lxd`), and a workload model on that controller (`welcome-k8s` / `welcome-lxd`) by switching to the workload model:

----
```{dropdown} Expand to see the instructions for MicroK8s

```text
ubuntu@my-juju-vm:~$ juju switch microk8s:welcome-k8s
```

```


----
```{dropdown} Expand to see the instructions for LXD

```text
ubuntu@my-juju-vm:~$ juju switch lxd:welcome-lxd
```

```

-----

Done! 

```{important}


-  Going forward:
    - Use the Multipass VM shell to run all commands. 


- At any point:
    - To exit the shell, press `mod key + C` or type `exit`. 
    - To stop the VM after exiting the VM shell, run `multipass stop my-juju-vm`. 
    - To restart the VM and re-open a shell into it, type `multipass shell my-juju-vm`. 

```

### Tear down automatically

Delete the Multipass VM (below, `my-juju-vm`): 

```text
multipass delete --purge my-juju-vm
```

[Uninstall Multipass](https://multipass.run/docs/install-multipass#uninstall).

## Set up / tear down manually

### Set up manually

#### (Optional) Set up an Ubuntu VM with Multipass

1. Install Multipass: [Linux](https://multipass.run/docs/installing-on-linux) | [macOS](https://multipass.run/docs/installing-on-macos) | [Windows](https://multipass.run/docs/installing-on-windows). On Linux (assumes you have `snapd`):

```text
sudo snap install multipass
```

2. Use Multipass to launch an Ubuntu VM (below, `my-juju-vm`): 

```text
multipass launch --cpus 4 --memory 8G --disk 30G --name my-juju-vm
```

3. Open a shell into the VM:

```text
multipass shell my-juju-vm
```

#### Set up your cloud

Depending on whether you want to develop a Kubernetes / machine charm, you will have to set up the MicroK8s / LXD localhost cloud. For example, on Linux:

-----------------
```{dropdown} Expand to set up your MicroK8s cloud

```
# Install MicroK8s package:
$ sudo snap install microk8s --channel 1.28-strict

# Add your user to the `microk8s` group for unprivileged access:
$ sudo adduser $USER snap_microk8s

# Give your user permissions to read the ~/.kube directory:
$ sudo chown -f -R $USER ~/.kube

# Wait for MicroK8s to finish initialising:
$ sudo microk8s status --wait-ready

# Enable the 'storage' and 'dns' addons:
# (required for the Juju controller)
$ sudo microk8s enable hostpath-storage dns

# Alias kubectl so it interacts with MicroK8s by default:
$ sudo snap alias microk8s.kubectl kubectl

# Ensure your new group membership is apparent in the current terminal:
# (Not required once you have logged out and back in again)
$ newgrp snap_microk8s
```

```

--------

```{dropdown} Expand to set up your LXD cloud


```text
# LXD should already be there from the Charmcraft setup step; in case not:
$ lxd init --auto
$ lxc network set lxdbr0 ipv6.address none
```

```

----------------------

#### Set up Juju

On your Ubuntu VM, install Juju. It will automatically recognise your local LXD / MicroK8s cloud. Bootstrap  a controller into LXD / MicroK8s, then create a model:

```text
# Install Juju:
sudo snap install juju --channel 3.1/stable
# >>> juju (3.1/stable) 3.1.2 from Canonical✓ installed

# Since the juju package is strictly confined, you also need to manually create a path:
mkdir -p ~/.local/share

# For MicroK8s, if you are working with an existing snap installation, and it is not strictly confined: 
# (https://microk8s.io/docs/strict-confinement), you must also:
#
# # Share the MicroK8s config with Juju:
# sudo sh -c "microk8s config | tee /var/snap/juju/current/microk8s/credentials/client.config"
#
# # Give the current user permission to this file:
# sudo chown -f -R $USER:$USER /var/snap/juju/current/microk8s/credentials/client.config

# Register your MicroK8s / LXD cloud with Juju:
# Not necessary --juju recognises a local MicroK8s / LXD cloud automatically, as you can see by running 'juju clouds'. 
juju clouds
# >>> Cloud      Regions  Default    Type  Credentials  Source    Description
# >>> localhost  1        localhost  lxd   0            built-in  LXD Container Hypervisor
# >>> microk8s   1        localhost  k8s   1            built-in  A Kubernetes Cluster
# (If for any reason this doesn't happen, you can register it manually using 'juju add-k8s microk8s'.)

# Replace <cloud> with 'microk8s' or 'localhost' 
# to bootstrap a Juju controller into your  MicroK8s / LXD cloud. 
# We'll name our controller "my-controller".
juju bootstrap <cloud> my-controller

# Create a workspace, or 'model', on this controller. 
# We'll call ours "my-model".
# (In Kubernetes this corresponds to a namespace "my-model".)
juju add-model my-model

# Check status:
juju status
# >>> Model         Controller           Cloud/Region        Version  SLA          Timestamp
# >>> dev-model  tutorial-controller  microk8s/localhost  3.0.2    unsupported  16:05:03+01:00

# >>> Model "admin/dev-model" is empty.

# There's your charm model!

```

### Tear down manually

1. Tear down Juju:

```text
# Destroy any models you've created:
$ juju destroy-model my-model

# Destroy any controllers you've created:
$ juju destroy-controller my-controller

# Uninstall juju. For example:
$ sudo snap remove juju
```

2. Tear down the MicroK8s cloud:

```text
# Reset Microk8s:
$ sudo microk8s reset

# Uninstall Microk8s:
$ sudo snap remove microk8s

# Remove your user from the snap_microk8s group:
$ sudo gpasswd -d $USER snap_microk8s
```

<small><br> **Contributors:** @deezzir, @gbeuzeboc , @gzanchi, @ismailkayi, @jnsgruk , @kos.tsakalozos , @rbarry , @facundo , @saviq , @sed-i , @shrishtikarkera, @tmihoc , @zxhdaze   </small>