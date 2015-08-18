
build:
	tools/mdbuild.py
serve:
	cd htmldocs; python -m SimpleHTTPServer

sysdeps:
	sudo apt-get install python-html2text python-markdown python-pip git spell ispell ibritish
	sudo pip install mdx-anchors-away mdx-callouts mdx-foldouts

multi:
	tools/make_versions.sh

spell:
	spell -b `find src/en -name "*.md"` | sort | uniq 

.PHONY: build serve sysdeps multi spell
