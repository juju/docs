Title: The Juju charm store  

# The Juju Charm Store

Juju includes a charm store where charms and bundles can be uploaded,
published, and optionally shared with other users.

The charm store is broken down into two main sections. Recommended and Community.
In the Recommended space, charms have been vetted and reviewed by a Juju Charmer
and all updates to the charm are vetted prior to landing. Community is the wider
collective of charms shared but not yet submitted or vetted by Juju Charmers.

  - [Charm development information](developer-getting-started.html)
  - [Bundle creation information](charms-bundles.html)

In order to interact with the charm store you will need the latest
[charm command](tools-charm-tools.html), an
[Ubuntu SSO account](https://login.ubuntu.com/+login), and have logged in once
to [Launchpad](https://launchpad.net/+login).

## Login to the store

Most charm commands require authentication in order to operate. You can login
or logout of the store at anytime by issuing `charm login` or `charm logout`
respectively. During login you will be prompted for the following information:

 - `Username` - typically the email address used to access Ubuntu SSO
 - `Password` - Ubuntu SSO password
 - `Two-factor auth` - If enabled, enter 2FA information. Otherwise <kbd>Return</kbd> for None

## Entities explained

When a charm or bundle, referred to as entity from this point forward, is pushed
for the first time to the store it's placed as version 0 in the unpublished channel.
Every revision of an entity lives in the unpublished channel. Subsequent pushes of
different content to the store will automatically increment this number. So if an
entity is changed and pushed 4 times, the revision history would look as follows:

```
entity: 0---1---2---3

```

Channels group revisions into named streams. There are currently two channels:
stable and development. Each channel also tracks history of revisions. When a
revision is published to a channel, that channel pointer is changed and the
history for said channel is updated.

Building on the above example, if a user publishes revision 2 to the stable
channel the history would appear as such:

```
                  stable (2)
                 /
entity: 0---1---2---3
```

If, then, revision 3 is published to the development channel the history would
reflect the following:

```
                  stable (2)
                 /
entity: 0---1---2---3
                     \
                      development (3)
```

During this time, more revisions can be pushed to the default, unpublished,
channel. This represents general development iterations. As iterations are pushed
the stable and development channels do not update.


```
                  stable (2)
                 /
entity: 0---1---2---3---4---5---6
                     \
                      development (3)
```

The author can, at anytime, publish a revision to a channel. Revisions can also
exist in the same channel at the same time. For example, the author chooses to
publish revision 3 to the stable channel without updating the development
channel:

```
                      stable (3, 2)
                     /
entity: 0---1---2---3---4---5---6
                     \
                      development (3)
```

In doing so, the stable channel is updated to point to revision 3 and revision
3 is added to the channel history. The author can continue to push and publish.
Since revisions are a constant stream there are scenarios where the stable
channel may be pointed to a higher revision even though development revision
is actually newer.

In the following example revision 8 is development, a bug is
found in latest stable (revision 5) so a hot fix is applied and pushed as 9.
That revision is then published to the stable channel.

```
                                              stable (9, 5, 3, 2)
                                             /
entity: 0---1---2---3---4---5---6---7---8---9
                                         \
                                          development (8, 3)
```

While authors can publish older versions to the channels it is not encouraged.
An example, an author may mistakenly publish revision 10 to the stable
channel and not development, the author can re-publish revision 9 to stable:

```
                                              stable (9, 10, 9, 5, 3, 2)
                                             /
entity: 0---1---2---3---4---5---6---7---8---9---10
                                         \
                                          development (8, 3)
```

If a user managed to deploy that revision in that time they'll be notified of
an "upgrade" by juju which will effecively downgrade the charm back to revision
9.

## Pushing to the store

After building a charm or bundle, navigate to it's directory on disk and push it
to the store.

```
cd src/charms/foobar
charm push .
```

The `charm push` command will return the full ID for the pushed item. Since this
is the first time foobar was pushed the return for the command was

```
cs:~USER/foobar-0
```

If a charm or bundle id is not provided, they will default to `cs:~USER/NAME`
where `USER` is the `User` from the output of `charm whoami` and `NAME` is the
metadata.yaml `name` for charms and directory basename for bundles.

To define a series or different bundle name an id can be provided during push.
The following is a set of different support permutations given the following
`charm whoami` output:

```
User: kirk
Group membership: charm-examples 
```

User `kirk` can perform the following operations

```
charm push .
charm push . charm-name
charm push . bundle/bundle-name
charm push . ~charm-examples/charm-name
charm push . cs:~charm-examples/charm-name
```

Push will always increment the charm version in the unpublished channel.

## Publishing to channels

The charm store supports two channels: development and stable. Revisions are
associated with channels by using the publish charm command. Publish is executed
against an existant revision and places that revision as the channel pointer.

Given the following example:

```
$ charm push . foo
cs:~kirk/foo-9
```

The author could publish foo-9 to either the stable or development channel
doing the following, respectively:

```
charm publish cs:~kirk/foo-9
charm publish cs:~kirk/foo-9 --channel development
```

Now revision 9 exists in both the stable channel and the development channel.

## Sharing charms and bundles

All channels (unpublished, development, and stable) have read and write ACLs.
By default, only the owner of the entity exists in these ACLs.

To update the ACL for a charm or bundle, entity from this point forward, you
will need to grant users an ACL to whichever channel. By default, if you do
not supply either, the channel will default to stable and the ACL will be for
read access. The following example will grant james access to the stable
channel of the cs:~kirk/foo entity.

```
charm grant cs:~kirk/foo james
```

If, instead you wanted to give write access to the development channel for lars
you would issue the following

```
charm grant cs:~kirk/foo --channel development --acl write lars
```

Finally, to make the entity available for all to consume, there is a special
`everyone` user which allows you to make an entity available to general
public.

```
charm grant cs:~kirk/foo everyone
```
