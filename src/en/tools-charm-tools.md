Title: Charm tools  

The 'Charm Tools' Juju Plugin is a collection of commands enabling users
and charm authors to create, search, fetch, update, and
manage charms.

# Installation

The source project can be found at
[https://launchpad.net/charm-tools](https://launchpad.net/charm-tools).

## Ubuntu
To install the latest Charm Tools, you simply need to grab the latest charm-
tools package from this PPA:

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt-get update && sudo apt-get install charm-tools
```

## Mac OSX
Charm Tools is available via [Homebrew](http://brew.sh/). Make sure you're
running the latest version of homebrew before proceeding.

To install, run the following:

```bash
brew install charm-tools
```

## Windows
Charm Tools is available for, and tested, on Microsoft Windows 7 and 8. While
the installer may work on previous versions of Windows there is no guarantee.

To install, first download the Charm Tools installer from
[launchpad](https://launchpad.net/charm-tools/1.2/1.2.9/+download/charm-
tools_1.2.9.exe). Once downloaded, execute the installer and follow the on-
screen prompts. After installation you can access Charm Tools either via the
`charm` command from either the command line or powershell.

To uninstall, please remove Charm Tools from the Add/Remove Software section of
the Windows Control Panel

# Usage

Charm Tools comes packaged as a stand alone tool and provides the `charm` command.
There are several tools available within charm tools itself. At any time you can
run `charm` to view the available subcommands and all subcommands have
independent help pages, accessible using either the `-h` or `--help` flags.

^# add

      charm add [-h] [--description] [-b] [--debug] {tests,readme,icon}

  Add is a generator function which can be used to extend a charm depending on
  the subcommand issued:

  ### icon

  `icon` will create an `icon.svg` in the `CHARM_DIRECTORY`. This icon is
  a template and should be customised by the charm author (see
  [Charm Icons documentation](authors-charm-icon.html)).

  ### readme

  `readme` will create a `README.ex` in the `CHARM_DIRECTORY` from the template
  charm.

  ### tests

  `tests` will create a tests directory for a charm and generate an example test
  using the Amulet framework. This command will ingest relation data from the
  charm `metadata.yaml` and create test file, `00-autogen`, based on matching
  charms to the interfaces listed. This is merely an example to start with and
  will need to be modified.

^# attach

      charm attach [options] <charm id> <resource=<file>

  The attach command uploads a file as a new resource for a charm.

      charm attach ~james/xenial/wordpress website-data ./foo.zip

^# create


      charm create [-h] [-t TEMPLATE] [-a] [-v] <charmname> [charmhome]

  The `create` command will produce a new boilerplate charm. Replace `<charmname>`
  with the name of your new charm. A directory called `<charmname>` will be created
  in the `[charmhome]` directory, or your current directory if no `[charmhome]`
  directory is provided.

  By default, your new charm is created using the python template. Use the
  `-t TEMPLATE` option to create a charm using a different template, e.g.:

      charm create -t bash my-charm

  To see the list of installed templates use `charm create -h`.

  Depending on the template being used, `harm create` may prompt for
  user input. To suppress prompts and accept all defaults instead, use the
  `-a` or `--accept-defaults` option.

  ### Create Options

    - `-h`, `--help`: Show help.
    - `-t`, `--template`: The template to use when creating the charm.
    - `-a`, `--accept-defaults`: If the chosen template prompts for user
      input, suppress all prompts and accept the defaults instead.
    - `-v`, `--verbose`: Show debug output.

  ### Bash Example

      charm create -t bash my-charm

  will create the following charm structure:

        my-charm
        ├── config.yaml
        ├── hooks
        │   ├── config-changed
        │   ├── install
        │   ├── relation-name-relation-broken
        │   ├── relation-name-relation-changed
        │   ├── relation-name-relation-departed
        │   ├── relation-name-relation-joined
        │   ├── start
        │   ├── stop
        │   └── upgrade-charm
        ├── icon.svg
        ├── metadata.yaml
        ├── README.ex
        └── revision


  ### Python Example

      charm create -t python-basic my-charm

  will create the following structure:

        my-charm/
        ├── charm-helpers.yaml
        ├── config.yaml
        ├── hooks
            │   ├── config-changed
            │   ├── install
            │   ├── start
            │   ├── stop
            │   └── upgrade-charm
            ├── icon.svg
            ├── lib
            │   └── charmhelpers
            │       ├── core
            │       │   ├── decorators.py
            │       │   ├── files.py
            │       │   ├── fstab.py
            │       │   ├── hookenv.py
            │       │   ├── host.py
            │       │   ├── hugepage.py
            │       │   ├── __init__.py
            │       │   ├── kernel.py
            │       │   ├── services
            │       │   │   ├── base.py
            │       │   │   ├── helpers.py
            │       │   │   └── __init__.py
            │       │   ├── strutils.py
            │       │   ├── sysctl.py
            │       │   ├── templating.py
            │       │   └── unitdata.py
            │       └── __init__.py
            ├── metadata.yaml
            ├── README.ex
            ├── revision
            ├── scripts
            │   └── charm_helpers_sync.py
            └── tests
                ├── 00-setup
                └── 10-deploy

^# grant

      grant [options] <charm or bundle id> [--channel <channel>] [--acl (read|write)] [--set] [,,...]

  Grant charm or bundle permissions in the Charm Store. When charms are pushed
  they default to only being shown to you, in order for other people to see
  your charm, you need to explicitly grant them permissions.

  The grant command extends permissions for the given charm or bundle to the
  given users.

      charm grant ~kirk/wordpress james

  The command accepts many users (comma-separated list) or everyone.

  The `--acl` parameter accepts "read" and "write" values. By default "read"
  permissions are granted.

      charm grant ~kirk/wordpress --acl write james

  The `--set` parameters is used to overwrite any existing ACLs for the charm or
  bundle.

      charm grant ~kirk/wordpress --acl write --set james,robert

  To select a channel, use the `--channel` option, for instance:

      charm grant ~kirk/wordpress --channel development --acl write --set james,robert

^# help

      charm help [topic]

  show help on a command or other topic. Running `charm` with no arguments will
  also show topics.

^# layers

      charm-layers [-h] [-r] [-l LOG_LEVEL] [--description] [charm]

  Inspect the layers of a built charm. The output is color coded. Each of the
  results in the layers section is assigned a unique color that corresponds to
  each file that is part of that layer.

^# list
      charm list [-h|--help] [-u <username>]

  list charms for a given user name.

      charm list -u lars

  When no arguments are given it returns a list of charms that the currently
  logged in user has pushed.

       charm list

^# list-resources

      charm list-resources [options] <charm>

  This command will report the resources for a charm in the charm store.

  <charm> can be a charm URL, or an unambiguously condensed form of
  it. So the following forms will be accepted:

      charm list-resources cs:xenial/mysql
      charm list-respirces mysql
      charm list-resources trusty/mysql

      charm list-resources cs:~kirk/xenial/mysql
      charm list-resources cs:~kirk/mysql

  Where the series is not supplied, the series from your local host is used.
  Thus the above examples imply that the local series is trusty.

^# login

  The login command uses Ubuntu SSO to obtain security credentials for the charm
  store. Note that the charm command will prompt you if you need to login to the
  store before any operation that requires authentication, so you don't usually
  need to run this command stand-alone.

^# logout

  The logout command removes all security credentials for the charm store.

^# proof

      charm proof CHARM_DIRECTORY

  Proof is designed to perform a "lint" against a charm or bundle's structure
  to validate if it conforms to what the Charm Store will accept. `proof` will
  provide output at varying levels of severity. `I` is informational - these
  are things a charm could do but don't currently. `W` is a warning - these are
  items that violate charm store policy or have an adverse affect on tools in
  the juju ecosystem. `E` is an error - these are items that are major and will
  result in a broken charm. Any charm with a Warning or Error will not pass
  charm store review policy. The charm store itself will not accept a push that
  has an error.

^# publish

      charm publish [options] <charm or bundle id> [--channel <channel>]

  The publish command publishes a charm or bundle in the charm store.
  Publishing is the action of assigning one channel to a specific charm
  or bundle revision (revision need to be specified), so that it can be shared
  with other users and also referenced without specifying the revision.

  Two channels are supported: "stable" and "development"; the "stable" channel is
  used by default.

      charm publish ~lars/xenial/wordpress

  To select another channel, use the `--channel` option, for instance:

      charm publish ~lars/xenial/wordpress --channel stable
      charm publish xenial/django-42 -c development --resource website-3 --resource data-2

  If your charm uses resources, you must specify what revision of each resource
  will be published along with the charm, using the --resource flag (one per
  resource). Note that resource info is embedded in bundles, so you cannot use
  this flag with bundles.

      charm publish xenial/django-42 --resource website-3 --resource data-2

^# pull

      charm pull [options] <charm or bundle id> [--channel <channel>] [<directory>]

  If you want to grab one of the charm store charms or bundles, use the `get`
  command specifying the `CHARM_NAME` you want to copy and provide an optional
  `CHARMS_DIRECTORY`. Otherwise the current directory will be used

  For example:

      charm pull mysql

  Will download the MySQL charm to a mysql directory within your current path.

      charm pull wordpress ~/charms/

  Will download the WordPress charm to `~/charms/wordpress`

      charm pull trusty/wordpress

  Will fetch the trusty version of the wordpress charm into the directory
  "wordpress" in the current directory.

  To select a channel, use the `--channel` option, for instance:

      charm pull wordpress --channel development

  Note that `charm pull` only pulls down a copy of the charm that is in the
  store, it should not be used when you want to hack on a charm, for that you
  should use `charm pull-source`.


^# pull-source

      charm pull-source [-h] [-v] [--description] item [dir]

  Download the source code for a charm, layer, or interface.

  The item to download can be specified using any of the following forms:

   - [cs:]charm
   - [cs:]series/charm
   - [cs:]~user/charm
   - [cs:]~user/series/charm
   - layer:layer-name
   - interface:interface-name

  If the item is a layered charm, and the top layer of the charm has a repository
  key in `layer.yaml`, the top layer repository will be cloned. Otherwise, the charm
  archive will be downloaded and extracted from the charm store.

  If a download directory is not specified, the following environment vars
  will be used to determine the download location:

   - For charms, `$JUJU_REPOSITORY`
   - For layers, `$LAYER_PATH`
   - For interfaces, `$INTERFACE_PATH`

  If a download location can not be determined from environment variables,
  the current working directory will be used.

  The download is aborted if the destination directory already exists.

  positional arguments:
    item           Name of the charm, layer, or interface to download.
    dir            Directory in which to place the downloaded source.

^# push

      charm push [options] <directory> [<charm or bundle id>]

  The push command uploads a charm or bundle from the local directory
  to the charm store.

  The charm or bundle id must not specify a revision: the revision will be
  chosen by the charm store to be one more than any existing revision.
  If the id is not specified, the current logged-in charm store user name is
  used, and the charm or bundle name is taken from the provided directory name.

  The pushed charm or bundle is unpublished and therefore usually only available
  to a restricted set of users. See the publish command for info on how to make
  charms and bundles available to others.

      	charm push .
      	charm push /path/to/wordpress wordpress
      	charm push . cs:~lars/trusty/wordpress

  Resources may be uploaded at the same time by specifying the --resource flag.
  Following the resource flag should be a name=filepath pair.  This flag may be
  repeated more than once to upload more than one resource.

        charm push . --resource website=~/some/file.tgz --resource config=./docs/cfg.xml

^# revoke

      charm revoke [options] <charm or bundle id> [--channel <channel>] [--acl (read|write)] [,,...]

  The revoke command restricts permissions for the given charm or bundle to the
  given users.

      charm revoke ~kirk/wordpress james

  The command accepts many users (comma-separated list) or everyone.

  The `--acl` parameter accepts "read" and "write" values. By default all
  permissions are revoked.

      charm revoke ~kirk/wordpress --acl write james

  To select a channel, use the `--channel` option, for instance:

      charm revoke ~kirk/wordpress --channel development --acl write james,robert

^# set

      charm set [options] <charm or bundle id> [--channel <channel>] name=value [name=value]

  The set command updates the extra-info, home page or bugs URL for the given charm or
  bundle.

      charm set wordpress bugs-url=https://bugspageforwordpress.none
      charm set wordpress homepage=https://homepageforwordpress.none

  The separator used when passing key/value pairs determines the type:
  "=" for string fields, ":=" for non-string JSON data fields. Some
  fields are forced to string and cannot be arbitrary JSON.

  To select a channel, use the `--channel` option, for instance:

      charm set wordpress someinfo=somevalue --channel development

^# show

      charm show [options] <charm or bundle id> [--channel <channel>] [--list] [field1 ...]

  The show command prints information about a charm
  or bundle. By default, all known metadata is printed.

      charm show trusty/wordpress

  To select a channel, use the `--channel` option, for instance:

      charm show wordpress --channel development

  To specify one or more specific metadatas:

      charm show wordpress charm-metadata charm-config

  To get a list of metadata available:

      charm show --list

^# terms

      charm terms [options]

  Charms can require users to accept terms before deployment. This is useful for
  software that needs a EULA. The terms command lists the terms owned by this
  user and the charms that require these terms to be agreed to.

^# test

      charm test [-h] [--description] [--timeout TIMEOUT] [--isolate JUJU_ENV]
                       [-o LOGDIR] [--setup-timeout SETUP_TIMEOUT] [--fail-on-skip]
                       [--on-timeout {fail,skip,pass}] [--set-e] [-v] [-q]
                       [-p PRESERVE_ENVIRONMENT_VARIABLES] [-e JUJU_ENV]
                       [--upload-tools] [--constraints CONSTRAINTS]
                       [TEST [TEST ...]]

  Executes charm functional tests. It should always be run from inside the
  charm's directory.

  Given the following example charm layout:
  .
  ├── config.yaml
  ├── copyright
  ├── hooks
  │   └── ...
  ├── icon.svg
  ├── metadata.yaml
  ├── README.md
  └── tests
      ├── 00-tool_setup
      ├── 01-standard
      ├── 02-at_scale
      └── 03-different_database

  Run all tests for current charm

      charm test

  Run one or more tests

    charm test 01-standard 03-different_database

  output:

  Each unit test will return an output in the form or either:

        RESULT   : SYM

      or

      RESULT   : SYM (SYM)

  Where SYM is a Symbol representing PASS: ✔, FAIL: ✘, SKIP: ↷, or TIMEOUT: ⌛
  In the event a status is rewritten by either the `--fail-on-skip` flag or the
  `--on-timeout` flag the original status will be displayed in () next to the
  computed status.

^# version

      charm version

  Display tooling versioning information.

^# whoami

      charm-version [-h] [--description] [-b] [--debug]

  The whoami command prints the current jaas user name and list of groups
  of which the user is a member.
