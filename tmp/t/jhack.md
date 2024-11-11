(jhack)=
# 'jhack'

> <small> {ref}`Developer tools <8047md>` > {ref}`Tools for debugging <8047md>` > `jhack` </small>
>
> See also upstream: [`jhack`](https://github.com/PietroPasotti/jhack)

`jhack` is an opinionated CLI tool to make charm development and debugging easier. For example, with `jhack show-relation` you can pretty-print databags from two related applications and with `jhack tail` you can watch what events are being fired on what units in real time.

`jhack` can be installed [as a snap](https://snapcraft.io/jhack) or [from sources](https://github.com/PietroPasotti/jhack). 
```{note}

If you install the snap, you'll need to 
`sudo snap connect jhack:dot-local-share-juju snapd ` to give jhack read/write access to your `~/.local/share/juju` juju data folder.

If you are running LXD models, you will also need to provide jhack access to your ssh keys so it can run `juju ssh` on your behalf:
`sudo snap connect jhack:ssh-read snapd:ssh-keys`.

```
Run `jhack` without any argument to see a list of toplevel commands and some subcommands.

> See more:
> - {ref}``jhack tail` <explore-event-emission-with-jhack-tail>`
> - {ref}``jhack show-relation` <visualize-relation-data-with-show-relation>`
> - [all `jhack` topics on Discourse](https://discourse.charmhub.io/tag/jhack)