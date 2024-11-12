(how-to-create-an-icon-for-your-charm)=
# How to create an icon for your charm

> See also:
> - {ref}`File 'icon.svg' <file-iconsvg>`
> - {ref}`How to publish your charm on Charmhub <how-to-publish-your-charm-on-charmhub>`
> - {ref}`How to add docs to your charm page on Charmhub <how-to-add-docs-to-your-charm-or-charm-bundle-on-charmhub>`

You've released your charm to the `stable` channel on Charmhub. This document shows you how to make it more stand out by adding a unique and recognisable icon for it. 

**Contents:**

- [Icon specifications](#heading--icon-specifications)
- [Creating an icon](#heading--creating-an-icon)
- [Open the template](#heading--open-the-template)
- [Add colour](#heading--add-colour)
- [Draw something](#heading--draw-something)
- {ref}`Validate your icon <1041md>`
- [And finally... some quick Dos and Don'ts](#heading--and-finally-some-quick-dos-and-donts)

 <a href="#heading--icon-specifications"><h2 id="heading--icon-specifications">Icon specifications</h2></a>


Before we start actually making the icon though, we should be aware of the specifications required by the charm store. This is to ensure a consistent experience for the users, and icons failing to meet this spec will be rejected.

A charm icon is an SVG format image where the canvas size is 100x100 pixels. It consists of a circle with a flat color and a logo.
It has to be saved as `icon.svg` in your charm's root directory.

There is no specification to design the logo: it can be a white (or black) monochromatic symbol, a colored logo, or whatever is best. However, it's best to leave some padding between the edges of the circle and the logo.

 <a href="#heading--creating-an-icon"><h2 id="heading--creating-an-icon">Creating an icon</h2></a>


If meeting the above spec seems more complicated than creating your charm in the first place, then fear not, because we have an easy step-by-step guide for you. Before you start you will need:

-   A vector graphic editor. We strongly recommend the cross-platform and most excellent [Inkscape](http://www.inkscape.org) for all your vector graphic needs.
-   [The template file.](https://assets.ubuntu.com/v1/fc0260eb-icon.svg) (right-click &gt; Save link as...)
-   An existing logo you can import, or the ability to draw one in Inkscape.

Once you have those, fire up Inkscape and we can begin!

 <a href="#heading--open-the-template"><h2 id="heading--open-the-template">Open the template</h2></a>


From Inkscape load the **icon.svg** file. Select the Layer called "Background Circle", either from the drop down at the bottom, or from the layer dialog.

![Step one](https://assets.ubuntu.com/v1/067f88a5-author-charm-icons-1.png)

 <a href="#heading--add-colour"><h2 id="heading--add-colour">Add colour</h2></a>

Select **Object** and then **Fill and Stroke** from the menu to adjust the color.

![Step two](https://assets.ubuntu.com/v1/0bff03c4-author-charm-icons-2.png)


 <a href="#heading--draw-something"><h2 id="heading--draw-something">Draw something</h2></a>


Draw your shape within the circle. If you already have a vector logo, you can import it and scale it within the guides. Inkscape also has plenty of drawing tools for creating complex images.

If you import a bitmap image to use, be sure to convert it into a vector file and delete the bitmap.

![Step four](https://assets.ubuntu.com/v1/2ef5c7f5-author-charm-icons-3.png)

*Cloud icon: "Cloud by unlimicon from the Noun Project" [CC BY]*

```{note}

To add the icon to the charm's Charmhub page, save it as `icon.svg`, 
 place it in the root directory of the charm, and then publish the charm to `latest/stable`.

```

<a href="#heading--validate-icon"><h2 id="heading--validate-icon">Validate your icon</h2></a>

You can validate your icon at [charmhub.io/icon-validator](https://charmhub.io/icon-validator). The page checks the most basic issues that prevent icons working.

![Icon Validator screenshot](upload://lQbz7TOCLHnq1dEBe98qxPMxWkK.png) 

 <a href="#heading--and-finally-some-quick-dos-and-donts"><h2 id="heading--and-finally-some-quick-dos-and-donts">And finally... some quick Dos and Don'ts</h2></a>
 
Icons should not be overly complicated. Charm icons are displayed in various sizes (from 160x160 to 32x32 pixels) and they should be always legible. In Inkscape, the ‘Icon preview’ tool can help you to check the sharpness of your icons at small sizes.

Symbols should have a similar weight on all icons: avoid too thin strokes and use the whole space available to draw the symbol within the limits defined by the padding. However, if the symbol is much wider than it is high, it may overflow onto the horizontal padding area to ensure its weight is consistent.

Do not use glossy materials unless they are parts of a logo that you are not allowed to modify.

```{note}

BEWARE:  unless your charm has (or has had at some point) a release in the `stable` channel, the icon will not be visible. That is because charmhub only updates the metadata for a charm on stable channel releases [(by design)](https://snapcraft.io/blog/better-snap-metadata-handling-coming-your-way-soon).
So either release to `stable` and then roll it back, or wait until your charm is ready for a "stable" `stable` release. 

```