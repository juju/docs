# Copyright (c) 2014, Marco Ceppi. All rights reserved.
# Use of this source code is governed by a GPLv3 license.

import re

from markdown.extensions import Extension
from markdown.blockprocessors import BlockProcessor
from markdown.util import etree


class CalloutProcessor(BlockProcessor):
    """ Process Callouts. """

    def test(self, parent, block):
        return bool(block.startswith('**Note:** '))

    def run(self, parent, blocks):
        raw_block = blocks.pop(0)
        p = etree.SubElement(parent, 'p')
        p.set('class', 'note')
        p.text = raw_block.replace('!!', '', 1)


class DefListExtension(Extension):
    """ Add definition lists to Markdown. """

    def extendMarkdown(self, md, md_globals):
        """ Add an instance of DefListProcessor to BlockParser. """
        md.parser.blockprocessors.add('callout',
                                      CalloutProcessor(md.parser),
                                      '_begin')


def makeExtension(configs={}):
    return DefListExtension(configs=configs)
