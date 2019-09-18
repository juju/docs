The Charm Tools package is a collection of commands that assist with charm management. In particular, it allows charm authors to create charms.

<h2 id="heading--installation">Installation</h2>

Charm Tools can be installed on various platforms with the use of [Snaps](https://docs.snapcraft.io/snaps/). The name of the snap is called `charm`.

To install the Charm Tools on Ubuntu:

``` text
sudo snap install charm --classic
```

To install on other Linux distributions see the upstream [Snaps documentation](https://snapcraft.io/docs/core/install).

There are no recent builds of Charm Tools for other operating systems. Check the [Charm Tools project](https://github.com/juju/charm-tools) for further information.

<h2 id="heading--usage">Usage</h2>

All the functionality provided by the Charm Tools is accessed via the `charm` command and a sub-command argument. Omitting the argument will give a listing of all sub-commands. To view an individual help page for each sub-command run `charm help <sub-command>`.

Click the triangle to reveal a summary of a sub-command.

<details> <summary>add</summary>
<pre><code>  charm add [-h] [--description] [-b] [--debug] {tests,readme,icon}
</code></pre>
<p>Extends a charm depending on the options chosen:</p>
<p>#### tests</p>
<p><code>tests</code> will create a tests directory for a charm and generate an example test
  using the Amulet framework. This command will ingest relation data from the
  charm <code>metadata.yaml</code> and create test file, <code>00-autogen</code>, based on matching
  charms to the interfaces listed. This is merely an example to start with and
  will need to be modified.</p>
<p>#### readme</p>
<p><code>readme</code> will create a <code>README.ex</code> in the <code>CHARM_DIRECTORY</code> from the template
  charm.</p>
<p>#### icon</p>
<p><code>icon</code> will create an <code>icon.svg</code> in the <code>CHARM_DIRECTORY</code>. This icon is
  a template and should be customised by the charm author (see
  <a href="/t/creating-icons-for-charms/1041">Charm Icons documentation</a>).</p>
<!-- LINKS -->
</details>

<details> <summary>attach</summary>
<pre><code>  charm attach [options] &lt;charm id&gt; &lt;resource=&lt;file&gt;
</code></pre>
<p>Uploads a file as a new resource for a charm.</p>
<pre><code>  charm attach ~user/trusty/wordpress-0 website-data=./foo.zip
</code></pre>
<p>A revision number is only required when using the stable channel, which is
  the default channel.</p>
<pre><code>  charm attach ~user/mycharm mydata=./blah -c unpublished
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>build</summary>
<pre><code>  charm build [-h] [-l LOG_LEVEL] [-f] [-o OUTPUT_DIR] [-s SERIES]
[--hide-metrics] [--interface-service INTERFACE_SERVICE] [--no-local-layers] [-n NAME] [-r] [--description] [charm]</code></pre>

Builds a charm from layers and interfaces.
</details>

<details> <summary>create</summary>
<pre><code>  charm create [-h] [-t TEMPLATE] [-a] [-v] [--description] charmname [charmhome]
</code></pre>
<p>Creates a new charm.</p>
<p>The will produce a new boilerplate charm. Replace <code>&lt;charmname&gt;</code> with the
  name of your new charm. A directory called <code>&lt;charmname&gt;</code>, and any necessary
  sub-directories and files, will be created in the <code>[charmhome]</code> directory, or
  your current directory if no <code>[charmhome]</code> directory is provided.</p>
<p>By default, your new charm is created using the Python template. Use the
  <code>-t TEMPLATE</code> option to create a charm using a different template, e.g.:</p>
<pre><code>  charm create -t bash my-charm
</code></pre>
<p>To see the list of installed templates use <code>charm create -h</code>.</p>
<p>Depending on the template being used, <code>charm create</code> may prompt for
  user input. To suppress prompts and accept all defaults instead, use the
  <code>-a</code> or <code>--accept-defaults</code> option.</p>
<!-- LINKS -->
</details>

<details> <summary>grant</summary>
<pre><code>  charm grant [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;] [--acl (read|write)] [--set] [,,...]
</code></pre>
<p>Extends permissions for the given charm or bundle to the given users.</p>
<pre><code>  charm grant ~johndoe/wordpress fred
</code></pre>
<p>The command accepts many users (comma-separated list) or everyone.</p>
<p>The --acl parameter accepts "read" and "write" values. By default "read"
  permissions are granted:</p>
<pre><code>  charm grant ~johndoe/wordpress --acl write fred
</code></pre>
<p>The --set parameter is used to overwrite any existing ACLs:</p>
<pre><code>  charm grant ~johndoe/wordpress --acl write --set fred,bob
</code></pre>
<p>To select a channel, use the --channel option:</p>
<pre><code>  charm grant ~johndoe/wordpress --channel stable --acl write --set fred,bob
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>help</summary>
<pre><code>  charm help [command]
</code></pre>
<p>Shows help on a command.</p>
<p>Running just <code>charm</code> (with no arguments) will display the list of available
  commands.</p>
<!-- LINKS -->
</details>

<details> <summary>layers</summary>
<pre><code>  charm layers [-h] [-r] [-l LOG_LEVEL] [--description] [charm]
</code></pre>
<p>Inspects the layers of a built charm.</p>
<!-- LINKS -->
</details>

<details> <summary>list</summary>
<pre><code>  charm list [options]
</code></pre>
<p>Lists the charms under a given user name, by default yours.</p>
<pre><code>  charm list -u lars
</code></pre>
<p>When no arguments are given it returns a list of charms that the currently
  logged in user has pushed.</p>
<pre><code>  charm list
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>list-resources</summary>
<pre><code>  charm list-resources [options] &lt;charm&gt;
</code></pre>
<p>Displays the resources for a charm in the Charm Store.</p>
<p>The charm can be expressed as a charm URL, or an unambiguously condensed form
  of it. So the following forms will be accepted:</p>
<p>For cs:trusty/mysql :<br />
    mysql<br />
    trusty/mysql  </p>
<p>For cs:~user/trusty/mysql :<br />
    cs:~user/mysql</p>
<p>When the series is not supplied, the series from your local host is used.
  Thus the above examples imply that the local series is trusty.</p>
<!-- LINKS -->
</details>

<details> <summary>login</summary>
<pre><code>  charm login
</code></pre>
<p>Logs the user in to the Charm Store using Ubuntu SSO.</p>
<!-- LINKS -->
</details>

<details> <summary>logout</summary>
<pre><code>  charm logout
</code></pre>
<p>Logs the user out of the Charm Store.</p>
<!-- LINKS -->
</details>

<details> <summary>proof</summary>
<pre><code>  charm proof [-h] [--description] [-b] [--debug] [charm_name]
</code></pre>
<p>Performs static analysis on a charm or bundle.</p>
<!-- LINKS -->
</details>

<details> <summary>pull</summary>
<pre><code>  charm pull [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;] [&lt;directory&gt;]
</code></pre>
<p>Downloads a copy of a charm or bundle from the Charm Store into a local
  directory. If the directory is unspecified, the directory will be named after
  the charm or bundle.</p>
<p>To download the wordpress charm into directory 'wordpress' in the current directory:</p>
<pre><code>  charm pull trusty/wordpress
</code></pre>
<p>To select a channel, use the --channel option:</p>
<pre><code>  charm pull wordpress --channel edge
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>pull-source</summary>
<pre><code>  charm pull-source [-h] [-v] [--description] item [dir]
</code></pre>
<p>Downloads the source code for a charm, layer, or interface.</p>
<p>The item to download can be specified using any of the following forms:</p>
<ul>
<li>[cs:]charm</li>
<li>[cs:]series/charm</li>
<li>[cs:]~user/charm</li>
<li>[cs:]~user/series/charm</li>
<li>layer:layer-name</li>
<li>interface:interface-name</li>
</ul>
<p>If the item is a layered charm, and the top layer of the charm has a repo
  key in layer.yaml, the top layer repo will be cloned. Otherwise, the charm
  archive will be downloaded and extracted from the Charm Store.</p>
<p>If a download directory is not specified, the following environment variables
  will be used to determine the download location:</p>
<ul>
<li>For charms, $JUJU_REPOSITORY</li>
<li>For layers, $LAYER_PATH</li>
<li>For interfaces, $INTERFACE_PATH</li>
</ul>
<p>If a download location can not be determined from environment variables, the
  current working directory will be used.</p>
<p>The download is aborted if the destination directory already exists.</p>
<!-- LINKS -->
</details>

<details> <summary>push</summary>
<pre><code>  charm push [options] &lt;directory&gt; [&lt;charm or bundle id&gt;]
</code></pre>
<p>Uploads a charm or bundle from the local directory to the Charm Store.</p>
<p>The charm or bundle id must not specify a revision: the revision will be
  chosen by the Charm Store to be one more than any existing revision.
  If the id is not specified, the current logged-in Charm Store user name is
  used, and the charm or bundle name is taken from the provided directory name.</p>
<p>The pushed charm or bundle is unreleased and therefore usually only available
  to a restricted set of users. See the release command for info on how to make
  charms and bundles available to others.</p>
<pre><code>  charm push .
  charm push /path/to/wordpress wordpress
  charm push . cs:~lars/trusty/wordpress
</code></pre>
<p>Resources may be uploaded at the same time by specifying the --resource flag.
  Following the resource flag should be a name=filepath pair. This flag may be
  repeated more than once to upload more than one resource.</p>
<pre><code>  charm push . --resource website=~/some/file.tgz --resource config=./docs/cfg.xml
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>push-term</summary>
<pre><code>  charm push-term [options] &lt;filename&gt; &lt;term id&gt;
</code></pre>
<p>Creates a new Terms and Conditions document (revision).</p>
<p>For example, to create a new terms document called 'enterprise-plan', whose
  contents is from file <code>text.txt</code>, and return the revision of the new document:</p>
<pre><code>  charm push-term text.txt user/enterprise-plan
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>release</summary>
<pre><code>  charm release [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;]
</code></pre>
<p>Publishes a charm or bundle to the Charm Store. Releasing is the action of
  assigning one channel to a specific charm or bundle revision (revision needs
  to be specified), so that it can be shared with other users and also referenced
  without specifying the revision. Four channels are supported, in order of
  stability: "stable", "candidate", "beta", and "edge"; the "stable" channel is
  the default.</p>
<pre><code>  charm release ~bob/trusty/wordpress
</code></pre>
<p>To select another channel, use the --channel option:</p>
<pre><code>  charm release ~bob/trusty/wordpress --channel beta
  charm release wily/django-42 -c edge --resource website-3 --resource data-2
</code></pre>
<p>If your charm uses resources, you must specify what revision of each resource
  will be published along with the charm, using the --resource flag (one per
  resource). Note that resource info is embedded in bundles, so you cannot use
  this flag with bundles.</p>
<pre><code>  charm release wily/django-42 --resource website-3 --resource data-2
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>release-term</summary>
<pre><code>  charm release-term [options] &lt;term id&gt;
</code></pre>
<p>Releases the given terms document. For instance:</p>
<pre><code>  charm release-term me/my-terms
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>revoke</summary>
<pre><code>  charm revoke [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;] [--acl (read|write)] [,,...]
</code></pre>
<p>Restricts permissions for the given charm or bundle to the given users.</p>
<pre><code>  charm revoke ~kirk/wordpress james
</code></pre>
<p>The command accepts many users (comma-separated list) or everyone.</p>
<p>The <code>--acl</code> parameter accepts "read" and "write" values. By default all
  permissions are revoked.</p>
<pre><code>  charm revoke ~kirk/wordpress --acl write james
</code></pre>
<p>To select a channel, use the <code>--channel</code> option, for instance:</p>
<pre><code>  charm revoke ~kirk/wordpress --channel beta --acl write james,robert
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>set</summary>
<pre><code>  charm set [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;] name=value [name=value]
</code></pre>
<p>Updates the extra-info, home page or bugs URL for the given charm or bundle.</p>
<pre><code>  charm set wordpress bugs-url=https://bugspageforwordpress.none
  charm set wordpress homepage=https://homepageforwordpress.none
</code></pre>
<p>The separator used when passing key/value pairs determines the type:
  "=" for string fields, ":=" for non-string JSON data fields. Some
  fields are forced to string and cannot be arbitrary JSON.</p>
<p>To select a channel, use the <code>--channel</code> option, for instance:</p>
<pre><code>  charm set wordpress someinfo=somevalue --channel edge
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>show</summary>
<pre><code>  charm show [options] &lt;charm or bundle id&gt; [--channel &lt;channel&gt;] [--list] [field1 ...]
</code></pre>
<p>Prints information about a charm or bundle. By default, only a summary is
  printed. You can specify --all to get all known metadata.</p>
<pre><code>  charm show trusty/wordpress
</code></pre>
<p>To select a channel, use the <code>--channel</code> option, for instance:</p>
<pre><code>  charm show wordpress --channel edge
</code></pre>
<p>To specify metadata for one or more specific channels:</p>
<pre><code>  charm show wordpress charm-metadata charm-config --channel stable
</code></pre>
<p>To get a list of available metadata types:</p>
<pre><code>  charm show --list
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>show-term</summary>
<pre><code>  charm show-term [options] &lt;term id&gt;
</code></pre>
<p>Shows the given terms document. For instance:</p>
<p>To show revision 1 of the enterprise-plan terms:</p>
<pre><code>  show-term enterprise-plan/1
</code></pre>
<p>To show the latest revision of the enterprise plan terms:</p>
<pre><code>  show-term enterprise-plan
</code></pre>
<!-- LINKS -->
</details>

<details> <summary>terms</summary>
<pre><code>  charm terms [options]
</code></pre>
<p>Lists the terms owned by the user and the charms that require these terms to
  be agreed to.</p>
<p>Charms can require users to accept terms before deployment. This is useful
  for software that needs a EULA.</p>
<!-- LINKS -->
</details>

<details> <summary>version</summary>
<pre><code>  charm version [-h] [--description] [-b] [--debug]
</code></pre>
<p>Displays tooling version information</p>
<!-- LINKS -->
</details>

<details> <summary>whoami</summary>
<pre><code>  charm whoami [options]
</code></pre>
<p>Displays JAAS user id and group membership.</p>
<!-- LINKS -->
</details>

<!-- LINKS -->
