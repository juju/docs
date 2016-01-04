Title: DHX: Customized Hook Debugging Environment Plugin

# DHX: A Customized Hook Debugging Environment Plugin

[DHX](https://github.com/juju/plugins/blob/master/juju-dhx) is a Juju plugin
that allows you to fully and automatically customise the machines created by
Juju, making developing and debugging hooks as painless as possible.

It is a drop-in replacement for
[`juju debug-hooks`](./developer-debugging.html#the-'debug-hooks'-command).
It is still a plugin and not yet integrated into Juju itself, so currently
considered beta quality. DHX is recommended for more advanced users who need to
[debug hooks](./developer-debugging.html) repetitively.

Bugs, feature requests, and pull requests can be submitted against the [Juju
Plugins project](https://github.com/juju/plugins).


## Overview

The machines created by Juju are completely standard, based on the Ubuntu Cloud
image. While this consistency is great for running charms, when developing and
debugging those charms, most developers would prefer to be able to tweak things
such as their editor configuration, Bash configuration or install additional
editors or debugging libraries. Doing this each time on a new
machine spun up by Juju is repetitive and tedious.

DHX allows allows you to define setup and customizations that will be
automatically run the first time you start a debug session on a new machine.
Additionally, it has options for assisting with debugging, such as
automatically pulling down changes made to the remote charm during debugging,
or restarting the failed hook and automatically dropping you into a debug
session for that hook.

Here is an overview of the features:

- Option to use default tmux key bindings instead of screen bindings
- Upload files (e.g. custom bash and vim configurations)
- Execute custom init scripts upon first connect to a new environment
- Improved selection of unit to debug
- Automatic restart and debug a failed hook
- Automatic sync of changes made to charm during debug session
- Support for easy paired debug sessions


# Installation and setup

First, follow [the instructions in the README](https://github.com/juju/plugins#install)
to install the plugin bundle. This should be straightforward and will give you
access to DHX as well as all the other very useful Juju plugins in the bundle.

Next, create a configuration file to define what customizations to perform. For
example:

```bash
cat > ~/.juju/debug-hooks-rc.yaml <EOF
use_tmux_keybindings: true
uploads:
- '~/.vimrc'
- '~/.vim'
init: '~/.juju/my-dhx-init.sh'
sync_excludes:
- '.*'
- '*.pyc'
import_ids: []
auto_sync: false
auto_restart: false
EOF
```

This configuration will use the standard keybindings (`Ctrl-b`) for tmux instead
of the screen keybindings (`Ctrl-a`) that debug-hooks normally uses. It will
also upload your vim configuration and execute `my-dhx-init.sh` on the remote
machine upon the first connection to perform any additional customizations (e.g.
installing ipdb for improved debugging of charms written in Python).


## Running DHX

DHX is a drop-in replacement for `juju debug-hooks`. So, whenever you would use
`juju debug-hooks` to start a debugging session, you should instead use `juju
dhx` (or `juju debug-hooks-ext`, if you want to be verbose). This will
automatically detect if the environment you're connecting to has been
customized and, if not, apply your customizations.


## Improved unit selection

Instead of typing out the full unit name, in the form `service/0`, you can let
DHX figure out which unit you want to debug. It will use cues such as which
units are in error state, the charm you're working on in the current
directory, or a service name you give it instead of a unit name.

If DHX can't unambiguously choose a unit, it will present you with its best
guess along with a list of units that you can choose from by number or name, so
that just pressing `Enter` to accept the default will usually do the right
thing.

For example, in a case where you had three units running, two of which were
currently in an error state you could run:

```bash
juju status --format=oneline
```

Which might return:

```nohighlight
- chamilo/0: 10.0.3.107 (error)
- mysql/0: 10.0.3.139 (started)
- mysql/1: 10.0.3.181 (error)
```

To start a debug session, you could enter:
```bash
juju dhx
```

The plugin will then list the known units and prompt for your choice,
defaulting to the first unit found to be in the error state:

```nohighlight
Units:
0: chamilo/0 (error)
1: mysql/0
2: mysql/1 (error)

Select a unit by number or name: [chamilo/0]
```

You can also specify a service, like so:

```bash
juju dhx mysql
```

In this case only units running the given service are listed, and again,
the default choice is the first one found in the error state:

```nohighlight
Units:
0: mysql/0
1: mysql/1 (error)

Select a unit by number or name: [mysql/1]
```


## Retrying failed hooks

The most common reason why you need to start a debug-hooks session is because a
hook failed and you want to debug it to figure out why. Once you are in the
debug-hooks session, you want to restart the failed hook and start debugging
it.

Instead of manually running `juju resolved --retry $unit`, you can just add the
`--retry` (or just `-r`) option to dhx:

```bash
juju dhx -r
```

You will then be connected to the unit, it will be customised if necessary, and
the hook will be immediately restarted and paused for you to debug.

You can also set `auto_retry: true` in your config file to always assume the
`--retry` to be given.


## Syncing changes from the remote unit

When debugging hooks, you will almost always make changes to the charm to figure
out what went wrong and resolve the problem. However, it is easy to forget to
apply all of those changes to your local copy of the charm once you're
done.

There is a plugin in the bundle, `sync-charm`, which pulls down any changes made
to the charm on a remote unit, and DHX makes it super easy to use. Just invoke
DHX with the `--sync` (or just `-s`) option, and any changes you make during
your debugging session will be automatically pulled back down when you are done:

```bash
juju dhx -s
```

You can also set `auto_sync: true` in the config file to always assume the
`--sync` option to be given.

When using this option, however, you may pick up files that are
created by the charm while running which should not be pulled back down. Any
file you add to the list of `sync_excludes` in your config will be skipped when
performing the sync. The list also supports the use of wildcards.


## Remote Paired Debugging

It can be useful to get another set of eyes on a problem, so DHX also
makes it easy to do paired development when debugging charms. When creating a
DHX session, you can import another developer's Launchpad ID to allow them
to join your session.

To have a paired session with Bob, whose ID is 'bob', you would start your
session with:

```bash
juju dhx -i bob
```

For Bob to join your session, you will need to tell him the public address of
the unit, which you can get from `juju status`. Then Bob can join your session
using the `--join` (or just `-j`) option:

```bash
juju dhx -j $public_address
```

Bob will be connected and immediately brought into your tmux session.

Bob may also join the session without using DHX, using the following:

```bash
ssh -t ubuntu@$public_address 'sudo tmux attach'
```
