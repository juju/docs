# Documentation for Juju

The documentation is written in Markdown, and then generated into HTML.

The latest version of these docs live at:

- [github.com/juju/docs](https://juju.ubuntu.com/docs/contributing.html)
- [juju.ubuntu.com/docs](http://juju.ubuntu.com/docs) - Rendered docs, generated twice a day.

For advice on contributing to the docs (please!), see 
the [contributing.html](https://juju.ubuntu.com/docs/contributing.html) page in this project.

## Building the Docs

The tools directory contains a Python build script for 
adding the headers and footers when structural 
elements of the pages are altered. It is NOT
necessary to run the build tool for deployment of the
HTML, only if the headers and footers have been
changed. The [contributing section](https://juju.ubuntu.com/docs/contributing.html) contains more
information on this.

### If you want 'phaux live reload'

there is a make target to 'watch' the directory and only build the source files that have changed,
enabling you the doc editor, to simply refresh your browser to see your changes without re-building
the entire doc tree.

to gain this functionality you will need the `watchdog` python module, which is pip installable

    pip install watchdog
    make watch

# Typical Github workflow


Git allows you to work in a lot of different work flows. Here is one that
works well for our environment, if you are not already familiar with git.

To set up the environment, first fork the [juju/docs](https://github.com/juju/docs) github 
repository when you are logged into the github.com website. Once the fork is
complete, create a local copy and work on a feature branch.

    git clone git@github.com:{yourusername}/docs.git juju-docs
    cd juju-docs
    
Add a second remote to the upstream Juju repository your fork came from. This lets you use commands such as `git pull upstream master` to update a branch from the original trunk, as you'll see below.

    git remote add upstream https://github.com/juju/docs.git

Create a feature branch to work on:

    git checkout -b {featureBranchName}
    
Hacky hacky hacky on your docs. To push code for review, cleanup the commit history.

Optional: rebase your commit history into one or more meaningful commits.

    git rebase -i --autosquash

And push your feature branch up to your fork on Github.

    git push origin {featureBranchName}


In order to submit your code for review, you need to generate a pull request.
Go to your github repository and generate a pull request to the `juju:docs`
branch.

After review has been signed off on and the test run has updated the pull
request, a member of the `juju` organization can submit the branch for landing.

Once the code has been landed you can remove your feature branch from both the
remote and your local fork. Github provides a button to do so in the bottom of
the pull request, or you can use git to remove the branch. Removing from your
local fork is listed below.

    git push origin :{featureBranchName}

And to remove your local branch

    git branch -D {featureBranchName}

Before creating another feature branch, make sure you update your fork's code
by pulling from the original Juju repository.

    git checkout master
    git fetch upstream
    git merge --ff-only juju-docs-upstream/master

And start your second feature branch.

    git checkout -b {featureBranch2}

## Keeping your fork in sync with Juju docs upstream

You should now have both the upstream branch and your fork listed in git, `git remote -v` should return something like:

    upstream	https://github.com/juju/docs.git (fetch)
    upstream	https://github.com/juju/docs.git (push)
    origin	git@github.com:castrojo/docs (fetch)
    origin	git@github.com:castrojo/docs (push)

To fetch and merge with the upstream branch:

    git checkout master; git fetch upstream; git merge --ff-only juju-docs-upstream/master
    git push origin master

# Doc Build Workflow

This code is pulled into this branch in launchpad:

    https://code.launchpad.net/~charmers/juju-core/github-docs

The cron job that builds the docs once a day pulls from Launchpad, NOT this repository; if you are trying to fix something
quickly on the production site you need to click "Import Now" on that branch to grab the fresh code from here.

# Helpful Git tools and aliases

## Tools


[Git Remote Branch](https://github.com/webmat/git_remote_branch>) - A tool to simplify working
with remote branches (Detailed installation instructions are in their readme).

## Aliases


Git provides a mechanism for creating aliases for complex or multi-step
commands. These are located in your ``.gitconfig`` file under the
``[alias]`` section.

If you would like more details on Git aliases, You can find out more
information here: [How to add Git aliases](https://git.wiki.kernel.org/index.php/Aliases>)

Below are a few helpful aliases we'll refer to in other parts of the
documentation to make working with the Juju Docs easier.

    # Bring down the pull request number from the remote specified.
    # Note, the remote that the pull request is merging into may not be your
    # origin (your github fork).
    fetch-pr = "!f() { git fetch $1 refs/pull/$2/head:refs/remotes/pr/$2; }; f"

    # Make a branch that merges a pull request into the most recent version of the
    # trunk (the "juju" remote's develop branch). To do this, it also updates your
    # local develop branch with the newest code from trunk.
    # In the example below, "juju" is the name of your remote, "6" is the pull
    # request number, and "qa-sticky-headers" is whatever branch name you want
    # for the pull request.
    # git qa-pr juju 6 qa-sticky-headers
    qa-pr = "!sh -c 'git checkout develop; git pull $0 develop; git checkout -b $2; git fetch-pr $0 $1; git merge pr/$1'"
