Title: Juju and systemd


# Juju and systemd

Below we cover the important issue of the migration of the init system used in
Ubuntu: upstart to systemd.

See [https://wiki.ubuntu.com/SystemdForUpstartUsers](https://wiki.ubuntu.com/SystemdForUpstartUsers).


## General

Ubuntu 15.04 (Vivid) is the first release that will ship with systemd enabled
by default. However, for a limited time its cycle will overlap with a version
of Juju that does not support systemd. Since systemd is supported starting with
Juju 1.23 a Vivid Juju host will need to revert to upstart when using juju <
1.23 :

```bash
sudo apt-get install upstart
sudo update-grub
```

On Vivid, once 1.23 is updated on it, the older (< 1.23) packages will equally
be updated to enforce the above automatically.

### Issues

- For the Local Provider (LXC), a Vivid (systemd) container may not boot on a non-Vivid
  host. See [LP bug #1347020](https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1347020).

- The provisioning of a Juju-managed machine requires knowledge of the init
  system in use on that machine. This is achieved by mapping the init system to
  the Juju version on the machine (`juju version info`):

```no-highlight
  pre-Vivid versions => upstart
  Vivid+ versions => systemd
```
  This mapping may not always hold true. To force the provisiniong process
  (`cloud-init`) to use upstart set `JUJU_DEV_FEATURE_FLAGS=legacy-upstart` in
  the Juju user's shell environment.


## Charms

- Charms that directly call upstart-specific tools will need to adjust (e.g.
  "start", "stop", "restart", and "initctl"). We recommend using "service" where
  possible. Where it's not the charm will need to identify the running init
  system and react accordingly.

- Charms that install their own upstart scripts will need to adjust. As above,
  they will need to react to the currently running init system.
