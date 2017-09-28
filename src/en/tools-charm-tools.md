Title: Charm Tools

The 'Charm Tools' Juju Plugin is a collection of commands enabling users
and charm authors to create, search, fetch, update, and
manage charms.

# Installation

The source project can be found at 
[https://launchpad.net/charm-tools](https://launchpad.net/charm-tools).

## Ubuntu

Install the Charm Tools via a snap.

On Ubuntu 14.04 LTS (Trusty) `snapd` is not installed by default. You can
install it in this way:

```bash
sudo apt install snapd
```

Now install the tools via the `charm` snap:

```bash
sudo snap install charm
```

### Issues

These are some possible issues you might be confronted with on Ubuntu 14.04
LTS when you try to invoke the `charm` command.

Log out of your Ubuntu user session (and log back in) if you see the following:

```no-highlight
The program 'charm' is currently not installed. You can install it by typing:
sudo apt-get install charm-tools
```

Reboot your computer if you get the below error:

```no-highlight
cannot perform readlinkat() on the mount namespace file descriptor of the init
process: Permission denied
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
`charm` command or `juju charm` plugin from either the command line or
powershell.

To uninstall, please remove Charm Tools from the Add/Remove Software section of
the Windows Control Panel

# Usage

All the functionality provided by the Charm Tools is accessed via the `charm`
command and a sub-command argument. Omitting the argument will give a listing
of all sub-commands. To view an individual help page for each sub-command run
`charm help <sub-command>`.

Click the triangle to reveal a summary of a sub-command.

^# add

      juju charm add [-h|--help] tests,readme,icon [CHARM_DIRECTORY]

  Extends a charm depending on the options chosen:

  #### tests

  `icon` will create an `icon.svg` in the `CHARM_DIRECTORY`. This icon is
  a template and should be customised by the charm author (see 
  [Charm Icons documentation](authors-charm-icon.html)).

  #### readme

  `readme` will create a `README.ex` in the `CHARM_DIRECTORY` from the template
  charm.

  #### icon

  `icon` will create an `icon.svg` in the `CHARM_DIRECTORY`. This icon is
  a template and should be customised by the charm author (see
  [Charm Icons documentation](authors-charm-icon.html)).


^# attach

      charm attach [options] <charm id> <resource=<file>

  Uploads a file as a new resource for a charm.

      charm attach ~user/trusty/wordpress-0 website-data=./foo.zip

  A revision number is only required when using the stable channel, which is
  the default channel.

      charm attach ~user/mycharm mydata=./blah -c unpublished


^# build

      charm build [-h] [-l LOG_LEVEL] [-f] [-o OUTPUT_DIR] [-s SERIES]
	    [--hide-metrics] [--interface-service INTERFACE_SERVICE]
       	    [--no-local-layers] [-n NAME] [-r] [--description]
       	    [charm]

  Builds a charm from layers and interfaces.


^# create

      charm create [-h] [-t TEMPLATE] [-a] [-v] [--description] charmname [charmhome]

  Creates a new charm.

  The will produce a new boilerplate charm. Replace `<charmname>` with the
  name of your new charm. A directory called `<charmname>`, and any necessary
  sub-directories and files, will be created in the `[charmhome]` directory, or
  your current directory if no `[charmhome]` directory is provided.

  By default, your new charm is created using the python template. Use the
  `-t TEMPLATE` option to create a charm using a different template, e.g.:

      charm create -t bash my-charm

  To see the list of installed templates use `charm create -h`.

  Depending on the template being used, `charm create` may prompt for
  user input. To suppress prompts and accept all defaults instead, use the
  `-a` or `--accept-defaults` option.

  ### Create Options

    - `-h`, `--help`: Show help.
    - `-t`, `--template`: The template to use when creating the charm.
    - `-a`, `--accept-defaults`: If the chosen template prompts for user
      input, suppress all prompts and accept the defaults instead.
    - `-v`, `--verbose`: Show debug output.

  ### Bash Example
 
      juju charm create -t bash my-charm
 
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

      juju charm create -t python my-charm

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
        │       │   ├── fstab.py
        │       │   ├── hookenv.py
        │       │   ├── host.py
        │       │   └── __init__.py
        │       └── __init__.py
        ├── metadata.yaml
        ├── README.ex
        ├── revision
        ├── scripts
        │   └── charm_helpers_sync.py
        └── tests
            ├── 00-setup
            └── 10-deploy



^# get

      juju charm get [-h|--help] CHARM_NAME [CHARMS_DIRECTORY]

  If you want to branch one of the charm store charms, use the `get` command
  specifying the `CHARM_NAME` you want to copy and provide an optional
  `CHARMS_DIRECTORY`. Otherwise the current directory will be used
=======

^# grant

      charm grant [options] <charm or bundle id> [--channel <channel>] [--acl (read|write)] [--set] [,,...]

  Extends permissions for the given charm or bundle to the given users.

      charm grant ~johndoe/wordpress fred

  The command accepts many users (comma-separated list) or everyone.

  The --acl parameter accepts "read" and "write" values. By default "read"
  permissions are granted:

      charm grant ~johndoe/wordpress --acl write fred

  The --set parameter is used to overwrite any existing ACLs:

      charm grant ~johndoe/wordpress --acl write --set fred,bob

  To select a channel, use the --channel option:

      charm grant ~johndoe/wordpress --channel stable --acl write --set fred,bob


^# help

      charm help [command]

  Shows help on a command.

  Running just `charm` (with no arguments) will display the list of available
  commands.


^# layers

      charm layers [-h] [-r] [-l LOG_LEVEL] [--description] [charm]

  Inspects the layers of a built charm.


^# list

      charm list [options]

  Lists the charms under a given user name, by default yours.

      charm list -u lars

  When no arguments are given it returns a list of charms that the currently
  logged in user has pushed.

      charm list


^# list-resources

      charm list-resources [options] <charm>

  Displays the resources for a charm in the Charm Store.

  The charm can be expressed as a charm URL, or an unambiguously condensed form
  of it. So the following forms will be accepted:

  For cs:trusty/mysql :  
    mysql  
    trusty/mysql  
  
  For cs:~user/trusty/mysql :  
    cs:~user/mysql
  
  When the series is not supplied, the series from your local host is used.
  Thus the above examples imply that the local series is trusty.


^# login

      charm login

  Logs the user in to the Charm Store using Ubuntu SSO.


^# logout

      charm logout

  Logs the user out of the Charm Store.


^# pull-source

      charm pull-source [-h] [-v] [--description] item [dir]

  Downloads the source code for a charm, layer, or interface.
  
  The item to download can be specified using any of the following forms:
  
  - [cs:]charm
  - [cs:]series/charm
  - [cs:]~user/charm
  - [cs:]~user/series/charm
  - layer:layer-name
  - interface:interface-name
  
  If the item is a layered charm, and the top layer of the charm has a repo
  key in layer.yaml, the top layer repo will be cloned. Otherwise, the charm
  archive will be downloaded and extracted from the charm store.
  
  If a download directory is not specified, the following environment variables
  will be used to determine the download location:
  
  - For charms, $JUJU_REPOSITORY
  - For layers, $LAYER_PATH
  - For interfaces, $INTERFACE_PATH
  
  If a download location can not be determined from environment variables, the
  current working directory will be used.
  
  The download is aborted if the destination directory already exists.
>>>>>>> 880043fb... update charm tools usage


<<<<<<< HEAD
      juju charm get mysql

  Will download the MySQL charm to a mysql directory within your current path.

      juju charm get wordpress ~/charms/precise/


  Will download the WordPress charm to `~/charms/precise/wordpress`


^# getall

      juju charm getall [-h|--help] [CHARMS_DIRECTORY]
=======
^# proof

      charm proof [-h] [--description] [-b] [--debug] [charm_name]

  Performs static analysis on a charm or bundle.


^# release

      charm release [options] <charm or bundle id> [--channel <channel>]

  Publishes a charm or bundle to the charm store. Releasing is the action of
  assigning one channel to a specific charm or bundle revision (revision needs
  to be specified), so that it can be shared with other users and also referenced
  without specifying the revision. Four channels are supported, in order of
  stability: "stable", "candidate", "beta", and "edge"; the "stable" channel is
  the default.

      charm release ~bob/trusty/wordpress

  To select another channel, use the --channel option:

      charm release ~bob/trusty/wordpress --channel beta
      charm release wily/django-42 -c edge --resource website-3 --resource data-2

  If your charm uses resources, you must specify what revision of each resource
  will be published along with the charm, using the --resource flag (one per
  resource). Note that resource info is embedded in bundles, so you cannot use
  this flag with bundles.

      charm release wily/django-42 --resource website-3 --resource data-2


^# pull

      charm pull [options] <charm or bundle id> [--channel <channel>] [<directory>]

  Downloads a copy of a charm or bundle from the charm store into a local
  directory. If the directory is unspecified, the directory will be named after
  the charm or bundle.

  To download the wordpress charm into directory 'wordpress' in the current directory:

      charm pull trusty/wordpress

  To select a channel, use the --channel option:

      charm pull wordpress --channel edge

>>>>>>> 880043fb... update charm tools usage

  Similar to `get`, `getall` will fetch all official charm store charms and place
  them in the `CHARMS_DIRECTORY`, or your current directory if no
  `CHARMS_DIRECTORY` is provided. This command can take quite a while to complete
  - there are a lot of charms!


<<<<<<< HEAD
^# info
=======
  Uploads a charm or bundle from the local directory to the charm store.
>>>>>>> 880043fb... update charm tools usage

      juju charm info [-h|--help] CHARM

  Info is used to query the README file for a charm. This command accepts various
  forms of a valid "charm id". Any ID that can be used to deploy a charm with
  `juju deploy`, with the exception of `local:`, can be used with this command.

<<<<<<< HEAD
  For example, this will print the raw README for the WordPress charm:
=======
      charm push .
      charm push /path/to/wordpress wordpress
      charm push . cs:~lars/trusty/wordpress
>>>>>>> 880043fb... update charm tools usage

      juju charm info wordpress

<<<<<<< HEAD

^# list
 
      juju charm list [-h|--help]
=======
      charm push . --resource website=~/some/file.tgz --resource config=./docs/cfg.xml


^# push-term

      charm push-term [options] <filename> <term id>

  Creates a new Terms and Conditions document (revision).

  For example, to create a new terms document with the content from file
  `text.txt` and the name 'enterprise-plan' and returns the revision of the
  created document:

      charm push-term text.txt user/enterprise-plan


^# release-term

      charm release-term [options] <term id>

  Releases the given terms document. For instance:

      charm release-term me/my-terms


^# revoke

      charm revoke [options] <charm or bundle id> [--channel <channel>] [--acl (read|write)] [,,...]

  Restricts permissions for the given charm or bundle to the given users.

      charm revoke ~kirk/wordpress james

  The command accepts many users (comma-separated list) or everyone.

  The `--acl` parameter accepts "read" and "write" values. By default all
  permissions are revoked.

      charm revoke ~kirk/wordpress --acl write james

  To select a channel, use the `--channel` option, for instance:

      charm revoke ~kirk/wordpress --channel beta --acl write james,robert


^# set

      charm set [options] <charm or bundle id> [--channel <channel>] name=value [name=value]

  Updates the extra-info, home page or bugs URL for the given charm or bundle.

      charm set wordpress bugs-url=https://bugspageforwordpress.none
      charm set wordpress homepage=https://homepageforwordpress.none

  The separator used when passing key/value pairs determines the type:
  "=" for string fields, ":=" for non-string JSON data fields. Some
  fields are forced to string and cannot be arbitrary JSON.

  To select a channel, use the `--channel` option, for instance:

      charm set wordpress someinfo=somevalue --channel edge


^# show

      charm show [options] <charm or bundle id> [--channel <channel>] [--list] [field1 ...]

  Prints information about a charm or bundle. By default, only a summary is
  printed. You can specify --all to get all known metadata.

      charm show trusty/wordpress

  To select a channel, use the `--channel` option, for instance:

      charm show wordpress --channel edge

  To specify metadata for one or more specific channels:

      charm show wordpress charm-metadata charm-config --channel stable

  To get a list of available metadata types:
>>>>>>> 880043fb... update charm tools usage


<<<<<<< HEAD
  Show all charms (both official and personal) in the charm store. This produces
  an exhaustive list of all charms available in the store.

^# promulgate

 
      juju charm promulgate [-h|--help] [-b|--branch] [-s|--series] [-v|--verbose] [-u|--unpromulgate] [-f|--force] [-w|--ignore-warnings] [-o|--owner-branch] CHARM_DIRECTORY


  Promulgate is used to promote a charm to the charm store. This command is only
  available to users in the ~charmers group and is meant to be run only after a
  charm passes the review process. `CHARM_DIRECTORY` is the path to the charm to
  be promulgated. When promulgating `proof` is run and unless otherwise forced,
  will prevent promulgation if errors occur.

  ### Promulgate Options

    - `-b`, `--branch`: The location of the charm public branch. Will be
      determined from the bzr configuration if omitted.
    - `-s`, `--series`: The distribution series on which to set the official 
      branch. Defaults to setting it in the current development series (LTS).
    - `-v`, `--verbose`: Increase verbosity level.
    - `-u`, `--unpromulgate`: Un-promulgate this branch instead of promulgating
      it.
    - `-f`, `--force`: Override warnings and errors. USE WITH EXTREME CARE!
    - `-w`, `--ignore-warnings`: Promulgate this branch even with warnings from
      charm proof.
    - `-o`, `--owner-branch`: Promulgate a branch owned by a someone/group other
      than ~charmers.

^# proof

 
      juju charm proof CHARM_DIRECTORY
 
  Proof is designed to perform a "lint" against a charms structure to validate if
  it conforms to what the Charm Store thinks a charm structure and layout should
  be. `proof` will provide output at varying levels of severity. `I` is
  informational - these are things a charm could do but don't currently. `W` is a
  warning - these are items that violate charm store policy or have an adverse affect
  on tools in the juju ecosystem. `E` is an error - these are items that are major
  and will result in a broken charm. Any charm with a Warning or Error will not
  pass charm store review policy.

^# review-queue

      juju charm review-queue [-h|--help]

  This provides a copy of the
  [juju charms review queue](http://review.juju.solutions) which is used by 
  ~charmers to identify which charms are available for review.


^# search

      juju charm search [-h|--help] <text>


  This command will search the charm repository (including namespace charms) for 
  matching charms, and return a list showing their Launchpad identifier.
=======

^# show-term

      charm show-term [options] <term id>

  Shows the given terms document. For instance:

  To show revision 1 of the enterprise-plan terms:

      show-term enterprise-plan/1

  To show the latest revision of the enterprise plan terms:

      show-term enterprise-plan


^# terms

      charm terms [options]

  Lists the terms owned by the user and the charms that require these terms to
  be agreed to.

  Charms can require users to accept terms before deployment. This is useful
  for software that needs a EULA.

>>>>>>> 880043fb... update charm tools usage

  For example: 
 
      juju charm search kafka

<<<<<<< HEAD

  might return:
=======
      charm version [-h] [--description] [-b] [--debug]

  Displays tooling version information

>>>>>>> 880043fb... update charm tools usage

      lp:~arosales/charms/trusty/kafka/trunk
      lp:~bigdata-dev/charms/trusty/apache-kafka/trunk
      lp:~hazmat/charms/trusty/kafka/trunk
      lp:~merlijn-sebrechts/charms/precise/kafka/trunk
      lp:~samuel-cozannet/charms/trusty/kafka-twitter/trunk
      lp:~samuel-cozannet/charms/trusty/kafka/trunk
      lp:~vpalos/charms/bundles/kafka-storm/bundle
      lp:~vpalos/charms/trusty/kafka/trunk
      lp:~x3v947pl/charms/trusty/kafka-dh/trunk
 

<<<<<<< HEAD
^# unpromulgate

      juju charm unpromulgate [-h|--help] [-f|--force]
  This is simply a convenience method to running `juju charm promulgate
  --unpromulgate`.
=======
      charm whoami [options]

  Displays JAAS user id and group membership.
>>>>>>> 880043fb... update charm tools usage

^# update

 
      juju charm update [-h|--help] [-f|--fix] [CHARMS_DIRECTORY]
 

  Update is used for `CHARMS_DIRECTORY`, when `CHARMS_DIRECTORY` is a repository
  created via `getall`
