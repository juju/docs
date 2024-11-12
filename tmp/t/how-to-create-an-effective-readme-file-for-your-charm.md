(how-to-create-an-effective-readme-file-for-your-charm)=
# How to create an effective README file for your charm

<!--
The most successful charms are those with the best documentation. It is essential that as a charm developer you empower administrators, and other developers in the community, to understand the purpose of your charm, its behaviours, failure modes and ideal deployment conditions. 

<h2 id="heading--readme">README</h2>

-->

> See also:
> - {ref}`About the README file <4463md>`
> - {ref}`How to add docs to your charm page on Charmhub <how-to-add-docs-to-your-charm-or-charm-bundle-on-charmhub>`

You've built your charm. This document guides you on how to start documenting it by creating an effective README file. 

Your charm's README file is likely to be the first encounter that people have with your charm. This document gives you a checklist of information to include in your README file so as to make it as useful and effective as possible.

The README file may include snippets from the underlying application documentation. However, the main focus should remain on the charm itself. In particular, you should make sure to include:

- A quick getting started guide for a simple deployment
- Mandatory configuration steps for minimal deployment - such as required relationships
- Links to more detailed documentation (like a [Discourse](#heading--detailed-docs) post - see below)
- Where applicable, links to the OCI image source
- Minimum requirements for a high availability deployment
- Links to complementary/supplementary charms
- Documentation for charm configuration options (if applicable)
- Documentation for charm actions (if applicable)

Your README should not include developer-specific instructions. Please include any detailed information on how to build, test and contribute to your charm in the Docs section of your charm's page on [Charmhub](https://charmhub.io/).


<!-- as part of the [Discourse/Charmhub docs](#heading--detailed-docs) outlined in the next section.-->

<!--
<h2 id="heading--detailed-docs">Detailed documentation</h2>

[Charmhub](https://charmhub.io) makes it easy to publish and collaborate on documentation for your charm. Documentation pages are managed in the [Charmhub Discourse](https://discourse.charmhub.io), which means community members can comment on them and help improve them directly. To get started documenting your charm, you must have already published your charm, and have a basic understanding of [Markdown](https://commonmark.org/help/).

Each charm has its own "Docs" page at `https://charmhub.io/<charm>/docs`. The page structure allows for a navigation bar on the left hand side, with content displayed on the right. An example of this can be seen on the Mattermost [charm page](https://charmhub.io/mattermost-charmers-mattermost/docs).

<h3 id="heading--getting-started">Getting started</h3>

To get started documenting your charm, first [create a new topic in the ‘charm’ category](https://discourse.charmhub.io/new-topic?title=%3Ccharm+name%3E%20docs+-+index&body=The+cover+page+of+your+docs.+This+should+be+some+introductory+text%0D%0Awhich+will+be+displayed+on+the+front+page++of+the+Docs+tab+for+your%0D%0Acharm.+All+the+content+above+the+%27Navigation%27+heading+below+is+part%0D%0Aof+the+cover+page.%0D%0A%0D%0A%23+Navigation%0D%0A%0D%0A%7C+Level+%7C+Path+%7C+Navlink+%7C%0D%0A%7C+--+%7C+--+%7C+--+%7C%0D%0A%7C+1+%7C++%7C+%5BOverview%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+1+%7C+install+%7C+%5Binstall%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+1+%7C+topic+%7C+%5Binstall%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%0D%0A%23+Redirects%0D%0A%0D%0A%5Bdetails%3DMapping+table%5D%0D%0A%7C+Path+%7C+Location+%7C%0D%0A%7C+--+%7C+--+%7C%0D%0A%5B%2Fdetails%5D&category=charm&tags=doc). That link should set you up with a new topic and a basic template. Here are some guidelines:

- Call your topic `<charm name> docs - index`
- Tag your topic with the `docs` tag, and also with your charm name, for example: `mattermost`
- The body of this topic should contain the cover page and navigation, including a full list of document pages for your charm
- Each page of your documentation should be a new topic in Discourse

Below is a good cover page template that will help you setup your documentation with navigation and multiple pages (if you used the [create topic link](https://discourse.charmhub.io/new-topic?title=%3Ccharm+name%3E%20docs+-+index&body=The+cover+page+of+your+docs.+This+should+be+some+introductory+text%0D%0Awhich+will+be+displayed+on+the+front+page++of+the+Docs+tab+for+your%0D%0Acharm.+All+the+content+above+the+%27Navigation%27+heading+below+is+part%0D%0Aof+the+cover+page.%0D%0A%0D%0A%23+Navigation%0D%0A%0D%0A%7C+Level+%7C+Path+%7C+Navlink+%7C%0D%0A%7C+--+%7C+--+%7C+--+%7C%0D%0A%7C+1+%7C++%7C+%5BOverview%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+1+%7C+install+%7C+%5Binstall%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+1+%7C+topic+%7C+%5Binstall%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%7C+2+%7C+Subtopic+%7C+%5BSubtopic%5D%28%2Ft%2Ftopic-title%2F%3CID%3E%29+%7C%0D%0A%0D%0A%23+Redirects%0D%0A%0D%0A%5Bdetails%3DMapping+table%5D%0D%0A%7C+Path+%7C+Location+%7C%0D%0A%7C+--+%7C+--+%7C%0D%0A%5B%2Fdetails%5D&category=charm&tags=doc), this should be populated automatically):

```markdown
The cover page of your docs. This should be some introductory text
which will be displayed on the front page of the Docs tab for your
charm. All the content above the 'Navigation' heading below is part
of the cover page.

# Navigation

| Level | Path     | Navlink                         |
| ----- | -------- | ------------------------------- |
| 1     |          | {ref}`Overview <4463md>` |
| 1     | install  | {ref}`install <4463md>`  |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |
| 1     | topic    | {ref}`install <4463md>`  |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |

# Redirects

```{dropdown} Mapping table

| Path | Location |
| ---- | -------- |

```
```

<h3 id="heading--cover-page">Cover page</h3>

```{note}

Please note that permissions to post links on Discourse are dictated by a [trust level](https://blog.discourse.org/2018/06/understanding-discourse-trust-levels/). You may need to interact with the forum before you can create your cover page with multiple links.

If you need help creating your cover page, please get in touch with us on the [Community Mattermost](https://chat.charmhub.io)

```

All of the text above your `# Navigation` header will appear on the cover page for your charm at `https://charmhub.io/<charm>/docs`. You can use Markdown [formatting](https://commonmark.org/help/) here, including headings, images, lists and code snippets. This is a good place to include the main usage of your charm and any limitations.

<h3 id="heading--nav">Navigation</h3>

The navigation section becomes essential as your documentation grows. To populate the navigation correctly, you must create a Markdown table with three columns, as shown below:

```markdown
# Navigation

| Level | Path     | Navlink                         |
| ----- | -------- | ------------------------------- |
| 1     |          | {ref}`Overview <4463md>` |
| 1     | install  | {ref}`install <4463md>`  |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |
| 1     | topic    | {ref}`install <4463md>`  |
| 2     | Subtopic | {ref}`Subtopic <4463md>` |
```

The three columns are explained below:

|  Column   | Description                                                                                                                                                                                                                                                                                                                                                       |
| :-------: | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  `Level`  | Used to create a tree structure in the navigation. Level 1 corresponds to a top-level item in the navigation                                                                                                                                                                                                                                                      |
|  `Path`   | This value will be used to transform any Discourse URL to a path in your charm docs. For example: `install` creates a doc path at `charmhub.io/<charm name>/docs/install`                                                                                                                                                                                         |
| `Navlink` | This column specifies the link to the Discourse topic. This should be specified as a Markdown link `{ref}`text <4463md>``. An example Discourse topic link for this column is: `{ref}`install <4463md>``. Here, `4563` is the topic ID. This number uniquely identifies the Discourse topic, even if the title of the topic is changed at a later date. |

<h3 id="heading--redirects">Redirects</h3>

Redirects enable you to change the path to a specific doc at a later date should the need arise. Redirects are specified in a table, similar to the navigation section. The table must be in a section named `Redirects`. An example is shown below:

```markdown
# Redirects

```{dropdown} Mapping table

| Path | Location |
| -------------------------- | -------------------------- |
| <charm name>/docs/old-path | <charm name>/docs/new-path |

```
```

When the above table is specified, anyone visiting `charmhub.io/<charm name>/docs/old-path` would be automatically redirected to `charmhub.io/<charm name>/docs/new-path`.

<h3 id="heading--adding-pages">Adding pages</h3>

You can create as many documentation pages as you like for your charm. Each page just requires a new topic. Each new topic should have the tags `doc` and `<charm name>`. Don’t forget to update your documentation cover page with a link to the topic, and you may want to add the new topic to the navigation too.

You do not need to specify a navigation or redirect section in additional pages, these will be automatically handled by the documentation index topic.

<h3 id="heading--linking-charms-docs">Linking charms and docs</h3>

Once you have created your documentation pages, you need to tell Charmhub which index page to use for your charm. You can do this by updating your charm’s `metadata.yaml`, and then re-publishing it. The link belongs under the `docs` key in the `metadata.yaml` file like so:

```yaml
# ...
docs: https://discourse.charmhub.io/t/<charm name>-docs-index/9999
# ...
```

Now build and publish your charm with `charmcraft` and your docs page should be live!

<h2 id="heading--docs-examples">Documentation examples</h2>

A great example of some documentation maintained this way is the [Snapcraft documentation](https://snapcraft.io/docs). You can also see the corresponding [Discourse post](https://forum.snapcraft.io/t/snap-documentation/11127) for inspiration.

-->