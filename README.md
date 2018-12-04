# Documentation for Juju

JUJU DOCUMENTATION WILL SOON BE MOVING TO DISCOURSE:

https://discourse.jujucharms.com

RENDERING THESE INSTRUCTIONS OBSOLETE.

-----

The documentation is written in Markdown, and then generated into HTML.

The latest version of these docs live at:

- [github.com/juju/docs](https://github.com/juju/docs)
- [docs.jujucharms.com](http://docs.jujucharms.com) - Rendered docs

For advice on contributing to the docs see the
[contributing.html](https://docs.jujucharms.com/stable/contributing.html) page
in this project. This has important information on style, the use of Markdown
and other useful tips.

## Important files and directories

The following files and directories under `src/en` are of interest:

 - The `metadata.yaml` file is used to build the navigation for the website.
   You won't need to change this unless you are adding a new page (and even
   then, please ask about where it should go).

 - The `build` directory is where local builds of the docs are made.

   Do not _replace_ graphics unless you know what you are doing. These image
   files are used by all versions of the docs, so usually you will want to add
   files rather than change existing ones, unless the changes apply to all
   versions of Juju (e.g. website images).

 - The `versions` file contains a list of Github branches which represent the
   current supported versions of documentation. Many tools rely on this list,
   it should not be changed by anyone but the docs team!

 - The `archive` file contains a list of Github branches which contain
   unmaintained, older versions of documentation.

## Building the documentation

Every non-trivial contribution must first have its HTML built and verified
before a pull request (PR) is made from it.

See the [documentation-builder project][github-documentation-builder] for
details of the actual tool.

### Installation

Install the builder. On Ubuntu 16.04 LTS (or greater):

```bash
sudo snap install documentation-builder
```

!!! Note:
    You will first need to install package `squashfuse` if you're doing this in
    a LXD container.

### Build

To build the HTML, while in the root of the docs repository:

```bash
documentation-builder --source-folder src --media-path src/en/media
```

### Verification

You can point a web browser at individual HTML files but to make your
verification more conclusive you will need a web server.

See the [Ubuntu Server Guide][ubuntu-serverguide-apache] for instructions on
setting up Apache. The DocumentRoot should be the `src/build/en` directory. To
test, point your browser at:

```no-highlight
http://127.0.0.1/
```

Alternatively, you can use Python to start a simple HTTP server (port 8000).
While in the `src/build/en` directory run:

```bash
python3 -m http.server
```

To test, point your browser at:

```no-highlight
http://0.0.0.0:8000/
```

#### Points to consider

Some things to consider during verification:

 - A linkchecker (either a system-wide tool or a
   [browser add-on][browser-linkchecker-addon])
 - Images should show enough context (surrounding real estate) but not so much
   to make important details illegible.

## Workflow

1. Get a Github account: [https://github.com/join](https://github.com/join)
2. Fork the [juju/docs](https://github.com/juju/docs) Github repository. This 
 creates your own version of the repository (which you can then find online at
 `https://github.com/{yourusername}/docs`)
3. Create a local copy:

        git clone https://github.com/{yourusername}/docs 
        cd docs

4. Add a git `remote` to your local repository. This links it with the 'upstream' 
   version of the documentation, which makes it easier to update your fork and 
   local version of the docs:

        git remote add upstream https://github.com/juju/docs

5. Create a 'feature branch' to add your content/changes

        git checkout -b {branchname}

6. Edit files and make changes in this branch. You can use the command:
       
        git status

   to check which files you have added or edited. For each of these you will
   need to explicitly add the files to the repository. For example:

        git add src/en/about-juju.md
  
  If you wish to move or rename files you need to use the `git mv` command, and 
  the `git rm` command to delete them 

7. To 'save' your changes locally, you should make a commit:

        git commit -m 'my commit message which says something useful'

7. View your changes to make sure they render properly. See previous section 
   [Building the docs][#building-the-docs] for how to build a local version of
   the docs.

8. Push the branch back to **your** fork on Github

        git push origin {branchName}

   Do not be alarmed if you are asked for your username/password, it is part of
   the authentication, though you can make things easier by any of:
    
    - [configuring git](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) properly
    - using an [authentication token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/)
    - caching your [password] (https://help.github.com/articles/caching-your-github-password-in-git/)

9. Create a pull request. This is easily done in the web interface of Github:
   navigate to your branch on the web interface and hit the compare button -
   this will allow you to compare across forks to the juju/docs master branch,
   which is where your changes will hopefully end up. The comparison will show
   you a diff of the changes  - it is useful to look over this to avoid
   mistakes. Then click on the button to Create a pull request. Add any useful
   info about the changes in the comments (e.g. if it fixes an issue you can
   refer to it by number to automatically link your pull request to the issue)

10. A Documentation team member will review your PR, suggest improvements, and
    eventually merge it with the appropriate branch (series). Publication to
    the website is a separate step (performed internally), so it can be a few
    days before the changes actually show up.

    If there are changes to be made:

    - make the changes in your local branch
    - use `git commit -m 'some message' ` to commit the new changes
    - push the branch to your fork again with `git push origin {branchname}`
    - there is no need to update the pull request, it will be done
      automatically

Once the code has been landed you can remove your feature branch from both the
remote and your local fork. Github provides a button for this at the bottom of
the pull request, or you can use `git` to remove the branch. 

Before creating another feature branch, make sure you update your fork's code
by pulling from the original Juju repository (see below).

## Keeping your fork in sync with Juju docs upstream

You should now have both the upstream branch and your fork listed in git, 
`git remote -v` should return something like:

        upstream   https://github.com/juju/docs.git (fetch)
        upstream   https://github.com/juju/docs.git (push)
        origin     https://github.com/your-github-id/docs (fetch)
        origin     https://github.com/your-github-id/docs (push)

To fetch and merge with the upstream branch:

        git checkout master
        git fetch upstream
        git merge --ff-only upstream/master
        git push origin master


<!-- LINKS -->

[#building-the-docs]: #building-the-docs
[github-documentation-builder]: https://github.com/CanonicalLtd/documentation-builder
[ubuntu-serverguide-apache]: https://help.ubuntu.com/lts/serverguide/httpd.html
[browser-linkchecker-addon]: https://chrome.google.com/webstore/detail/check-my-links/ojkcdipcgfaekbeaelaapakgnjflfglf
