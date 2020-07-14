The [Juju documentation][juju-docs] web site has now ceased to use [GitHub][github-juju-docs]. Its holding and editing place is now this very Discourse forum.

This means that forum members will be able to edit/create documentation pages themselves, according to the [trust level][discourse-trust-level] system built into Discourse. Because the web site will be updated automatically, the docs have effectively become a wiki.

The documentation now resides under the [Docs][discourse-docs] category. There is a pinned topic that acts as the [table of contents][doc-toc]. The sub-category [Docs-discuss][discourse-docs-discuss] is to be used for documentation-related subjects (stuff that is not intended to be published on the web site).

Documentation issues are still managed on the GitHub [bug tracker][github-juju-docs-issues].

## Writing guidelines

Documentation editors are to use the [Documentation guidelines][doc-guidelines]. This will be important for maintaining the quality and the consistency of the documentation.

## Version signposting

Previously there were distinct Juju versions you could select on the web site. Going forward, there will be a single documentation link, with its contents being exactly what resides in the 'Docs' category on this Discourse site.

There will therefore be the need for editors to "signpost" documented features in order for users to know what version provides what features. See [Versioning][doc-guidelines-versioning] in the guidelines page for details.

Legacy versions (2.5 and earlier) will be archived for viewing on a separate domain.

## Large community-contributed pieces

We may have a place within the table of contents (navigation menu) to link to large community-contributed pieces of text. These pages may also be labelled as such. An example of this are tutorials. There is a concern that such contributions may include a writing style and organisation that differs significantly enough from the existing body of documentation to result in a poor user experience on the web site. It is hoped that such pieces will eventually be kneaded into the rest of the documentation. Ideally, then, editors should strive to base their writing on the style of the existing documentation and make full use of the aforementioned documentation guidelines.

## Timeframe

**Documentation file import**
The documentation has already been imported several times into Discourse and has undergone a QA process. There is still one lingering issue (lack of Markdown support within admonishments) but this is not a blocker. Admonishments also currently suffer from a colour problem.

**Web site publishing**
The automatic publishing of changes made in Discourse won't be ready immediately. This will occur by mid-April 2019. Consequently, there will be a window of a few weeks where documentation updates will only be visible within Discourse.


<!-- LINKS -->

[juju-docs]: https://docs.jujucharms.com
[github-juju-docs]: https://github.com/juju/docs
[github-juju-docs-issues]: https://github.com/juju/docs/issues
[discourse-trust-level]: https://blog.discourse.org/2018/06/understanding-discourse-trust-levels
[discourse-docs]: /c/docs/none
[discourse-docs-discuss]: /c/docs/docs-discuss
[doc-toc]: /t/juju-documentation
[doc-guidelines]: /t/documentation-guidelines
[doc-guidelines-versioning]: /t/documentation-guidelines/1245#heading--versioning
