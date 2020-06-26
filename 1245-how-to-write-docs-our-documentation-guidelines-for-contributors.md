Our documentation is a community effort, [published][juju-docs] via the [DIscourse][upstream-discourse] forum hosted at [discourse.jujucharms.com][juju-discourse]. We welcome corrections and enhancements as well as suggestions and constructive criticism.

You can modify (almost) any page by visiting the Discourse [Docs][discourse-docs] category, where each documentation web page corresponds to a Discourse topic. In addition, every web page has a link that leads directly to its corresponding topic. All you need to do is sign up on the forum.

If you're unsure of your intended contribution you can leave a post on the topic in question asking for guidance. Finally, the sub-category [Docs-discuss][discourse-docs-discuss] is available for documentation related subjects.

## Contents

 - [Writing style](#heading--writing-style)
 - [Versioning](#heading--versioning)
 - [Line length](#heading--line-length)
 - [Emoji](#heading--emoji)
 - [Source format](#heading--source-format)
   - [Headings and titles](#heading--headings-and-titles)
   - [Lists](#heading--lists)
   - [Tables](#heading--tables)
   - [Code blocks](#heading--code-blocks)
   - [Inline code](#heading--inline-code)
   - [Hyperlinks](#heading--hyperlinks)
   - [Anchors](#heading--anchors)
   - [Admonishments](#heading--admonishments)
   - [Comments](#heading--comments)
   - [Foldouts](#heading--foldouts)
   - [Images](#heading--images)

<h2 id='heading--writing-style'>Writing style</h2>

Documentation consistency in terms of writing style is vital for a good user experience.

Here are some general tips:

- define acronyms and concepts&ndash;don't assume others are familiar with the subject
- use a spell checker
- resist being overly formal
- resist being overly verbose
- verify links and examples
- don't repeat what's been covered in other posts - use hyperlinks

We adhere to the [Canonical Documentation Style Guide][canonical-doc-style-guide]. We've also supplemented that guide with [some more Juju-specific details](/t/language-details-contributing-to-juju-docs/1104). In particular:
- we use British English (en-GB), for example:
  -   the _ise_ suffix in preference to _ize_ (_capitalise_ rather than _capitalize_)
  - _our_ instead of _or_ (as in _colour_ and _color_)
  - license as a verb, licence as a noun
  - catalogue rather than catalog
- dates take the format _1 January 2013_, _1-2 January 2013_ and _1 January - 2 February 2013_

<h2 id='heading--versioning'>Versioning</h2>

There are no distinct versions of the documentation that correspond to Juju software versions. Instead, a single pool of documentation pages is used to cover all software versions. This means that when a new feature is documented it must be communicated to the reader what Juju version it applies to.

Associating a feature to a Juju version is done by formatting the version in this way (for 2.5.0):

`v.2.5.0`

Examples:

> In `v.2.5.0`, charms are allowed to include a LXD profile.

> As for the `bootstrap` command, the `--to` option is limited to either pointing to a MAAS node  
or, starting in `v.2.5.0`, to a LXD cluster node.

> Kubernetes charms (`v.2.5.0`) can be deployed when the backing cloud is a Kubernetes cluster.

> Here is a list of advanced LXD features supported by Juju that are explained elsewhere:                                                                       
>
>  - [LXD clustering][clouds-lxd-advanced-cluster] (`v.2.4.0`)
> - [Adding a remote LXD cloud][clouds-lxd-advanced-remote] (`v.2.5.0`)
> - [Charms and LXD profiles][clouds-lxd-advanced-profiles] (`v.2.5.0`)

### Changes in behaviour between versions

Juju doesn't change its defaults lightly. But it has happened. Use an [admonishment](#admonishments) to call this out, under the assumption that the reader of the body copy is using the most recent stable version of the client.

```plain
[note status="Using a version of Juju older than `v.2.3`?"]
In Juju 2.3, changed the `add-awesome` command to use `--full-throttle` by default.
[/note]
```

[note status="Using a version of Juju older than v.2.3?"] 
In Juju `v.2.3`, changed the `add-awesome` command to use `--full-throttle` by default.
[/note]

<h2 id='heading--line-length'>Line length</h2>

Discourse honours the line length in its editor. Therefore, ensure that a paragraph does not take on a jagged appearance (long lines mixed with short lines). Use common sense when inserting line breaks so the resulting text "looks good" to the reader.

Note that the web site will continue to respect the extra whitespace.

<h2 id='heading--emoji'>Emoji</h2>

Please do not use emoji in the documentation. They would be published on the web site and that's not appropriate. :woman_shrugging: 

<h2 id='heading--source-format'>Source format</h2>

Documentation is written in the [CommonMark Markdown][upstream-commonmark] format [supported by Discourse][upstream-commonmark-format].

Mostly, you don't need to worry about the syntax. You can simply use the style toolbar in the
Discourse topic editing window to mark the elements you need.

[note type="positive" status="Pro tip"]
If you can't get the results you want try to find a similar post and use the following URL format to view its raw markdown `https://forum.example.com/raw/{topic-id}/{post-id}`. See [the current post](/raw/1245/1) for an example.
[/note]

Individual elements are now explained. Some formatting can be achieved in more than one way (headings in particular). Kindly use the methods described in order to maintain consistency throughout the documentation.

<h3 id='heading--headings-and-titles'>Headings and titles</h3>

```markdown
## Subheading within a document
### Subheading of a subheading
```

We don't use the top-level heading (`# Heading`) as the topic title serves this purpose.

Headings and subheadings should use _sentence case_, which means the first letter is the only one capitalised. Proper nouns and acronyms are exceptions.

<h3 id='heading--lists'>Lists</h3>

For a bullet list, use a hyphen ( - ). Sub-lists will use an hyphen indented at least 2 spaces:

```markdown
We (mostly) adhere to the Ubuntu style guide, for example:
- we use British English (en-GB):
  - the _ise_ suffix in preference to _ize_ 
```

For a numbered list, use  `1. ` to precede each item. The numbering will be rendered automatically. One benefit is that it's simple to insert new items:

```markdown
1. This is the first item
1. This is the second
1. This is the third
    1. This is a sub-list 
```

The indent here needs to be at least 3 spaces.

Unless a list item is particularly long (which should be avoided) and includes punctuation, don't end the item with a full stop. If one item needs a full stop, add one to all the items.

<h3 id='heading--tables'>Tables</h3>

An example table:

heading 1 | heading 2 | heading 3
-|-|-
cloud | user | pass
type | access | key

It is produced by the following markdown:

```markdown
heading 1 | heading 2 | heading 3
-|-|-
cloud | user | pass
type | access | key
```

Use colons for horizontal alignment:

heading 1 | heading 2 | heading 3
:-|:-:|-:
left | centered | right
type | access | key

The markdown:

```markdown
heading 1 | heading 2 | heading 3
:-|:-:|-:
left | centered | right
type | access | key
```

Left-aligned is the default, and does not need to be stated.

The number of dashes has no effect on the final result.

<h3 id='heading--code-blocks'>Code blocks</h3>

Enclose a code block with three backticks and include the *type* of code:

    ```yaml
    name: gimp
    version: '2.10.8'
    summary: GNU Image Manipulation Program
    ```

The most common code types are: `bash`, `yaml`, `json`, and `text`. The last is like a miscellaneous type. It is often used to display command output and does not highlight anything.

Do separate command input blocks from command output blocks. For input, do **not** use a command line prompt (e.g. `$` or `#`) and precede the output block with some kind of intelligent message:

```bash
lsb_release -r
```

Sample output:

```no-highlight
Release:        18.04
```

<h3 id='heading--inline-code'>Inline code</h3>

Use a backtick to mark inline commands and other literals. For instance, to create `$SNAP_DATA`:

```markdown
For instance, to create `$SNAP_DATA`:
```

<h3 id='heading--hyperlinks'>Hyperlinks</h3>

For links to internal files or external URLs, use the following format:

```markdown
[visible text](url)
```

<!--
To make things crisper and more legible you can also use an intermediary label and then associated that label with the actual URL (usually at the bottom of the document):

```markdown
[visible text][label]
.
.
.
[label]: url
```

The `visible text` is what will appear in the documentation.
-->

For internal pages the full URL is not necessary. The below forms will also work for, say, `https://discourse.jujucharms.com/t/clouds/1100`:

```markdown
[Clouds](/t/clouds/1100)
```

Or just:

```markdown
[Clouds](/t/clouds)
```

For linking to headers (see next section 'Anchors'), this can be used:

```markdown
[Adding clouds](/t/clouds/1100#heading--adding-clouds)
```

Or, if within the same page:

```markdown
[Adding clouds](#heading--adding-clouds)
```

<h3 id='heading--anchors'>Anchors</h3>

To link to a header within the same page or in another page you will need to use HTML tags.

To create a link to the (second-level) destination header of "Adding clouds" edit the header on the destination page (`clouds` here) so it changes from this:

```markdown
## Adding clouds
```

to this:

```markdown
<a id="adding-clouds"></a>
## Adding clouds
```

#### Linking to anchors

Once you've established the `<a id="adding-clouds">`, linking to it is easy:

```markdown
About [adding clouds](/t/clouds/1100#adding-clouds).
```

Or, if within the same page:

```markdown
#adding-clouds
```


#### Transitioning from an older convention 

Until August 2019, the documentation team used a different anchor convention. The guide recommended using specific HTML heading tags and prefixing anchor IDs with `heading--`.  This makes updates to the structure more difficult because heading names and levels become fixed.

You will encounter pages with the following syntax:

```html
<h2 id='heading--adding-clouds'>Adding clouds</h2>
```

Please replace them with the following, which will preserve any deep links: 

```markdown
<a id="adding-clouds"></a><a id="heading--adding-clouds"></a>
## Adding clouds
```
<a id='heading--admonishments'></a>
### Admonishments (also known as sidebars or boxed text)

To highlight something, you can use *admonishment*. Admonishments are self-contained snippets that are not part of the main flow of the document. They're also used as *sidebars* in printed works. The wording is correct if the admonishment can be understood independently of the body copy and removing it does not impact readers' understanding of the surrounding text.

#### Syntax for admonishments

Admonishments in Discourse use BBtext markup syntax. Using `[note]` ... `[/note]` draws a box around the contained text. 

```markdown
[note type="important" status="Info"]
An informative note. This box is dark blue.
[/note]
```

This produces:

[note type="important" status="Info"]
An informative note.
[/note]

You can omit the status header.

```plain
[note type="important"]
A note without a title.
[/note]
```

And its output:

[note type="important"]
A note without a title.
[/note]

The `type` parameter is optional, but recommended:

```plain
[note]
A note that only uses default settings.
[/note]
```

And its output:

[note]
A note that only uses default settings.
[/note]


#### Types of `[note]`

Changing the `type` parameter changes how it is presented to the reader:

- `important` (default)
- `caution`
- `positive`
- `negative`

The below examples are produced using type and status combinations of 'caution/Warning', 'positive/High score', and 'negative/Game over', respectively:

[note type="caution" status="Warning"]
Here be dragons.

Uses `caution` type.
[/note]

[note type="positive" status="High score"]
Great work.

Uses `positive` type.
[/note]

[note type="negative" status="Game over"]
Please try again.

Uses `negative` type.
[/note]

Hyperlinks cannot be word-wrapped within admonishments. Doing so will not format the links.

<h3 id='heading--comments'>Comments</h3>

Here we'll explain two ways to leave comments in a page. Doing either will prevent the text from being published on the documentation web site.

Firstly, there may be times when a little explanation (to other editors) is required amidst a page. Use standard HTML comment tags:

```markdown
<!--
The reason for doing it this way was due to blah blah blah.
-->
```

Secondly, intended work may get left undone or there may be external circumstances that affect the documentation (e.g. software bugs). These things should also be noted for future editors. Use a TODO list for this within a comment at the very top of a document:

```markdown
<!--
TODO:
 - Critical: general review required
 - Ubuntu codenames hardcoded. Remove Trusty when EOL
 - Bug tracking: https://bugs.launchpad.net/juju/+bug/1797399
 - This text is not visible on the doc web site but it is within Discourse.
-->
```

<h3 id='heading--foldouts'>Foldouts</h3>

When a page contains a lot of extraneous information, such as software code or file contents, a *foldout* can be used. This will create a collapsed header, which, when clicked, will expand to display all the content below it.

```markdown
[details=This is the visible header]
This text is completely hidden.
The reader clicks the header to reveal its contents.
[/details]
```

The above will produce:

[details=This is the visible header]

This text is completely hidden.
The reader clicks the header to reveal its contents.

[/details]

<h3 id='heading--images'>Images</h3>

Most of our documentation covers command line tools, editing and developing. However, if relevant, we highly encourage the use of images. An image should be easier to understand than text, reinforce concepts being discussed in the topic, and break the monotony of a long stream of paragraphs.

When making images:

- do not crop your images too aggressively; add a little extra to provide context
- use a resolution high enough to make text legible and work with high-DPI displays
- a wide aspect ratio fits better with the width of the rendered documentation
- save with lossless compression, such as PNG for screenshots (JPG is acceptable for photos)

Images can be simply dragged and dropped into the edit field, or uploaded (local device or a public URL) via the toolbar icon. It can be helpful to edit the description field of an image link after uploading:

```markdown
![description of image](<location>)
```

To resize images use the following syntax:

```markdown
![Original|200x200](<location>)
![Percent|200x200, 50%](<location>)
![By Pixels|64x64](<location>)
```

For example:

![image|300x311](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg) ![image|300x311,50%](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg) ![image|100x104,50%](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg)

These images are produced with the following:

```markdown
![image|300x311](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg) ![image|300x311,50%](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg) ![image|100x104,50%](upload://xRC5B91fbxVhoUaFWQh4eQTZFfD.jpg)
```

<!-- LINKS -->

[juju-docs]: https://docs.jujucharms.com
[upstream-discourse]: https://www.discourse.org
[juju-discourse]: https://discourse.jujucharms.com
[discourse-docs]: /c/docs/none
[discourse-docs-discuss]: /c/docs/docs-discuss
[canonical-doc-style-guide]: https://docs.ubuntu.com/styleguide/en
[upstream-commonmark]: https://commonmark.org/help
[upstream-commonmark-format]: https://talk.commonmark.org/t/discourse-is-migrating-to-commonmark/2476
[clouds-lxd-advanced-cluster]: /t/using-lxd-with-juju-advanced/#heading--lxd-clustering
[clouds-lxd-advanced-remote]: /t/using-lxd-with-juju-advanced/#heading--adding-a-remote-lxd-cloud
[clouds-lxd-advanced-profiles]: /t/using-lxd-with-juju-advanced/#heading--charms-and-lxd-profiles
[documentation-guidelines-raw]: /raw/1245/1
