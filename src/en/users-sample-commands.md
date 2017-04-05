Title: Juju sample commands


# Sample command usage and output interpretation

This section seeks to clarify the meaning of the output to some commands and
how other commands can alter that output.

Consider the following output to `juju controllers` on some given system:

```no-highlight
CONTROLLER         MODEL        USER         SERVER
local.lxd-trusty*  lxd-staging  admin@local  10.61.51.78:17070
lxd-jim            -            jim@local    10.195.10.130:17070
lxd-rod            lxd-pilot    rod@local    10.195.10.130:17070
lxd-sam            -            -            10.195.10.130:17070
```

Interpretation:

- Controller 'lxd-trusty' is a controller that is local to the client
  system (prefix 'local.'). It was bootstrapped there.
- The other 3 controllers are due to users being registered to the same
  remote controller with IP address 10.195.10.130. Each user decided to
  base the name of "their" controller on their name (i.e. 'lxd-jim').
- The "current" controller, model, and user are 'lxd-trusty',
  'lxd-staging', and 'admin' respectively (the * character denotes this).
  These will be used as the defaults in many commands.
- Users 'admin', 'jim', and 'rod' are logged in.
- User 'jim' has not been granted access to a model.
- An administrator on the remote controller has granted user 'rod' access
  to model 'lxd-pilot'.
- The user (presumably 'sam') who named their controller 'lxd-sam' is
  logged out and may, or may not, have access to a model.

Let's see how the above output is altered if we have user 'sam' log in to their
controller. Before doing so, we list users to ensure 'sam' is the actual user
and switch to his controller:

```bash
juju users
juju switch lxd-sam
juju login sam
```

The output becomes:

```no-highlight
CONTROLLER        MODEL        USER         SERVER
local.lxd-trusty  lxd-staging  admin@local  10.61.51.78:17070
lxd-jim           -            jim@local    10.195.10.130:17070
lxd-rod           lxd-pilot    rod@local    10.195.10.130:17070
lxd-sam*          lxd-prod     sam@local    10.195.10.130:17070
```

Interpretation:

- User 'sam' has indeed been granted access to a model ('lxd-prod').
- The "current" controller, model, and user are now 'lxd-sam', 'lxd-prod',
  and 'sam' respectively.

Note that a login cannot occur if there is an ongoing user session with that
same controller. An error will be emitted. The other user will need to log out
first.

After login, it is a good idea for the user to list the models available to him:

```bash
juju models
```

Also, if the model is granted after user registration it may not show up upon
login. In that case, the user will need to switch to the model:

```bash
juju switch <model name>
```

The `juju switch` command can refer to &lt;controller name&gt;, &lt;model
name&gt;, or  
 &lt;controller name&gt;:&lt;model name&gt;.
