Title: Juju Quickstart

# Juju Quickstart

The ***quickstart*** utility was used with earlier versions (1.x) of Juju. It was designed to help users quickly deploy charms and bundles with those versions of Juju and allowed editing and management of various different Juju clouds.

The functionality provided by `juju quickstart` is not supported or required in the current version of Juju. Most of this functionality (native support for bundles, interactive setup for clouds) is now included in Juju itself. If you encounter any charm documentation, blog posts or other online sources that specify the use of `quickstart` it is likely they refer to a bundle. Bundles can now be deployed directly by Juju in the same ways as charms. See the current documentation on ["Using and Creating Bundles"][bundles] for more details.

!!! Note:
    The `juju-quickstart` package still exists in the archive for 14.04 (trusty). This is to
    support users of 1.25.x.

[bundles]: ./charms-bundles#adding-bundles-from-the-command-line
