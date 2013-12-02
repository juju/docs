#!/usr/bin/python

import os
import re
import sys
import glob

from launchpadlib.launchpad import Launchpad


def color(status):
    c = {'triaged': '\033[93m', 'new': '\033[91m', 'fix committed': '\033[92m',
         'fix released': '\033[94m', 'esc': '\033[0m'}

    return '%s%s%s' % (c[status.lower()], status, c['esc'])


def get_bugs(doc_file):
    links = get_bug_links(doc_file)
    status = {}
    for link in links:
        status[link] = get_bug_status(link)

    return status


def get_bug_links(doc_file):
    pattern = '(bugs\.launchpad\.net/.*/[0-9]+)'
    bugs = []

    try:
        with open(doc_file) as f:
            for line in f:
                m = re.search(pattern, line)
                if m:
                    url = m.group(1)
                    bugs.append(url.split('/')[-1])
    except:
        pass

    return bugs


def get_bug_status(bug_id):
    lp = Launchpad.login_anonymously('juju-docs', 'production')
    status = []
    for task in lp.bugs[1223325].bug_tasks.entries:
        status.append({task['bug_target_name']: task['status']})

    return status

if __name__ == '__main__':
    # Find htmldocs
    htmldocs = os.path.abspath(os.path.join(os.path.dirname(__file__), '..',
                                            'htmldocs'))
    bugs = {}
    if not os.path.exists(htmldocs):
        print 'Could not find htmldocs'
        sys.exit(1)

    docs = glob.glob(os.path.join(htmldocs, '*.html'))

    if docs:
        for doc in docs:
            b = get_bugs(doc)
            if b:
                bugs[os.path.basename(doc)] = b
    if bugs:
        for doc, statuses in bugs.iteritems():
            print "%s:" % doc
            for bug_id, status_data in statuses.iteritems():
                print " %s: http://pad.lv/%s" % (bug_id, bug_id)
                for d in status_data:
                    for proj, status in d.iteritems():
                        print "   # %s: %s" % (proj, color(status))
