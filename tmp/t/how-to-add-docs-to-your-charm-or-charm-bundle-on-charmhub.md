(how-to-add-docs-to-your-charm-or-charm-bundle-on-charmhub)=
# How to add docs to your charm or charm bundle on Charmhub

This document shows how to add docs to your charm or charm bundle page on [Charmhub](https://charmhub.io/). 

**Prerequisites:**

- An account on [the Charmhub Discourse](https://discourse.charmhub.io/). 
- Optionally, some knowledge of the [CommonMark Markdown](https://commonmark.org/help) format [supported by Discourse](https://talk.commonmark.org/t/discourse-is-migrating-to-commonmark/2476). 
    - If you don't have that, no worries -- the template in this doc will give you sufficient examples to get you started!

**Contents:**

1. [Create the docs on Discourse](#heading--create-the-docs-on-discourse)
1. [Link the docs from the source code](#heading--link-the-docs-from-the-source-code)


<a href="#heading--create-the-docs-on-discourse"><h2 id="heading--create-the-docs-on-discourse">Create the docs on Discourse</h2></a>

On the Charmhub Discourse, click on the **+New Topic** button. 
![image|690x118](upload://iqMVNTgpe97FlRpH0Bzos96Lq7G.png)  

This will open up a split window, with an editor panel on the left and a preview panel on the right. 

In the editor panel, update the title on the template "`<charm / charm bundle name>` docs - index", update the category to `charm` (it's the same for bundles), and update the tags to `docs` and `<charm / charm bundle name>`. 

Copy-paste the template below into the editor panel:

```{caution}

Because we wanted you to be able to see here both comments and target text, we enclosed the entire template within triple quotes, ` ``` `. Make sure to remove them before you start editing.

```

---
```{dropdown} Expand to see the template


```
<!--
UPDATE THE TEMPLATE BELOW TO INTRODUCE YOUR CHARM:
-->

**A single sentence that says what the product is, succinctly and memorably** consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

**A paragraph of one to three short sentences, that describe what the product does.** Urna cursus eget nunc scelerisque viverra mauris in. Nibh mauris cursus mattis molestie a iaculis at vestibulum rhoncus est pellentesque elit. Diam phasellus vestibulum lorem sed

**A third paragraph of similar length, this time explaining what need the product meets.** Dui ut ornare lectus sit amet est. Nunc sed augue lacus viverra vitae congue eu consequat ac libero id faucibus nisl tincidunt eget nullam.

**Finally, a paragraph that describes whom the product is useful for.** Nunc non blandit massa enim nec dui nunc mattis enim. Ornare arcu odio ut sem nulla pharetra diam porttitor leo a diam sollicitudin tempor id eu. Ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant.

<!--
For example:
CODE NAME OF CHARM, E.G., `TRAEFIK-K8S` is a [Kubernetes | Machine charm](https://juju.is/docs/olm/charmed-operator) for NAME OF UPSTREAM APPLICATION / SERVICE.

This charm automates the deployment and operation of {ref}`NAME OF UPSTREAM APPLICATION / SERVICE <3784md>` on any Kubernetes | Machine-type cloud.

As a result, it makes managing cloud operations for NAME OF UPSTREAM APPLICATION / SERVICE easier than ever before: to deploy, run `juju deploy NAME OF CHARM`; to SOME OTHER POPULAR OPERATION, run `juju...`; etc.

This charm will benefit anyone who is struggling with PROBLEM THE APPLICATION / SERVICE SOLVES, is interested in a solution based on NAME OF THE UPSTREAM APPLICATION, and wants it cloud-ready.
-->

<!-- 
IF YOU HAVE OVERVIEW PAGES FOR THE VARIOUS DIATAXIS (https://diataxis.fr/) CATEGORIES: UNCOMMENT AND UPDATE THE SECTION BELOW AS WELL.
-->

<!--

## In this documentation

| | |
|-|-|
| {ref}`Tutorial <3784md>`</br> **Get started** - a hands-on introduction to Example Product for new users </br> | {ref}`How-to guides <3784md>` </br> **Step-by-step guides** covering key operations and common tasks | 
| {ref}`Explanation <3784md>` </br> Discussion and clarification of key topics | {ref}`Reference <3784md>` </br> **Technical information** - specifications, APIs, architecture |

-->

<!--
UPDATE THE SECTION BELOW TO REFLECT YOUR CHARM'S DETAILS.
NOTE: FEEL FREE TO ADD ANY OTHER RELEVANT LINKS, E.G., A LINK TO THE CHARM'S DISCUSSION FORUM.
-->

## Project and community

Example Charm / Charm Bundle is a member of the Ubuntu family. It’s an open source project that warmly welcomes community projects, contributions, suggestions, fixes and constructive feedback.

* [Code of conduct](https://ubuntu.com/community/ethos/code-of-conduct)
* {ref}`Get support <3784md>`
* {ref}`Join our online chat <3784md>`
* {ref}`Contribute <3784md>`
* {ref}`Roadmap <3784md>`

Thinking about using Example Charm / Charm Bundle for your next project? {ref}`Get in touch! <3784md>`

<!--IF YOU WANT TO SEE THIS DOC AS WELL AS FURTHER DOCS IN THE SIDE NAVIGATION OF THE DESCRIPTION TAB OF YOUR CHARM'S PAGE ON CHARMHUB: UNCOMMENT AND UPDATE THE NAVIGATION TABLE BELOW.

NOTES ON THE SYNTAX:
- LEVEL = NESTEDNESS LEVEL. CAN BE ONE OF 1, 2, 3.
- PATH = URL IN https://charmhub.io/CHARM-NAME/URL 
- NAVLINK = TITLE TO BE DISPLAYED IN THE SIDE-NAVIGATION OF THE DESCRIPTION TAB OF YOUR CHARM'S PAGE ON CHARMHUB ALONG WITH ITS TRUNCATED DISCOURSE LINK. TIP: IF YOU WANT THE TITLE TO SHOW IN NAVIGATION BUT DO NOT YET HAVE A PAGE TO ATTACH TO IT, YOU CAN LEAVE THE LINK EMPTY.

NOTES ON THE CONTENT:
- THE HOME PAGE IS THIS INDEX PAGE.
- TUTORIAL, HOW-TO GUIDES, REFERENCE, EXPLANATION ARE OVERVIEW PAGES FOR EACH DIATAXIS CATEGORY: https://diataxis.fr/ 
- THE PAGES NESTED UNDER REFERENCE ARE THE PREGENERATED ACTIONS, CONFIGURATIONS, INTEGRATIONS, LIBRARIES, RESOURCES TABS OF YOUR CHARM. THEY ALL CONTAIN REFERENCE-TYPE INFORMATION.


CAUTION: 
- ROWS WITH AN EMPTY LEVEL IN THE MIDDLE OF THE TABLE WILL CAUSE AN ERROR.
- ROWS COMMENTED OUT IN THE MIDDLE OF THE TABLE WILL CAUSE AN ERROR. 
-->

<!--

# Navigation

| Level | Path | Navlink |
| -- | -- | -- |
| 1 |  | {ref}`Home <3784md>` |
| 1 | tutorial | {ref}`install <3784md>` |
| 1 | how-to | {ref}`How-to guides <3784md>` |
| 2 | configure | {ref}`Configure <3784md>`
| 1 | reference | {ref}`Reference <3784md>` |
| 2 | actions | {ref}`Actions <3784md>` |
| 2 | configurations | {ref}`Configurations <3784md>` |
| 2 | integrations | {ref}`Integrations <3784md>` |
| 2 | libraries | {ref}`Libraries <3784md>` |
| 2 | resources | {ref}`Resources <3784md>`
| 1 | explanation | {ref}`Explanation <3784md>` |

-->

<!--
IF YOU NEED TO REDIRECT FROM AN OLD URL TO A NEW URL, UNCOMMENT AND UPDATE THE REDIRECTS TABLE BELOW ON THE TEMPLATE: | /EXAMPLE-CHARM/docs/OLD-URL | /EXAMPLE-CHARM/docs/NEW-URL |
-->

<!--

# Redirects

{ref}`details=Mapping table]
| Path | Location |
| -- | -- |

```

-->

```
[/details]

-------------


In the editor window, follow all the "update"  instructions in the comments to fill in the information for your charm / charm bundle.

(For now, ignore all  the "*uncomment and* update" instructions. You will likely not be able to update the information there right away anyway. It is there primarily to give you a preview of what your documentation should look like in the end.)

Click **+ Create Topic** to save and create the doc.

At this point you can start editing again, e.g., to uncomment and update the Navigation table with a row for the docs index page itself and potentially also other docs. Or you can leave that for a future iteration and go ahead and publish this doc to the charm's page on Charmhub.
 
```{caution}

Do not wait for things to be perfect! Some documentation is better than none. If you're happy with the Home page, but do not have time to work on other docs right away, do not wait -- go ahead and publish! Just don't forget to keep iterating! 

```


<a href="#heading--link-the-docs-from-the-source-code"><h2 id="heading--link-the-docs-from-the-source-code">Link the docs from the source code</h2></a>

 ### Charm
For a charm, in the `charmcraft.yaml` file of your charm, add a `links.documentation` field, passing as a value the full Discourse link of your charm's docs index page:

```yaml
links:
  documentation: https//discourse.charmhub.io/t/<discourse-id>
```

> See more: [File `charmcraft.yaml` > `links` > `documentation` <3784md>`

### Bundle

For a bundle, in the `bundle.yaml` of your bundle, add a `docs` field, passing as a value the full Discourse link of your bundle's docs index page:

```yaml
docs: https//discourse.charmhub.io/t/<discourse-id>
```

> See more: {ref}`File `bundle.yaml` > docs <3784md>`

---

Once your change is merged into the repository's main branch, go to the charm or charm bundle's Charmhub page on the `edge` channel to view the docs. To do this, add the `?channel=edge` URL param after the URL. For example, in the case of MLflow Server, the URL is `https://charmhub.io/mlflow-server?channel=edge`.

If you want to see the documentation on the charm / charm bundle's main page (without the `?channel=edge` URL param), you will need to build, push, and release your updated charm.

> See more: {ref}`How to publish your charm on Charmhub <how-to-publish-your-charm-on-charmhub>`

Done!