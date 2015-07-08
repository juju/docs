#!/usr/bin/env python
"""
A tool to convert Juju docs markdown -> html
"""

# imports
import os
import sys
import shutil
import markdown
import fnmatch
import re
import codecs
import argparse


# config

extlist=['meta', 'def_list']
extcfg=[]

# global
args=[]
template=''
nav=''


def getargs():
    d_text = """This version of mdbuild is specifically designed for use 
                with the Juju documentation at https://github.com/juju/docs"""
    parser = argparse.ArgumentParser(description=d_text)
    parser.add_argument('--file', nargs=1, dest='file', help="process single file")
    parser.add_argument('--source', nargs=1, default='./src/', help="source directory")
    parser.add_argument('--log', dest='debug',action='store_true', help="turn on logging")
    parser.add_argument('--quiet', dest='quiet',action='store_true', help="disable STDOUT")
    parser.add_argument('--outfile', nargs=1, default='./htmldocs', help="output path")
    return (parser.parse_args())  

def main():
    
    args = getargs()   
    t=codecs.open(os.path.join(args.source,'base.tpl'), encoding='utf-8')
    template = t.read()
    t.close()
    t=codecs.open(os.path.join(args.source,'navigation.tpl'), encoding='utf-8')
    print extlist
    print args.file


# Classes

class Page:
    """A page of data"""
    
    def __init__(self, filename, mdparser):
        self.filename=filename
        self.content=''
        self.output=''
        self.parser=mdparser
        self.load_content()
        
    def load_content(self):
    	i=codecs.open(self.filename, mode="r", encoding="utf-8")
        self.content = i.read()
    
    def convert(self):
        self.pre_process()
        self.parse()
        self.post_process()
        
    
    def pre_process(self):
        """Any actions which should be taken on raw markdown before
           parsing."""
        return

    def parse(self):
        self.output = self.parser.convert(self.content)

    def post_process(self):
        """Any actions which should be taken on generated HTML
           after parsing."""

        #extract metadata
        title=self.parser.Meta['title'][0]
        #copy template
        self.output=template
        #replace tokens
        replace= [ ('$TITLE', title),                       \
                   ('$CONTENT', content)     \
                 ]
        for pair in replace:
            self.output = re.sub(pair[0], pair[1], self.output)
        self.parser.reset()
        
    def write(self,filepath):
        filepath = os.path.splitext(filepath)[0]+'.html'
        if not os.path.exists(os.path.dirname(filepath)):
            os.makedirs(os.path.dirname(filepath))
        file=codecs.open(filepath,"w",encoding="utf-8",errors="xmlcharrefreplace")
        file.write(self.output)
        file.close


if __name__ == "__main__":
    main()
