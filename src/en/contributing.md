# Contributing to Juju documentation

Contributing to the Juju documentation is made easy by the format it's
written in:
[GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)
(or GFM). You will therefore find the source documents straightforward and
human-readable.

The GFM implementation used does not include "Username linking"
and "Emoji" since these [features](https://guides.github.com/features/mastering-markdown)
are GitHub specific. In addition to those removals, however, we've created
several new Markdown definitions to implement features required for the docs.
These definitions are outlined below.


## How to contribute

We love it when the community contributes to documentation. Here are the essential
steps:

- [Fork the repository](https://help.github.com/articles/fork-a-repo) from [github.com/juju/docs](http://github.com/juju/docs)
- Make a local branch from your fork (and enter that branch)
- Edit the source documents with your favourite text editor
- Push your branch back to your fork on GitHub
- [Submit a Pull Request](https://help.github.com/articles/creating-a-pull-request)

The source documents are located in the `src` directory. From there each
language is separated into its own directory by language code. For instance,
English is under `src/en`.

Here is a handy [Markdown reference](http://askubuntu.com/editing-help) to get
you started. Afterwards, do take a look at the main
[GFM site](https://help.github.com/articles/github-flavored-markdown).

Once submitted, someone from the docs team will review your work, suggest
improvements, and eventually merge it with the master branch. Don't forget to
review your work before submission!


## Sections

All the text is organised into sections. These are auto-generated, there is
nothing extra you need to do:

    # <h1> equivalent
    ## <h2> equivalent
    ### <h3> equivalent

## Code Blocks

To code block something indent each line with 4 whitespace characters.

## Inline code

Use a backtick to `inline commands and other literals`.

## Notes, Warnings, Callouts, Admonishments

Callouts are used to notify the user of additional information or warn them of
potential pitfalls. This will create a notification resembling the following in
the docs:

![callout](media/note.png)

To implement this callout, use the following syntax:

```
!!! Note: If you want to get more information on what is actually happening, or
to help resolve problems, you can add the `--show-log` switch to the juju
command to get verbose output.
```

## Foldouts

When a page contains a high volume of information that would otherwise require a
table of contents, or similar method of quick navigation, a foldout can be used.
This will create a collapsed header which, when clicked, will expand to display
all the content below it.

```
^# Header
  Content can be multi-paragraphed and will be sent through the Markdown parser

  as long as content is continually indented under the header.
```

# Adding pages

Adding a page (file) to the documentation requires the altering of
`src/navigation.tpl`. Doing so will insert an entry into the left navigation
pane which will allow a visitor to discover the new page.

Add the page with the following format:

    <li class="sub"><a href="charms-scaling.html">Scaling Services</a></li>;

in the appropriate section. Please make sure you submit a Pull Request with a
description of the new page and why it is needed!

## Adding Screenshots

When adding screenshots place them in `htmldocs/media`. To reference them in
your page use the syntax `![description](media/picture.png)`

# Testing or Deploying locally

First you need to generate the docs from the Markdown. In the root directory
first get the dependencies and make the docs:

    make sysdeps
    make

**Note:** You only need to `make sysdeps` once, after that you'll have all the
dependencies you'll need to build the docs going forward.

The documentation makes use of Javascript for some functionality, so in order
to test the docs properly you will need to have a web server set up. See
[Ubuntu and Apache](https://help.ubuntu.com/lts/serverguide/httpd.html). The
DocumentRoot should be the `htmldocs` directory:

    sudo cp -R htmldocs /var/www/htmldocs

You can then point your web browser at your local machine (127.0.0.1/htmldocs)
to view the files.

Alternatively, you can use Python to start a simple HTTP server on the docs
directory. Navigate to the `/htmldocs` directory of the docs and run the
following:

    python -m SimpleHTTPServer

# Style and Language

We are putting together a more comprehensive style guide, but for the moment the
following are good guidelines:

 - Resist being overly formal. The documentation should be like having a 
conversation with a knowledgeable friend
 - Remember the readers are *users* not necessarily Juju developers
 - Spell things properly! (see below)
 - If including links or examples, double-check they actually work
 - We enforce 80 columns for every text file to keep it readable. Here are
instructions for the [vim](http://stackoverflow.com/questions/3033423/vim-command-to-restructure-force-text-to-80-columns)
and [emacs](http://www.emacswiki.org/emacs/EightyColumnRule) editors.


## Using en-GB for en-US writers

The official language of Canonical documentation is English, or en-GB to be
more precise. There are all sorts of minor differences between English and 
American English, including spelling, verb morphology, transitives, etc.

Many of these differences will thankfully have no impact on writing the 
documentation for Juju though - it is unlikely you will be talking about 
"pants" or "hockey" or "tabling motions" for example. The main and most
notable difference is in spelling.

Popular belief is that you will merely need to add a few 'u's to words and 
change -ize to -ise everywhere. It is a bit more complicated than that though.
In fact, many -ize endings *are* acceptable in en-GB, though the -ise endings
are generally preferred. The Oxford English Dictionary Style Guide (1998) has
this to say:

"The verbal ending -ize has been in general use since the 16th century; it is
favoured in American English and in much British writing, and remains the
current preferred style of Oxford University Press in academic and general books
published in Britain. However, the alternative spelling -ise is now widespread
(partly under the influence of French), especially in Britain, and may be
adopted provided that its use is consistent.
...
A number of verbs always end in -ise in British use, notably advertise,
chastise, despise, disguise, franchise, merchandise, surmise, and all verbs
ending in -cise, -prise, -vise (including comprise, excise, prise (open),
supervise, surprise, televise, etc.), but -ize is always used for prize
(=value), capsize, size.
...
Spellings with -yze (paralyze, analyze) are only acceptable in American use."

As you can see, it can be rather tricky. And that is only the ize/ize issue.
There are many other endings which differ (e.g. -eled/-elled as in "travelled" 
and "labelled". The best way to ensure that you are using consistent en-GB 
spelling is to simply enable the en-GB dictionary on whatever software you 
generally use for writing. For example, in `vim` you could execute the command:

```
:setlocal spell spelllang=en_gb 
```

This will change the spelling highlight options for the local buffer only, so
you won't have to worry about whatever language you normally use. Do not worry
about your atrocious grammar (in either variant of the language) as the docs 
monkeys are used to tidying that up!

