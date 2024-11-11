(promotion)=
# Promotion

In the context of a charm or a bundle, just as in the context of a snap, **promotion** refers to the association of a {ref}`revision <revision>` to a higher-ranking {ref}`channel <channel>` risk level  of the same track.

For example, in the (partial) output of `juju info mongodb` below, revision `100` has been promoted from `3.6/edge` through `3.6/beta` and `3.6/candidate` all the way to `3.6/stable`. (The up arrow next to `3.6/beta` indicates that that channel has been closed and, if you try `juju deploy --channel 3.6/beta`, what you'll get is the next higher-ranking risk level of the same track, that is, `3.6/candidate`.)

```text
channels: |
  5/stable:       117  2023-04-20  (117)  12MB  amd64  ubuntu@22.04
  5/candidate:    117  2023-04-20  (117)  12MB  amd64  ubuntu@22.04
  5/beta:         ↑
  5/edge:         118  2023-05-03  (118)  13MB   amd64  ubuntu@22.04
  3.6/stable:     100  2023-04-28  (100)  860kB  amd64  ubuntu@20.04, ubuntu@18.04
  3.6/candidate:  100  2023-04-13  (100)  860kB  amd64  ubuntu@20.04, ubuntu@18.04
  3.6/beta:       ↑
  3.6/edge:       100  2023-02-03  (100)  860kB  amd64  ubuntu@20.04, ubuntu@18.04
```

Charm promotion is done at release time by specifying the revision number and the channel `[track/]risk` level that you want to associate it with (e.g., `charmcraft release --revision 118 --channel=5/candidate`).