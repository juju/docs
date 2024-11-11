(visualize-relation-data-with-show-relation)=
# Visualize relation data with `show-relation`

[`jhack`](https://snapcraft.io/jhack) `show-relation` is a command that allows you to visualize the databags of two related Juju applications.

For example, the `ingress-per-unit` relation between a Traefik unit and a Prometheus unit on kubernetes:
![image|690x291](upload://vfpyQmXEOVFDVG4rmSXRHoRU2PK.png) 

This command is very useful when developing integrations or debugging related charms. You can also make it tail the contents with `-w`: the table will remain visible and update itself as the databag contents change.

# Additional features

- support for **peer relations** (!)
![image|690x221](upload://tvu9ERQ20c7lNh38XO8udepGVyc.png)
- support for showing relations in models other than the current one (`-m`)
- optional suppression of empty databags (`-s`)
- command promoted to toplevel jhack: it used to be nested under `utils`. Now you can simply do `jhack show-relation`.
- better cli help and shortcuts for lazy/busy typers.
- support for "show me the *n*th relation" instead  of having to type out the whole `app-name:endpoint` thing: if you have 3 relations in your model, you can simply do `jhack show-relation -n 1` and jhack will print out the 2nd relation from the top (of the same list appearing when you do `juju status --relations`, that is.