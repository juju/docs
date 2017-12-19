Title: Distributing snaps internally

# Distributing snaps internally

*This is in connection with the [Working offline][charms-offline] page. See
that resource for background information.*

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
