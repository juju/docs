# Copyright (c) 2014, Marco Ceppi. All rights reserved.
# Use of this source code is governed by a GPLv3 license.

import re

from markdown.extensions import Extension
from markdown.treeprocessors import Treeprocessor
from markdown.util import etree


class AnchorsProcessor(Treeprocessor):
    """ Header Anchors. """

    def run(self, root):
        RE = re.compile(r'^h([1-9])$')
        for c in root:
            if RE.match(c.tag):
                if c.text:
                    id_anchor = c.text.replace(' ', '-').lower()
                    c.set('id', id_anchor)
                    etree.SubElement(c,
                                     'a',
                                     {'class': 'anchor',
                                      'href': '#' + id_anchor})
        return root


class AnchorsAwayExtension(Extension):
    """ Add definition lists to Markdown. """

    def extendMarkdown(self, md, md_globals):
        md.treeprocessors.add('anchors',
                               AnchorsProcessor(md.parser), '_end')


def makeExtension(configs={}):
    return AnchorsAwayExtension(configs=configs)
