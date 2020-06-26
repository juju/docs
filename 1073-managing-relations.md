Most applications rely on other applications to function correctly. For example, typically web apps require a database to connect to. Relations avoid the need for manual intervention when the charm's environment changes. The charm will be notified of new changes, re-configure and restart the application automatically.  

Relations are a Juju abstraction that enables application to inter-operate. They are a communication channel between charms. 

A certain charm knows that it requires, say, a database and, correspondingly, a database charm knows that is capable of satisfying another charm's requirements. The act of joining such mutually-dependent charms causes code (*hooks*) to run in each charm in such a way that both charms can effectively talk to one another. When charms have joined logically in this manner they are said to have formed a *relation*.

[note]
A requirement for a relation is that both applications are currently deployed. See the [Deploying applications](/t/deploying-applications/1062) page for guidance.
[/note]

<h2 id="heading--creating-relations">Creating relations</h2>

Creating a relation is straightforward enough. The `add-relation` command is used to set up a relation between two applications:

``` text
juju relate mysql wordpress
```

This will satisfy WordPress's database requirement where MySQL provides the appropriate structures (e.g. tables) needed for WordPress to run properly.

<h3 id="heading--ambiguous-relations">Ambiguous relations</h3>

If the charms in question are versatile enough, Juju may need to be supplied with more information as to how the charms should be joined.

To demonstrate, if we try instead to relate the 'mysql' charm to the 'mediawiki' charm:

``` text
juju relate mysql mediawiki 
```

This is what will happen:

``` text
error: ambiguous relation: "mediawiki mysql" could refer to
  "mediawiki:db mysql:db"; "mediawiki:slave mysql:db"
```

The solution is to be explicit when referring to an *endpoint*, where the latter has a format of `<application>:<application endpoint>`. In this case, it is 'db' for both applications. However, it is not necessary to specify the mysql endpoint because only the MediaWiki endpoint is ambiguous (according to the error message). Therefore, the command becomes:

``` text
juju add-relation mysql mediawiki:db
```

[note]
An application endpoint can be discovered by looking at the metadata of the corresponding charm. This can be done by examining the charm on the [Charm Store](https://jujucharms.com) or by querying the Store with the [Charm Tools](/t/charm-tools/1180) (using a command like `charm show <application> charm-metadata`).
[/note]

The output to `juju status --relations` will display the relations:

<!-- JUJUVERSION: 2.4-beta4-xenial-amd64 -->
<!-- JUJUCOMMAND: juju status --relations -->
``` text
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

<h2 id="heading--cross-model-relations">Cross model relations</h2>

Relations can also work across models, even across multiple controllers and clouds.

This functionality can enable your databases to be hosted on bare metal, where I/O performance is paramount, and your apps to live within Kubernetes, where scalability and application density are more important.

See [Cross model relations](/t/cross-model-relations/1150) for more information.

<h2 id="heading--removing-relations">Removing relations</h2>

There are times when a relation just isn't working and it is time to move on. See the [Removing things](/t/removing-things/1063#heading--removing-relations) page for how to do this.

## Implementation details

Relations are not network connections. They're implemented on top of the connections that the unit agents establish with the controller at startup. 

The Juju controller acts as a message broker within a virtual [star typology](https://en.wikipedia.org/wiki/Star_network). This allows units to send data via relations that might not have connectivity with each other.


<!-- LINKS -->
