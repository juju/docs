(how-to-publish-your-charm-on-charmhub)=
# How to publish your charm on Charmhub

> See also: 
> - {ref}`Reasons to publish your charm on Charmhub <reasons-to-publish-your-charm-on-charmhub>`
> - {ref}`Charm publication checklist <stage-1-important-qualities>`

This document shows how to  publish your charm to the official repository of charms, [Charmhub](https://charmhub.io/).

**Contents:**

1. [Log in to Charmhub](#heading--log-in-to-charmhub)	 
1. [Register your charm's name](#heading--register-your-charms-name)
1. [Upload the charm](#heading--upload-the-charm)
1. [Release the charm](#heading--release-the-charm)
1. [Promote a charm revision to a lower risk level of the same track](#heading--promote-a-charm-revision-to-a-lower-risk-level-of-the-same-track)	

<a href="#heading--log-in-to-charmhub"><h2 id="heading--log-in-to-charmhub">Log in to Charmhub</h2></a>

To log into Charmhub, run `charmcraft login`:

```text
$ charmcraft login
Opening an authorization web page in your browser.
If it does not open, please open this URL:
...
```
> See more: {ref}``charmcraft login` <command-charmcraft-login>`

```{note}

Your `charmcraft` session will expire automatically, but you'll be prompted to re-authenticate automatically next time you try to access a feature that requires interaction with Charmhub.

```

<a href="#heading--register-your-charms-name"><h2 id="heading--register-your-charms-name">Register your charm's name</h2></a>


To register your charm's name to your account, choose a suitable name and then run the `charmcraft register` command followed by your desired charm name:

```text
$ charmcraft register my-awesome-charm
Congrats! You are now the publisher of 'my-awesome-charm'
```

```{note}

You only need to register the name if you haven't already registered it before. You can check which names you have already registered by running `charmcraft names`. See more:  {ref}``charmcraft names` <command-charmcraft-names>`.


<!--:

```text
$ charmcraft names
Name                  Visibility    Status
# ...
my-awesome-charm      public        registered
# ...

```
-->

```

> See more: {ref}``charmcraft register` <command-charmcraft-register>`, {ref}`Charm naming guidelines <charm-naming-guidelines>`


<a href="#heading--upload-the-charm"><h2 id="heading--upload-the-charm">Upload the charm</h2></a>

To upload the charm, use the `charmcraft upload` command followed by the your charm's filepath.

```text
charmcraft upload my-awesome-charm.charm
Revision 1 of my-awesome-charm created
```

> See more: {ref}``charmcraft upload` <command-charmcraft-upload>`

```{important}

**If your `metadata.yaml` lists any resources:** Those did not get packed with `charmcraft pack`, so they didn't get uploaded with `charmcraft upload <charm>` either. Make sure to upload them as well!
See more: {ref}`How to upload a resource to Charmhub <4462md>`.

```

```{note}

Every time a new binary is uploaded for a charm, a new revision is created on Charmhub. We can verify its current status easily by running `charmcraft revisions <charm-name>`. See more: {ref}``charmcraft revisions` <command-charmcraft-revisions>`.

```

<!--
```text
$ charmcraft revisions my-awesome-charm
Revision    Version    Created at    Status
1           0.1        2020-07-23    approved
```
-->

<a href="#heading--release-the-charm"><h2 id="heading--release-the-charm">Release the charm</h2></a>
> See also: {ref}``charmcraft release` <command-charmcraft-release>`, {ref}``charmcraft status` <command-charmcraft-status>`


Finally, release your charm into a channel so it can become available for downloading:

```bash
$ charmcraft release my-awesome-charm --revision=1 --channel=beta
Revision 1 of charm 'my-awesome-charm' released to beta
```
```{note}

Uploaded charms are not automatically released and made available for download. To consume a charm, first release it into a channel (any channel). Then Charmhub will display the charm's information at `charmhub.io/<charm-name>`. (The default information displayed is obtained from the most stable channel.)

```

Just in case, also check your charm's status:

```text
$ charmcraft status my-awesome-charm
Track    Channel    Version    Revision
latest   stable     -          -
         candidate  -          -
         beta       0.1        1
         edge       ↑          ↑
```

<a href="#heading--promote-a-charm-revision-to-a-lower-risk-level-of-the-same-track"><h2 id="heading--promote-a-charm-revision-to-a-lower-risk-level-of-the-same-track">Promote a charm revision to a lower risk level of the same track</h2></a>
> See also: {ref}`Promotion <promotion>`

There is currently no easy way to accomplish this with Charmcraft (though there is a feature request in progress: [link](https://github.com/canonical/charmcraft/issues/1633)). At present we recommend you use the GitHub `promote-charm` action.

> See more: [GitHub | `canonical/charming-actions/promote-charm`](https://github.com/canonical/charming-actions/tree/2.6.0/promote-charm)


<br>

> <small>**Contributors:** @facundo , @jnsgruk , @lucabello , @pmatulis, @ppasotti,  @sed-i , @tmihoc , @toto </small>