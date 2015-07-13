
build:
	PYTHONPATH="$(CURDIR)/tools/plugins:$(CURDIR)/tools/plugins/gfm:$(PYTHONPATH)" tools/build-from-source $(doc)

new:
	tools/mdbuild.py
serve:
	cd htmldocs/en ; python -m SimpleHTTPServer

sysdeps:
	sudo apt-get install python-html2text python-markdown python-pip git
	sudo pip install mdx-anchors-away mdx-callouts mdx-foldouts gfm

multi:
	tools/make_versions.sh

watch:
	@echo "Requires watchdog module to be installed. - to install pip install watchdog."	
	@tools/watch.sh

.PHONY: build serve sysdeps multi watch
