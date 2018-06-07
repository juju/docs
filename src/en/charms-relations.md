Title: Managing relations

# Managing relations

Few applications are so simple that they can run independently - most rely on
other applications. A certain charm knows that it requires, say, a database
and, correspondingly, a database charm knows that is capable of accommodating
the other charm's requirements. The act of joining such mutually-dependent
charms causes code (*hooks*) to run in each charm in such a way that both
charms can effectively talk to one another. When charms have joined logically
in this manner they are said to have formed a *relation*.

!!! Note:
    A criteria for forming a relation is that both applications are currently
    *deployed*. See the [Deploying applications][charms-deploying] page for
    guidance.

## Creating relations

Creating a relation is straightforward enough. The `add-relation` command is
used to set up a relation between two applications:

```bash
juju add-relation mysql wordpress
```

This will satisfy WordPress's database requirement where MySQL provides the
appropriate structures (e.g. tables) needed for WordPress to run properly.

### Ambiguous relations

If the charms in question are versatile enough, Juju may need to be supplied
with more information as to how the charms should be joined.

To demonstrate, if we try instead to relate the 'mysql' charm to the
'mediawiki' charm:

```bash
juju add-relation mysql mediawiki 
```

This is what will happen:

```no-highlight
error: ambiguous relation: "mediawiki mysql" could refer to
  "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"
```

The solution is to be explicit when referring to an *endpoint*, where the
latter has a format of `<application>:<application endpoint>`. In this case, it
is 'db' for both applications. However, it is not necessary to specify the
mysql endpoint because only the mediawiki endpoint is ambiguous (according to
the error message). Therefore, the command becomes:

```bash
juju add-relation mysql mediawiki:db
```

!!! Note:
    An application endpoint can be discovered by looking at the metadata of the
    corresponding charm. This can be done by examining the charm on the
    [Charm Store][charm-store] or by querying the Store with the
    [Charm Tools][charm-tools] (using a command like
    `charm show &lt;application&gt; charm-metadata`).

The output to `juju status --relations` will display the relations:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
```no-highlight
Model    Controller  Cloud/Region         Version    SLA          Timestamp
default  lxd         localhost/localhost  2.4-beta4  unsupported  20:22:45Z

App        Version  Status  Scale  Charm      Store       Rev  OS      Notes
mediawiki  1.19.14  active      1  mediawiki  jujucharms   19  ubuntu  
mysql      5.7.22   active      1  mysql      jujucharms   58  ubuntu  

Unit          Workload  Agent  Machine  Public address  Ports     Message
mediawiki/0*  active    idle   2        10.115.37.227   80/tcp    Ready
mysql/0*      active    idle   1        10.115.37.45    3306/tcp  Ready

Machine  State    DNS            Inst id        Series  AZ  Message
1        started  10.115.37.45   juju-db874f-1  xenial      Running
2        started  10.115.37.227  juju-db874f-2  trusty      Running

Relation provider  Requirer       Interface  Type     Message
mysql:cluster      mysql:cluster  mysql-ha   peer     
mysql:db           mediawiki:db   mysql      regular
```

The final section of the status output shows all current established relations.

## Removing relations

There are times when a relation just isn't working and it is time to move on.
See [Removing Juju objects][charms-destroy] for how to do this.

## Cross model relations

Relations can also work across models, even across multiple controllers. See
[Cross model relations][models-cmr] for more information.


<!-- LINKS -->

[charms-deploying]: ./charms-deploying.md
[models-cmr]: ./models-cmr.md
[charm-tools]: ./tools-charm-tools.md
[charm-store]:  https://jujucharms.com
[charms-destroy]: ./charms-destroy.md#removing-relations
