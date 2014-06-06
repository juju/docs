# Introduction

Charm tools is a collection of tools designed as a Juju Plugin. Charm tools
offer a means for users and charm authors to create, search, fetch, update, and
manage a charms.

# Installation


## Ubuntu
To install the latest Charm Tools, you simply need to grab the latest charm-
tools package from this PPA:

    sudo add-apt-repository ppa:juju/stable
    sudo apt-get update && sudo apt-get install charm-tools

## Mac OSX
Charm Tools is available via [Homebrew](http://brew.sh/). Make sure you're
running the latest version of homebrew before proceeding.

To install, run the following:

    brew install charm-tools

## Windows
Charm Tools is available for, and tested, on Microsoft Windows 7 and 8. While
the installer may work on previous versions of Windows there is no guarentee.

To install, first download the Charm Tools installer from
[launchpad](https://launchpad.net/charm-tools/1.2/1.2.9/+download/charm-
tools_1.2.9.exe). Once downloaded, execute the installer and follow the on-
screen prompts. After installation you can access Charm Tools either via the
`charm` command or `juju charm` plugin from either the command line or
powershell.

To uninstall, please remove Charm Tools from the Add/Remove Software section of
the Windows Control Panel

# Usage

Charm Tools comes packaged as both a stand alone tool and a juju plugin. For the
sake of documentation purposes, the plugin syntax, `juju charm`, is shown. If
you wish to use the stand alone client, or don't have juju installed, you can
replace all instances of `juju charm` with just `charm`.

There are several tools available within charm tools itself. At any time you can
run `juju charm` to view the available subcommands and all subcommands have
independent help pages, accesible using either the `-h` or `--help` flags.

## Add

    juju charm add [-h|--help] tests,readme [CHARM_DIRECTORY]

Add is a generator function which can be used to extend a charm depending on the
subcommand issued.

### Readme

`readme` will create a `README.ex` in the `CHARM_DIRECTORY` from the template
charm.

#### Add Readme Example

    juju charm add readme

### Tests

`tests` will create a tests directory for a charm and generate an example test
using the Amulet framework. This command will ingest relation data from the
charm `metadata.yaml` and create test file, `00-autogen`, based on matching
charms to the interfaces listed. This is merely an example to start with and
will need to be modified.

#### Add Tests Example

    juju charm add tests

* * *

## Create

    juju charm create [-h|--help] CHARM_NAME [CHARMS_DIRECTORY]

This command, `create`, will produce a boilerplate template of a charm to
expedite the charm creation process. Replace `CHARM_NAME` with the name you want
the new charm to be. A directory called `CHARM_NAME` will be created in the
`[CHARMS_DIRECTORY]`, or your current directory if no `[CHARMS_DIRECTORY]` is
provided.

### Create Example

Below is an example of the charm structure created during `juju charm create`

    juju charm create my-charm
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

* * *

## Get

    juju charm get [-h|--help] CHARM_NAME [CHARMS_DIRECTORY]

If you want to branch one of the charm store charms, use the `get` command
specifying the `CHARM_NAME` you want to copy and provide an optional
`CHARMS_DIRECTORY`. Otherwise the current directory will be used

### Get Example

    juju charm get mysql

Will download the MySQL charm to a mysql directory within your current path.

    juju charm get wordpress ~/charms/precise/

Will download the WordPress charm to `~/charms/precise/wordpress`

* * *

## Getall

    juju charm getall [-h|--help] [CHARMS_DIRECTORY]

Similar to `get`, `getall` will fetch all official charm store charms and place
them in the `CHARMS_DIRECTORY`, or your current directory if no
`CHARMS_DIRECTORY` is provided. This command can take quite a while to complete
- there are a lot of charms!

* * *

## Info

    juju charm info [-h|--help] [CHARM]

Info is used to query the README file for a charm. This command accepts various
forms of a valid "charm id". Any ID that can be used to deploy a charm with
`juju deploy`, with the exception of `local:`, can be used with this command.

### Info Example

This will print the raw README for the WordPress charm

    juju charm info wordpress

## List

    juju charm list [-h|--help]

Show all charms (both official and person) in the charm store. This produces an
exhaustive list of all charms available in the store.

## Promulgate

    juju charm promulgate [-h|--help] [-b|--branch] [-s|--series] [-v|--verbose] [-u|--unpromulgate] [-f|--force] [-w|--ignore-warnings] [-o|--owner-branch] CHARM_DIRECTORY

Promulgate is used to promote a charm to the charm store. This command is only
available to users in the ~charmers group and is meant to be run only after a
charm passes the review process. `CHARM_DIRECTORY` is the path to the charm to
be promulgated. When promulgating `proof` is run and unless otherwise forced,
will prevent promulgation if errors occur.

### Promulgate Options

  - `-b`, `--branch`: The location of the charm public branch. Will be determined from the bzr configuration if omitted.
  - `-s`, `--series`: The distribution series on which to set the official branch. Defaults to setting it in the current development series (LTS).
  - `-v`, `--verbose`: Increase verbosity level.
  - `-u`, `--unpromulgate`: Un-promulgate this branch instead of prolugating it.
  - `-f`, `--force`: Override warnings and errors. USE WITH EXTREME CARE!
  - `-w`, `--ignore-warnings`: Promulgate this branch even with warnings from charm proof.
  - `-o`, `--owner-branch`: Promulgate a branch owned by a someone/group other than ~charmers.

## Proof

    juju charm proof CHARM_DIRECTORY

Proof is designed to perform a "lint" against a charms structure to validate if
it conforms to what the Charm Store thinks a charm structure and layout should
be. `proof` will provide output at varying levels of severtiy. `I` is
informational. These are things a charm could do but don't currently. `W` is a
warning. These are things that aren't complete blockers but need to be
addressed. `E` is an error. These are items that are major and need to be
addressed.

## Review-queue

    juju charm review-queue [-h|--help]

This provides a copy of the [juju charms review
queue](http://manage.jujucharms.com/review-queue) which is used by ~charmers to
know which charms are available for review.

* * *

## Search

    juju charm search [-h|--help]

This provides a copy of the [juju charms review
queue](http://manage.jujucharms.com/review-queue) which is used by ~charmers to
know which charms are available for review.

* * *

## unpromulgate

    juju charm unpromulgate [-h|--help] [-f|--force]

This is simply a convience method to running `juju charm promulgate
--unpromulgate`.

## update

    juju charm update [-h|--help] [-f|--fix] [CHARMS_DIRECTORY]

Update is used for `CHARMS_DIRECTORY`, when `CHARMS_DIRECTORY` is a repository
created via `getall`
