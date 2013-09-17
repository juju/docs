#!/usr/bin/python

# Use this to build out a new header/footer or when you've updated javascript
# Don't use this if you've only updated content.

import os
import re
import sys
import glob
import json
import time


def page_title(page, source=None, itr=None):
    if not source:
        with open('../htmldocs/navigation.json', 'r') as f:
            source = json.loads(f.read())

    if 'link' in source:
        if source['link'] == page:
            return itr

    for key, val in source.iteritems():
        if isinstance(val, dict):
            code = page_title(page, val, key)
            if code:
                return code

        if val == page:
            return key

def fill_tpl(tpl, values={}):
    for key, val in values.iteritems():
        tpl = tpl.replace('{{%s}}' % key.upper(), str(val))

    return tpl

if __name__ == '__main__':
    if not os.path.exists(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'skel')):
        print "Couldn't find skeleton files"
        sys.exit(1)

    templates = glob.glob('skel/*.tpl')
    docs = glob.glob('../htmldocs/*.html')
    timestamp = int(time.time())


    for template in templates:
        with open(template, 'r') as f:
            tpl = os.path.splitext(os.path.basename(template))[0]
            tpl_file = f.read()
            chop = re.compile('<!--%s-->.*?<!--End-%s-->' % (tpl, tpl), re.DOTALL)
            for doc in docs:
                with open(doc, 'r+') as d:
                    print "%s: %s" % (doc, tpl)
                    opts = {'TIMESTAMP': timestamp}
                    new_html = chop.sub(fill_tpl(tpl_file, opts), d.read())
                    d.seek(0)
                    d.write(new_html)
                    d.truncate()
