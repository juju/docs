#!/usr/bin/python

import optparse
import glob
import codecs
import os
import shutil
import logging

import markdown
from Cheetah.Template import Template
from git import Repo
import yaml

logging.basicConfig(level=logging.DEBUG)


class DocBuilder(object):

    def __init__(self, config, versions):
        self.config = config
        self.versions = versions

    def run(self):
        '''
        Main entry point for building the docs.
        '''
        for v in self.versions:
            logging.info('Building docs for %s', v)
            try:
                self.build(v, 'en')
            except:
                logging.exception('skipping version "%s" due to error', v)
                continue

    def build(self, version, lang, doc=None):
        '''
        Handle building a single version of the docs.
        '''
        try:
            self.repo = Repo('.')
        except:
            logging.exception('unable to find git repository')
        original_ref = self.repo.head.reference
        try:
            # Grab the correct version.
            assert not self.repo.bare
            assert not self.repo.is_dirty()
            self.checkout(version)

            # Load markdown files.
            if doc:
                files = ['%s/%s/%s' % (self.config['docs_dir'], lang, doc)]
            else:
                pattern = '%s/%s/*.md' % (self.config['docs_dir'], lang)
                files = glob.glob(pattern)
            if not file:
                # No docs to build, log and return.
                logging.warning('did not find any doc files to build')
                return

            # Load markdown extensions.
            exts = self.load_markdown_extensions()

            # Convert the content to HTML.
            content = dict()
            for f in files:
                try:
                    text = codecs.open(f, mode='r', encoding='utf-8')
                except ValueError:
                    logging.exception('unable to decode "%s" as utf-8', f)
                    continue
                try:
                    content[f] = markdown.markdown(text.read(),
                                                   extensions=exts)
                except:
                    logging.exception('unable to convert markdown for "%s"', f)
                    continue

            # Theme the content.
            self.theme_content(version, lang, content)

            # Combine assets into build directory.
            html_root = self.html_root(version, lang)
            # Copy from the theme.
            self.copy_assets(self.config['theme_dir'], html_root)
            # Copy from the global content.
            self.copy_assets(self.config['docs_dir'], html_root)
            # Copy from the localized content.
            localized_root = '%s/%s' % (self.config['docs_dir'], lang)
            self.copy_assets(localized_root, html_root)
        except:
            logging.exception('error while building docs')
        finally:
            # Always reset to the original HEAD.
            self.checkout(original_ref)

    def load_markdown_extensions(self):
        '''
        Return a list of Markdown extensions ready for use.
        '''
        try:
            from mdx_callouts import DefListExtension
            from mdx_partial_gfm import PartialGithubFlavoredMarkdownExtension
            from mdx_anchors_away import AnchorsAwayExtension
            from mdx_foldouts import DefFoldoutExtension
            return [
                DefListExtension(),
                PartialGithubFlavoredMarkdownExtension(),
                AnchorsAwayExtension(),
                DefFoldoutExtension(),
                'markdown.extensions.meta',
            ]
        except ImportError:
            logging.warning('unable to load Markdown extensions')
            return []

    def theme_content(self, version, lang, content):
        '''
        Theme the content using the Cheetah templates.
        '''
        with open(self.config['template_file'], 'r') as f:
            tmpl_src = f.read()
        with open(self.config['nav_file'], 'r') as f:
            nav = f.read()
        tmpl = Template.compile(tmpl_src, baseclass=dict)
        for (k, v) in content.iteritems():
            filename = os.path.splitext(os.path.basename(k))[0]
            html_root = self.html_root(version, lang)
            html_path = '%s/%s.html' % (html_root, filename)
            with open(html_path, 'w') as f:
                try:
                    templated = tmpl(CONTENT=v, DOCNAV=nav)
                except:
                    logging.exception('templating error for "%s"', html_path)
                    continue
                try:
                    f.write(str(templated))
                except:
                    logging.exception('unable to write themed HTML for "%s"',
                                      html_path)
                    continue

    def html_root(self, version, lang):
        '''
        Finds the target directory for building docs and ensures that it
        exists.
        '''
        html_root = '%s/%s/%s' % (
            self.config['site_dir'],
            version,
            lang,
        )
        if not os.path.exists(html_root):
            os.makedirs(html_root)
        return html_root

    def checkout(self, ref):
        '''
        Simplify the process of checking out a git branch or tag.
        '''
        if ref == 'latest':
            ref = self.config['default_branch']
        try:
            # Make sure we have the latest refs from origin.
            origin = self.repo.remote(name='origin')
            origin.fetch()
            # Point the head at the ref.
            if isinstance(ref, basestring):
                self.repo.head.reference = self.repo.references[ref]
            else:
                self.repo.head.reference = ref
            self.repo.head.reset(index=True, working_tree=True)
        except:
            logging.exception('unable to checkout "%s" due to error', ref)

    def copy_assets(self, src, target):
        '''
        Consolidate repetitive logic of moving around asset files.
        '''
        def cp(d):
            src_root = '%s/%s' % (src, d)
            target_root = '%s/%s' % (target, d)
            files = glob.glob('%s/*' % src_root)
            if files and not os.path.exists(target_root):
                os.makedirs(target_root)
            for f in files:
                copy = '%s/%s' % (target_root, os.path.basename(f))
                shutil.copyfile(f, copy)
        cp('media')
        cp('css')
        cp('js')


def main():
    # Parse command line args and options.
    parser = optparse.OptionParser()
    parser.add_option('-f', '--file',
                      help='builds a specific file',
                      dest='file')
    parser.add_option('-V', '--version',
                      help='builds a specific version of the docs',
                      dest='version')
    parser.add_option('-l', '--language',
                      help='builds a specific translation of the docs',
                      dest='lang',
                      default='en')
    (opts, args) = parser.parse_args()

    # Load the config.
    config = dict()
    with open('build.yml', 'r') as f:
        config = yaml.load(f)

    # Grab the right versions
    if opts.version:
        versions = [opts.version]
    else:
        versions = config['versions']

    builder = DocBuilder(config, versions)
    builder.run()


if __name__ == '__main__':
    main()
