Title: Installing snaps offline

# Installing snaps offline

*This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.*

In order to install snaps on a proxy-restricted network the `snapd` daemon will
need to be made aware of what proxy to use. To pass environment variables to
snapd edit the `/etc/environment` file

For example, to set an HTTP proxy, whose URL is given by $PROXY_HTTP (e.g.
http://squid.internal:3128), the above file would contain:

```no-highlight
http_proxy=$PROXY_HTTP
```

The daemon will need to be restarted for this change to take effect:

```bash
sudo systemctl restart snapd
```

You should then be able to install snaps.

## Distributing snaps internally

If setting a proxy is not a viable option then you may opt to keep snaps on a
privileged system (i.e. one that does have internet connectivity) and share
them across your network.

There is no special mechanism for distributing snaps internally. Simply
download the desired snaps and share.

For example, below we create some holding directories and then download the
[Charm Tools][charm-tools] snap:

```bash
mkdir -p ~/snaps/charm
cd ~/snaps/charm
snap download charm
```

This yields two new files:

```no-highlight
-rw-rw-r-- 1 ubuntu ubuntu 5.5K Dec 19 15:07 charm_114.assert
-rw-r--r-- 1 ubuntu ubuntu  99M Dec 19 15:07 charm_114.snap
```

The `~/snaps/charm` directory can now be shared with other systems on the
restricted network.

Now, on one of those systems we install the snap:

```bash
sudo snap ack charm_114.assert
sudo snap install charm_114.snap
```


<!-- LINKS -->

[charms-offline]: ./charms-offline.html
[charm-tools]: ./tools-charm-tools.html
