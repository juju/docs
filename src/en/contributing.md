[ ![Juju logo](//assets.ubuntu.com/sites/ubuntu/latest/u/img/logo.png) Juju
](https://juju.ubuntu.com/)

  - Jump to content
  - [Charms](https://juju.ubuntu.com/charms/)
  - [Features](https://juju.ubuntu.com/features/)
  - [Deploy](https://juju.ubuntu.com/deployment/)
  - [Resources](https://juju.ubuntu.com/resources/)
  - [Community](https://juju.ubuntu.com/community/)
  - [Install Juju](https://juju.ubuntu.com/download/)

Search: Search

## Juju documentation

LINKS

# How you can contribute!

It's a tough job writing documentation which covers every use case and scenario
- mainly because Juju is so versatile it can be used in so many ways. That is
why we hope to get plenty of feedback from users to help extend, amend and
improve the documentation. It is really easy and you don't have to be the
world's best writer. Our grammar goblins will sort out any problems with the
words, but your knowledge is very useful to us.

## Why aren't you using Sphinx/Pandoc/Markdown...?

Because rather than force everyone to use one system of creating/editing docs,
we wanted to be more inclusive and use a pretty easy to understand, well-
recognised standard which doesn't restrict what we want to do. You CAN use any
of these systems to contribute docs by the way, but just use the HTML output
from them to add to the current docs

# How to write docs!

Contributing to the docs is really easy because it is all written in HTML5. In a
very minimal way too - you will find most of the source documents are very
straightforward and human-readable, if you just want to dip in and change a
paragraph or add some extra info.

Below is a list of the current style conventions in use in the docs.

Text is just written using standard &LT;p&GT; tags

## Sections

All the text is organised into sections. Each section has a heading, possibly
subheadings and body text/other elements, so it looks something like this:

    
    
    &LT;section id="sectionname"&GT;
      &LT;h1>Heading for section&LT;/h1&GT;
      &LT;p>This is some stuff.&LT;/p&GT;
    &LT;/section&GT;

Each section __MUST__ have an id. These are used as anchors, and it makes more
sense to attach them to sections than individual headings. Even if you think
your section will never be referenced (it will!), you should have an
id="something")

## Code Blocks

Instructions are wrapped in the following tags:

    
    
    &LT;pre class="prettyprint"&GT; &LT;/pre&GT;

## Inline code

For running copy (i.e., when a command or similar appears in the middle of a
paragraph) we use the following:

    
    
    &LT;code&GT;juju deploy minecraft&LT;/code&GT;

## Notes

Notes, other than asides, can be tagged as paragraphs, and begin with the word
"Note:" like this:

    
    
    &LT;p class="note"&GT;&LT;strong&GT;Note:&LT;/strong&GT;

It is important to use the `class="note"` property for the paragraph to pick up
the correct style.

# Adding pages

If you find you need to add a page to the documentation, then you will also need
to add it to the navigation, which means altering two additional files -
navigation.html and navigation.json

For navigation.json, you will need to enter a key:value pair in the appropriate
location, e.g.:

    
    
    "Scaling Services": "charms-scaling.html",

Note the quote marks, position of the colon, and the comma if required (i.e. if
adding a page in the middle of a list). The same entry also needs to be included
in the navigation.html page:

    
    
    &LT;li class="sub"&GT;&LT;a href="charms-scaling.html"&GT;Scaling Services&LT;/a&GT;&LT;/li&GT;

again in the appropriate section. Please make sure you submit a merge proposal
with a description of the new page and why it is needed!

# Testing or Deploying locally

The documentation makes use of Javascript for some functionality, so in order to
test the docs properly or serve them localy, you will need to have an http
server set up.

On Ubuntu this is easy. Install (if you need to) and start the apache2 web
server, then just copy the htmnldocs directory to a convenient location -

    
    
    sudo cp -R htmldocs /var/www/htmldocs

You can then point your web browser at your local machine (127.0.0.1/htmldocs)
to view the files.

Alternatively, you can use Python to start a simple HTTP server on the docs
directory. Navigate to the htmldocs directory of juju-core docs and run the
following:

    
    
    python -m SimpleHTTPServer

## Submitting your work

We love it when the community contributes to documentation, here's how to
contribute:

  - The code is available on [github.com/juju/docs](http://github.com/docs/juju)
  - [Fork the repository](https://help.github.com/articles/fork-a-repo)
  - Add or edit the documentation in your favorite text editor
  - [Submit a pull requestion](https://help.github.com/articles/creating-a-pull-request)

And that's it! Someone from the Juju team will review your work and merge it in!
Please don't forget to review the page before submission.

  - ## [Juju](/)

    - [Charms](/charms)
    - [Features](/features)
    - [Deployment](/deployment)
  - ## [Resources](/resources)

    - [Overview](/resources/juju-overview/)
    - [Documentation](/docs/)
    - [The Juju web UI](/resources/the-juju-gui/)
    - [The charm store](/docs/authors-charm-store.html)
    - [Tutorial](/docs/getting-started.html#test)
    - [Videos](/resources/videos/)
    - [Easy tasks for new developers](/resources/easy-tasks-for-new-developers/)
  - ## [Community](/community)

    - [Juju Blog](/community/blog/)
    - [Events](/events/)
    - [Weekly charm meeting](/community/weekly-charm-meeting/)
    - [Charmers](/community/charmers/)
    - [Write a charm](/docs/authors-charm-writing.html)
    - [Help with documentation](/docs/contributing.html)
    - [File a bug](https://bugs.launchpad.net/juju-core/+filebug)
    - [Juju Labs](/labs/)
  - ## [Try Juju](https://jujucharms.com/sidebar/)

    - [Charm store](https://jujucharms.com/)
    - [Download Juju](/download/)

(C) 2013 Canonical Ltd. Ubuntu and Canonical are registered trademarks of
[Canonical Ltd](http://canonical.com).

