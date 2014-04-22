# Copyright (c) 2014, Marco Ceppi. All rights reserved.
# Use of this source code is governed by a GPLv3 license.

import re

from markdown.extensions import Extension
from markdown.blockprocessors import BlockProcessor
from markdown.util import etree


class FoldoutProcessor(BlockProcessor):
    """ Process Callouts. """

    def test(self, parent, block):
        sibling = self.lastChild(parent)
        return bool(block.startswith('^#') or
                    (block.startswith(' ' * 2) and sibling and
                     sibling.tag == 'details'))

    def run(self, parent, blocks):
        sibling = self.lastChild(parent)
        block = blocks.pop(0)

        if block.startswith('^#'):
            head = block.split('\n')[0].replace('^#', '').strip()
            block = '\n'.join(block.split('\n')[1:])
            details = etree.SubElement(parent, 'details')
            details.set('id', head.replace(' ', '-'))
            etree.SubElement(details, 'summary').text = '**%s**' % head
        else:
            details = sibling

        tl = self.tab_length
        self.tab_length = 2
        block, theRest = self.detab(block)
        self.tab_length = tl
        self.parser.parseChunk(details, block)

        if theRest:
            blocks.insert(0, theRest)


class DefFoldoutExtension(Extension):
    """ Add foldouts to Markdown. """

    def extendMarkdown(self, md, md_globals):
        """ Add an instance of FoldoutProcessor to BlockParser. """
        md.parser.blockprocessors.add('foldout',
                                      FoldoutProcessor(md.parser),
                                      '_begin')


def makeExtension(configs={}):
    return DefFoldoutExtension(configs=configs)
